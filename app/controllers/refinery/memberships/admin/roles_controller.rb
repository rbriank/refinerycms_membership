module Refinery
  module Memberships
    module Admin
      class RolesController < ::Refinery::AdminController
        crudify :'refinery/role',
            :conditions => ['title NOT IN (?)',['Superuser','Refinery','Member']],
            :title_attribute => :title,
            :order => "title ASC",
            :xhr_paging => true
      end
    end
  end
end