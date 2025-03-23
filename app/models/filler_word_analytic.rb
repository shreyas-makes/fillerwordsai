class FillerWordAnalytic < ApplicationRecord
  belongs_to :video

  serialize :timestamps, coder: JSON, default: []

  # Validations
  validates :word, presence: true
  validates :count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  # Add a timestamp occurrence
  def add_timestamp(time_in_seconds)
    current_timestamps = self.timestamps || []
    current_timestamps << time_in_seconds
    update(timestamps: current_timestamps)
  end
  
  # Get all timestamps as an array of floats
  def timestamp_points
    self.timestamps || []
  end
end
