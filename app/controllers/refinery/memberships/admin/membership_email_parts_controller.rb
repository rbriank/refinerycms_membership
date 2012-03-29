module Refinery
  module Memberships
    module Admin
      class MembershipEmailPartsController < ::Refinery::AdminController

        crudify :'refinery/memberships/membership_email_part',
          :singular_name => "membership_email",
          :plural_name => "membership_emails",
          :title_attribute => :title,
          :order => "title ASC"

      end
    end
  end
end