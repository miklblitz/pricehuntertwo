class AddPricesToFavorites < ActiveRecord::Migration[6.0]
  def change
    add_column :favorites, :old_price, :float, default: 0.0
    add_column :favorites, :new_price, :float, default: 0.0
    add_column :favorites, :currency, :string
  end
end
