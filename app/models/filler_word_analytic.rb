class FillerWordAnalytic < ApplicationRecord
  belongs_to :video

  # Validations
  validates :word, presence: true
  validates :count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
