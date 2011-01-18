module NavigationHelpers
  module Refinery
    module Memberships
      def path_to(page_name)
        case page_name
        when /the list of memberships/
          admin_memberships_path

         when /the new membership form/
          new_admin_membership_path
        else
          nil
        end
      end
    end
  end
end
