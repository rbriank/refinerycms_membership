module Refinery
  module Memberships
    include ActiveSupport::Configurable

    config_accessor :new_user_method_path,:admin_email

    self.new_user_method_path = :new_refinery_user_session_path
    self.admin_email = 'youremail@example.com'
    
   
  end
end