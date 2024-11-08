class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :time_zone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name), message: "%{value} is not a valid time zone" }, allow_nil: true
end
