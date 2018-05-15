class User < ApplicationRecord
  has_many :duties, dependent: :destroy
  validates_format_of :name, :with => /[-\w]/i
end
