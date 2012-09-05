module Refinery
  module Memberships
    include ActiveSupport::Configurable

    config_accessor :new_user_method_path

    self.new_user_method_path = :new_refinery_user_session_path
   
  end
end