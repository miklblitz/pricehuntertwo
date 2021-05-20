# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Onliner::Proxy, type: :model do
  describe 'catalog_search_products' do
    let(:search_response) { Onliner::Proxy.new.catalog_search_products({ query: 'бензопила', page: 1 }.as_json) }

    response = {body: {
        "products": [
            { "id": 485349, "key": "powermaxxbsbasic", "name": "PowerMaxx BS Basic 600080500 (с 2-мя АКБ 2 Ah)",
              "full_name": "Metabo PowerMaxx BS Basic 600080500 (с 2-мя АКБ 2 Ah)", "name_prefix": "Дрель-шуруповерт", "extended_name": "Дрель-шуруповерт Metabo PowerMaxx BS Basic 600080500 (с 2-мя АКБ 2 Ah)", "schema": { "key": "screwdriver" }, "status": "active", "images": { "header": "//content2.onliner.by/catalog/device/header/fe3b7342a430519125ea07324d051113.jpg", "icon": "//content2.onliner.by/catalog/device/icon/83b81d0963812ec625bf15b462b0e683.jpg" }, "description": "питание: аккумулятор, Li-ion, 1400 об/мин, напряжение аккумулятора: 10.8 В, ёмкость аккумулятора: 2 А·ч, 800 г", "html_url": "https://catalog.onliner.by/screwdriver/metabo/powermaxxbsbasic", "reviews": { "rating": 45, "count": 78, "html_url": "https://catalog.onliner.by/screwdriver/metabo/powermaxxbsbasic/reviews", "url": "https://catalog.api.onliner.by/products/powermaxxbsbasic/reviews" }, "review_url": "null", "url": "https://catalog.api.onliner.by/products/powermaxxbsbasic", "prices": { "min": "null", "price_min": { "amount": "210.00", "currency": "BYN", "converted": { "BYN": { "amount": "210.00", "currency": "BYN" }, "BYR": { "amount": "", "currency": "BYR" } } }, "max": "null", "price_max": { "amount": "303.60", "currency": "BYN", "converted": { "BYN": { "amount": "303.60", "currency": "BYN" }, "BYR": { "amount": "", "currency": "BYR" } } }, "currency_sign": "null", "offers": { "count": 31 }, "html_url": "https://catalog.onliner.by/screwdriver/metabo/powermaxxbsbasic/prices", "url": "https://shop.api.onliner.by/products/powermaxxbsbasic/positions" }, "second": { "offers_count": 1, "min_price": { "amount": "195.00", "currency": "BYN" } } }, { "id": 2148811, "key": "df333dyx14", "name": "DF333DYX14 (с 2-мя АКБ, кейс +набор оснастки)", "full_name": "Makita DF333DYX14 (с 2-мя АКБ, кейс +набор оснастки)", "name_prefix": "Дрель-шуруповерт", "extended_name": "Дрель-шуруповерт Makita DF333DYX14 (с 2-мя АКБ, кейс +набор оснастки)", "schema": { "key": "screwdriver" }, "status": "active", "images": { "header": "//content2.onliner.by/catalog/device/header/868a96b27e307ab2f8dfb68b774cbe91.jpeg", "icon": "null" }, "description": "питание: аккумулятор, Li-ion, 1700 об/мин, напряжение аккумулятора: 12 В, ёмкость аккумулятора: 1.5 А·ч, 1100 г", "html_url": "https://catalog.onliner.by/screwdriver/makita/df333dyx14", "reviews": { "rating": 45, "count": 5, "html_url": "https://catalog.onliner.by/screwdriver/makita/df333dyx14/reviews", "url": "https://catalog.api.onliner.by/products/df333dyx14/reviews" }, "review_url": "null", "url": "https://catalog.api.onliner.by/products/df333dyx14", "prices": { "min": "null", "price_min": { "amount": "219.95", "currency": "BYN", "converted": { "BYN": { "amount": "219.95", "currency": "BYN" }, "BYR": { "amount": "", "currency": "BYR" } } }, "max": "null", "price_max": { "amount": "296.84", "currency": "BYN", "converted": { "BYN": { "amount": "296.84", "currency": "BYN" }, "BYR": { "amount": "", "currency": "BYR" } } }, "currency_sign": "null", "offers": { "count": 22 }, "html_url": "https://catalog.onliner.by/screwdriver/makita/df333dyx14/prices", "url": "https://shop.api.onliner.by/products/df333dyx14/positions" }, "second": { "offers_count": 0, "min_price": "null" } }
        ], "total": 2791, "page": { "limit": 10, "items": 2, "current": 1, "last": 2 }
    }, status: "success"}
    before(:each) do
      allow_any_instance_of(Onliner::Proxy).to receive(:catalog_search_products).with({"page"=>1, "query"=>"бензопила"}).and_return(response.as_json)
    end

    it "correct response" do
      expect(search_response["body"]).to be_kind_of(Hash)
      search_response["body"].deep_symbolize_keys.should == response[:body]
      search_response["status"].should == "success"
    end
  end

  # describe 'product' do
  #   let(:product_response) { Onliner::Proxy.new.product("test")}
  #
  #   before(:each) do
  #     search_response = {
  #       :status => 'success',
  #       :data => []
  #     }
  #     stub_request(:get, "https://catalog.onliner.by/sdapi/catalog.api/products/test")
  #       .to_return(status: 200, body: search_response.to_json, headers: {})
  #   end
  #
  #   it "correct response" do
  #     expect(JSON.parse(product_response.body)).to be_kind_of(Hash)
  #     product_response.body.should == { status: "success", data: [] }.to_json
  #     product_response.status.should == 200
  #   end
  # end
end
