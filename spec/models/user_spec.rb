require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe 'associations' do
    it { should have_many(:videos).dependent(:destroy) }
  end

  describe 'ActiveModel validations' do
    it { expect(subject).to validate_presence_of(:email) }
    
    it { should allow_value(nil).for(:plan_type) }
    it { should allow_value('monthly').for(:plan_type) }
    it { should allow_value('one_time').for(:plan_type) }
    it { should_not allow_value('invalid_plan').for(:plan_type) }
    
    it { should allow_value(nil).for(:credits_remaining) }
    it { should validate_numericality_of(:credits_remaining).only_integer.is_greater_than_or_equal_to(0).allow_nil }
    
    it { should allow_value(nil).for(:silence_threshold) }
    it { should validate_numericality_of(:silence_threshold).is_greater_than(0).is_less_than(1).allow_nil }
  end

  describe 'serialization' do
    it 'serializes custom_filler_words as JSON' do
      user = User.new(custom_filler_words: ['um', 'like', 'you know'])
      expect(user.custom_filler_words).to eq(['um', 'like', 'you know'])
    end
  end
end
