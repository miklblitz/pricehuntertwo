class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_favorite, only: %i[update]

  # GET /favorites or /favorites.json
  def goods
    favorites = Favorite.where(user_id: current_user.id)

    @goods = []
    favorites.each do |favorite|
      response = Onliner::Proxy.new.product(favorite.goods_key)

      if response["body"].is_a?(Hash)
        response["body"]["favorite_id"] = favorite.id
        response["body"]["favorite_checked"] = favorite.is_notify
        response_prices = Onliner::ProxyApi.new.prices_history(favorite.goods_key)
        myhash = Hash.new
        response_prices[:body]["chart_data"]["items"].map { |e| myhash[e["date"]] = e["price"] }
        response["body"]["history_price"] = myhash
        @goods << response["body"]
      end
    end
    @products = @goods ? @goods.map(&:deep_symbolize_keys) : []
  end

  # POST /favorites or /favorites.json
  def create
    @favorite = Favorite.new(favorite_params)
    @favorite.user_id = current_user.id

    if @favorite.save
      render @favorite, status: :created
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /favorites/1 or /favorites/1.json
  def update
    if @favorite.update(favorite_params)
      ActionCable.server.broadcast "room_channel", content: DateTime.now
      render json: @favorite, status: :ok
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  def delete_by_favorite
    Favorite.find_by(goods_key: params[:goods_key], user_id: current_user.id).try(:destroy)

    head :no_content
  end

  def get_data
    SendDataJob.perform_now(current_user.id)

    render json: [], status: :ok
  end

  private

  def set_favorite
    @favorite = Favorite.find_by(id: params[:id], user_id: current_user.id)
  end

  def favorite_params
    params.require(:favorite).permit(:goods_key, :is_notify)
  end
end
