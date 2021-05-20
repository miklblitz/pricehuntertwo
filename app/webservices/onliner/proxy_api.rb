module Onliner
  class ProxyApi
    def initialize
      @conn = Faraday.new(url: 'https://catalog.api.onliner.by/') do |conn|
        conn.request :url_encoded
        conn.request :multipart
        conn.response :json, content_type: /\bjson$/

        conn.use :instrumentation
        conn.adapter Faraday.default_adapter
      end
    end

    # история цен
    # https://catalog.api.onliner.by/products/champion24116/prices-history
    def prices_history(key)
      response = get_request("/products/#{key}/prices-history")
      {body: response.body, status: response.status}
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