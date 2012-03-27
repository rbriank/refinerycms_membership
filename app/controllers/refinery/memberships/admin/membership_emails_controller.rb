module Refinery
  module Memberships
    module Admin
      class MembershipEmailsController < ::Refinery::AdminController
        crudify :'refinery/memberships/membership_email',
          :title_attribute => :title,
          :order => "title ASC"

        def index
          find_all_membership_emails
          @membership_email_parts = MembershipEmailPart.all
        end

      end
    end
  end
end