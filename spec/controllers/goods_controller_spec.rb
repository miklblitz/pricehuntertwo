# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoodsController, type: :controller do

  describe 'GET #index' do
    render_views
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
      expect(response.body).to include("Поиск:")
    end
  end

  describe 'GET #show' do
    let(:data) { JSON.parse(file_fixture("positions.json").read) }
    let(:data_product) { JSON.parse(file_fixture("product.json").read) }

    before {
      response = { body: data_product, status: "success" }
      allow_any_instance_of(Onliner::Proxy).to receive(:product).with(
        "test"
      ).and_return(response.as_json)
      response = { body: data, status: "success" }
      allow_any_instance_of(Onliner::Proxy).to receive(:positions).with(
          "test",
          { town: 'all' }
      ).and_return(response.as_json)
    }

    render_views
    it 'returns a success response' do
      get :show, params: { id: "test" }
      expect(response).to be_successful
      expect(response.body).to include("Название магазина")
    end
  end

end
