module Refinery
  module Memberships
    class PagesRoles < ActiveRecord::Base
      belongs_to :roles
      belongs_to :pages
    end
  end
end