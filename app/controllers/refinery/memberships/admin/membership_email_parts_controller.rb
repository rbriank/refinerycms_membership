module Refinery
  module Memberships
    module Admin
      class MembershipEmailPartsController < ::Refinery::AdminController
        crudify :'refinery/memberships/membership_email_part',
          :title_attribute => :title,
          :order => "title ASC"

      end
    end
  end
end