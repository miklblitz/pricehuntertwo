# frozen_string_literal: true

module Goods
  class FillupFavorites < ApplicationService
    def initialize(args)
      @products = args.fetch(:products)
      @current_user = args.fetch(:current_user)
    end

    def call
      favorites_for_user = fetch_favorites_for_user
      favorites_hash = {}
      favorites_for_user.each do |favorites|
        favorites_hash[favorites.goods_key] = favorites.id
      end

      @products.map do |product|
        product["favorite_id"] = favorites_hash[product["key"]].present? ? favorites_hash[product["key"]] : nil
      end if favorites_for_user.present?

      @products
    end

    private

    def fetch_favorites_for_user
      Favorite.where(goods_key: @products.pluck("key"), user: @current_user)
    end
  end
end
