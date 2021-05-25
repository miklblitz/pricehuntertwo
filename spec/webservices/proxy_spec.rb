# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Onliner::Proxy, type: :model do
  describe 'catalog_search_products' do
    let(:search_response) { Onliner::Proxy.new.catalog_search_products({ query: 'бензопила', page: 1 }.as_json) }
    let(:data) { JSON.parse(file_fixture("catalog_search_products.json").read) }

    before(:each) do
      response = { body: data, status: "success" }
      allow_any_instance_of(Onliner::Proxy).to receive(:catalog_search_products).with(
        { "page" => 1,
          "query" => "бензопила" }
      ).and_return(response.as_json)
    end

    it "correct response" do
      expect(search_response["body"]).to be_kind_of(Hash)
      expect(search_response["body"]).to eq(data)
      expect(search_response["status"]).to eq("success")
    end
  end

  describe 'product' do
    let(:product_response) { Onliner::Proxy.new.product("бензопила") }
    let(:data) { JSON.parse(file_fixture("product.json").read) }

    before do
      response = { body: data, status: "success" }
      allow_any_instance_of(Onliner::Proxy).to receive(:product).with(
        "бензопила"
      ).and_return(response.as_json)
    end

    it "correct response" do
      expect(product_response["body"]).to be_kind_of(Hash)
      expect(product_response["body"]).to eq(data)
      expect(product_response["status"]).to eq("success")
    end
  end

  describe 'positions' do
    let(:product_response) { Onliner::Proxy.new.positions("test", { town: 'all' }) }
    let(:data) { JSON.parse(file_fixture("positions.json").read) }

    before do
      response = { body: data, status: "success" }
      allow_any_instance_of(Onliner::Proxy).to receive(:positions).with(
        "test",
        { town: 'all' }
      ).and_return(response.as_json)
    end

    it "correct response" do
      expect(product_response["body"]).to be_kind_of(Hash)
      expect(product_response["body"]["positions"]["primary"]).to be_kind_of(Array)
      expect(product_response["status"]).to eq("success")
    end
  end
end
