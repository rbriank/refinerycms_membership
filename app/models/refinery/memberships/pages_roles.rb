module Refinery
  module Memberships
    class PagesRoles <  Refinery::Core::BaseModel
      self.table_name = 'pages_roles'
      belongs_to :roles
      belongs_to :pages
    end
  end
end
