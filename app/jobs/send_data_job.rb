class SendDataJob < ApplicationJob
  queue_as :default

  def perform(*args)
    user_id = args[0]

    if user_id
      favorites = Favorite.where(user_id: user_id, is_notify: true)
      @goods = []

      favorites.each do |favorite|
        response_positions = Onliner::Proxy.new.positions(favorite.goods_key, { town: 'all' })

        if response_positions["body"].is_a?(Hash)
          (minimal_price, maximum_price) = ::OnlinerLib.get_minimal_price(response_positions["body"]["positions"]["primary"])

          new_price = favorite.new_price
          currency = 'BYN'

          @goods << {
            id: favorite.goods_key,
            price: (minimal_price.to_f < new_price || favorite.new_price == 0) ? minimal_price.to_f : nil,
            currency: currency,
            min_max: "#{minimal_price} #{currency}  - #{maximum_price} #{currency}"
          }

          favorite.update_attributes({
                                         old_price: favorite.new_price,
                                         new_price: minimal_price.to_f,
                                         currency: currency
                                     })

        end
      end

      ActionCable.server.broadcast "room_channel_#{user_id}", content: { topic: 'price', body: @goods }
    end
  end
end
