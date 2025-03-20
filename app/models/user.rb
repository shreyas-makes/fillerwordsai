class User < ApplicationRecord
  include Signupable
  include Onboardable
  include Billable

  has_many :videos, dependent: :destroy

  serialize :custom_filler_words, coder: JSON

  scope :subscribed, -> { where.not(stripe_subscription_id: [nil, '']) }

  # Validations
  validates :plan_type, inclusion: { in: %w[monthly one_time] }, allow_nil: true
  validates :credits_remaining, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :silence_threshold, numericality: { greater_than: 0, less_than: 1 }, allow_nil: true

  # :nocov:
  def self.ransackable_attributes(*)
    ["id", "admin", "created_at", "updated_at", "email", "stripe_customer_id", "stripe_subscription_id", "paying_customer"]
  end

  def self.ransackable_associations(_auth_object)
    []
  end
  # :nocov:
end
