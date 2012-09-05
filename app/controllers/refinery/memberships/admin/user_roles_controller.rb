module Refinery
  module Memberships
    module Admin
      class UserRolesController < ::Refinery::Memberships::Admin::MembershipsController
        
        # PUT /refinery/user_roles/:id <-- member_id bad REST, but convenient for this!
        def update
      
          @member = Member.find(params[:id])
          case params[:switch]
          when 'extend'
            extend_member(@member)
          when 'cancel'
            cancel_member(@member)
          when 'approve'
            accept_member(@member)
          when 'reject'
            reject_member(@member)
          end
      
          respond_to do |format|
            format.js
          end
      
        end
        
      private
        def extend_member(member)
          member.activate
          ::Refinery::Memberships::MembershipMailer.extension_confirmation_member(member).deliver
          ::Refinery::Memberships::MembershipMailer.extension_confirmation_admin(member, current_refinery_user).deliver
        end
      
        def cancel_member(member)
          member.deactivate
          ::Refinery::Memberships::MembershipMailer.cancellation_confirmation_member(member).deliver
          ::Refinery::Memberships::MembershipMailer.cancellation_confirmation_admin(member, current_refinery_user).deliver
        end
      
        def accept_member(member)
          member.activate
          ::Refinery::Memberships::MembershipMailer.acceptance_confirmation_member(member).deliver
          ::Refinery::Memberships::MembershipMailer.acceptance_confirmation_admin(member, current_refinery_user).deliver
        end
      
        def reject_member(member)
          member.deactivate
          ::Refinery::Memberships::MembershipMailer.rejection_confirmation_member(member).deliver
          ::Refinery::Memberships::MembershipMailer.rejection_confirmation_admin(member, current_refinery_user).deliver
        end
      
      
      end
    end
  end
end