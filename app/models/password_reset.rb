class PasswordReset
  include ActiveModel::AttributeMethods
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_accessor :password, :password_confirmation, :reset_password_token

  validates :password, :presence => true, :confirmation => true

  def initialize(attributes = {})
    attributes ||= {}
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

end
