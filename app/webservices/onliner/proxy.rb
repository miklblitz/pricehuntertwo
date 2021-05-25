module Onliner
  class Proxy
    def initialize
      @conn = Faraday.new(url: 'https://catalog.onliner.by/') do |conn|
        conn.request :url_encoded
        conn.request :multipart
        conn.response :json, content_type: /\bjson$/

        conn.use :instrumentation
        conn.adapter Faraday.default_adapter
      end
    end

    # список схем где найдены товары по запросу query - удалить если не будет пользовтаься
    # /sdapi/catalog.api/search/schemas?query=my_query
    def catalog_search_schemas(query)
      response = get_request("/sdapi/catalog.api/search/schemas", query)
      { body: response.body, status: response.status }.as_json
    end

    # список товаров по запросу query
    # /sdapi/catalog.api/search/products?query=my_query
    def catalog_search_products(query)
      response = get_request("/sdapi/catalog.api/search/products", query)
      { body: response.body, status: response.status }.as_json
    end

    # конкретный товар
    # /sdapi/catalog.api/products/powermaxxbsbasic
    def product(key)
      response = get_request("/sdapi/catalog.api/products/#{key}")
      { body: response.body, status: response.status }.as_json
    end

    # список цен для разных магазов
    # https://catalog.onliner.by/sdapi/shop.api/products/powermaxxbsbasic/positions?town=all {town: 'all'}
    def positions(key, query)
      response = get_request("/sdapi/shop.api/products/#{key}/positions?", query)
      { body: response.body, status: response.status }.as_json
    end

    private

    def get_request(url, params = nil)
      resp = @conn.get do |req|
        req.url url
        req.params = params if params
      end

      resp
    rescue StandardError => e
      raise StandardError, e.message
    end
  end
end
