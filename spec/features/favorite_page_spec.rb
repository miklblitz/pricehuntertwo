require 'spec_helper'

RSpec.describe 'Visit Favorite Goods page' do
  context 'without auth' do
    it "retirect to login" do
      visit '/favorites/goods'
      expect(current_path).to eq("/users/sign_in")
    end
  end

  context 'with auth' do
    
  end
end
