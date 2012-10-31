module Refinery
  module Memberships
    module Admin
      class MembershipEmailsController < ::Refinery::AdminController

        crudify :'refinery/memberships/membership_email',
          :singular_name => "membership_email",
          :plural_name => "membership_emails",
          :title_attribute => :title,
          :order => "title ASC",
          :redirect_to_url => "refinery.admin_membership_emails_path"

        def index
          find_all_membership_emails
          @membership_email_parts = MembershipEmailPart.all
        end

      end
    end
  end
end
