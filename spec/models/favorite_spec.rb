# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe 'валидация' do
    it { should belong_to(:user) }
  end
end
