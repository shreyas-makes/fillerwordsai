class Video < ApplicationRecord
  belongs_to :user
  has_many :filler_word_analytics, dependent: :destroy

  serialize :filler_words, coder: JSON

  # Validations
  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending processing completed failed] }
  validates :file_type, presence: true, inclusion: { in: %w[video audio] }
  validates :original_file_url, presence: true
  validates :progress, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validates :retry_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :custom_pause_threshold, numericality: { greater_than: 0, less_than: 1 }, allow_nil: true
end
