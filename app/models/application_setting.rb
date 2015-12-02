class ApplicationSetting < ActiveRecord::Base
  validates :application_name, :expiration_of_session, presence: true
  validates :application_name, length: { in: 1..16, allow_blank: true }
  validates :expiration_of_session,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_blank: true }
end
