# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FavoritesController, type: :controller do

  describe 'GET #goods' do
    render_views

    context 'with auth' do
      login_user
      it 'returns a success response' do
        get :goods
        expect(response).to be_successful
        expect(response.body).to include("Мои отслеживаемые товары")
      end
    end

    context 'without auth' do
      it 'returns a success response' do
        get :goods
        expect(response.status).to eq(302)
      end
    end
  end

end
