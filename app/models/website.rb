class Website < ApplicationRecord
  has_many :responses, dependent: :destroy
end
