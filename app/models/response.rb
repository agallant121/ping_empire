class Response < ApplicationRecord
  belongs_to :website

  validates :status_code, numericality: true, allow_nil: true
  validates :response_time, numericality: true, allow_nil: true
  validates :checked_at, presence: true
end