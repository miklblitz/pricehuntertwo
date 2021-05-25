class GoodsController < ApplicationController

  # главная + поиск
  def index
    param! :page, Integer, default: 1

    response = Onliner::Proxy.new.catalog_search_products({ query: params[:query], page: params[:page] }.as_json)

    if response["body"].present? && response["body"]["products"].present?
      has_favorites = Favorite.where(goods_key: response["body"]["products"].pluck("key"))
      favorites_hash = {}
      has_favorites.each { |favorites| favorites_hash[favorites.goods_key] = favorites.id }

      response["body"]["products"].map do |product|
        product["favorite_id"] = favorites_hash[product["key"]].present? ? favorites_hash[product["key"]] : nil
      end

      @data = OpenStruct.new
      @data.data = response["body"]["products"]
      @data.current_page = params[:page]
      @data.total_pages = response.dig("body", "page", "last")
    end
  end

  # конкретный товар
  def show
    response = Onliner::Proxy.new.product(params[:id])
    response_positions = Onliner::Proxy.new.positions(params[:id], { town: 'all' })


    @data = response["body"] if response["body"].present?
    @data_positions = response_positions["body"] if response_positions["body"].present?
  end

  # имитация для крона
  def run_job
    users = User.all
    users.each do |user|
      SendDataJob.perform_now(user.id)
    end

    render plain: "OK"
  end

  private

  def good_params
    params.require(:good).permit(:query, :page)
  end
end
