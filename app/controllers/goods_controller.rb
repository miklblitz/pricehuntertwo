class GoodsController < ApplicationController

  # главная + поиск
  def index
    param! :page, Integer, default: 1

    response = Onliner::Proxy.new.catalog_search_products({ query: params[:query], page: params[:page] }.as_json)

    if response["body"].present? && response["body"]["products"].present?
      @data = OpenStruct.new

      @data.data = Goods::FillupFavorites.call(
        products: response["body"]["products"],
        current_user: current_user
      )
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
