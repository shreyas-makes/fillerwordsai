require 'rails_helper'

RSpec.describe FillerWordAnalytic, type: :model do
  describe 'associations' do
    it { should belong_to(:video) }
  end

  describe 'validations' do
    it { should validate_presence_of(:word) }
    it { should validate_presence_of(:count) }
    it { should validate_numericality_of(:count).only_integer.is_greater_than_or_equal_to(0) }
  end
end
