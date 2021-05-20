class SendDataJob < ApplicationJob
  queue_as :default

  def perform(*args)
    user_id = args[0]

    if user_id
      favorites = Favorite.where(user_id: user_id, is_notify: true)
      @goods = []
      favorites.each do |favorite|
        response_positions = Onliner::Proxy.new.positions(favorite.goods_key, { town: 'all' })

        if response_positions.body.is_a?(Hash)
          minimal_price = []
          response_positions.body["positions"]["primary"].select do |g|
            minimal_price << g["position_price"]["amount"].to_f
          end
          minimal_exists = minimal_price.sort.try(:first)

          if minimal_exists.to_f < favorite.new_price || favorite.new_price == 0
            favorite.update_attributes({
                                         old_price: favorite.new_price,
                                         new_price: minimal_exists.to_f,
                                         currency: 'RYB'
                                       })
            @goods << {
              id: favorite.goods_key,
              price: minimal_exists.to_f,
              currency: favorite.currency
            }
          else
            @goods << {
              id: favorite.goods_key,
              price: nil,
              currency: ''
            }
          end
        end
      end

      ActionCable.server.broadcast "room_channel_#{user_id}", content: { topic: 'price', body: @goods }
    end
  end
end
