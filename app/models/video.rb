class Video < ApplicationRecord
  belongs_to :user
  has_many :filler_word_analytics, dependent: :destroy
  has_one_attached :file

  serialize :filler_words, coder: JSON
  serialize :timestamps, coder: JSON, default: []

  # Validations
  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending processing completed failed] }
  validates :file_type, presence: true, inclusion: { in: %w[video audio] }
  validates :original_file_url, presence: true
  validates :progress, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validates :retry_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :custom_pause_threshold, numericality: { greater_than: 0, less_than: 1 }, allow_nil: true

  # File type detection
  def detect_file_type
    return if file.blank?
    
    content_type = file.content_type
    if content_type.start_with?('video/')
      self.file_type = 'video'
    elsif content_type.start_with?('audio/')
      self.file_type = 'audio'
    end
  end

  # Start MediaConvert processing
  def start_processing
    return false unless status == 'pending'
    
    # Queue the job
    VideoProcessingJob.perform_later(id)
    true
  end

  # Check if the video has finished processing
  def finished_processing?
    status == 'completed'
  end

  # Calculate total filler word count
  def total_filler_word_count
    return 0 if filler_words.blank?
    
    filler_words.sum { |_, data| data[:count] || 0 }
  end

  # Get processing progress percentage
  def progress_percentage
    progress || 0
  end

  # Set status to pending on creation
  before_create :set_initial_status
  before_create :detect_file_type

  private

  def set_initial_status
    self.status = 'pending' if status.blank?
    self.progress = 0 if progress.blank?
    self.retry_count = 0 if retry_count.blank?
  end
end
