module Refinery
  module Memberships
    include ActiveSupport::Configurable

    config_accessor :new_user_path,:admin_email

    self.new_user_path = nil
    self.admin_email = 'youremail@example.com'
    
   
  end
end