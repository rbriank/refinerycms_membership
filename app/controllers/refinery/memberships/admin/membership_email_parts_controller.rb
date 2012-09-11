module Refinery
  module Memberships
    module Admin
      class MembershipEmailPartsController < ::Refinery::AdminController

        crudify :'refinery/memberships/membership_email_part',
          :title_attribute => :title,
          :order => "title ASC",
          :redirect_to_url => "refinery.admin_membership_email_parts_path"

      end
    end
  end
end
