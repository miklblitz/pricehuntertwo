# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'валидация' do
    it { should have_many(:favorites) }
  end
end
