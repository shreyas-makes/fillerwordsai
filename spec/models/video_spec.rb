require 'rails_helper'

RSpec.describe Video, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:filler_word_analytics).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(%w[pending processing completed failed]) }
    it { should validate_presence_of(:file_type) }
    it { should validate_inclusion_of(:file_type).in_array(%w[video audio]) }
    it { should validate_presence_of(:original_file_url) }
    
    it { should allow_value(nil).for(:progress) }
    it { should validate_numericality_of(:progress).only_integer.is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100).allow_nil }
    
    it { should allow_value(nil).for(:retry_count) }
    it { should validate_numericality_of(:retry_count).only_integer.is_greater_than_or_equal_to(0).allow_nil }
    
    it { should allow_value(nil).for(:custom_pause_threshold) }
    it { should validate_numericality_of(:custom_pause_threshold).is_greater_than(0).is_less_than(1).allow_nil }
  end

  describe 'serialization' do
    it 'serializes filler_words as JSON' do
      video = Video.new(filler_words: ['um', 'like', 'you know'])
      expect(video.filler_words).to eq(['um', 'like', 'you know'])
    end
  end
end
