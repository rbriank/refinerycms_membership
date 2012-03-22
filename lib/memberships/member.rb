module Refinery
  module Memberships
    module Member
      def self.included(base)
        base.class_eval do
          devise :confirmable
          def self.per_page
            12
          end

          acts_as_indexed :fields => [:first_name, :last_name]

          validates :first_name, :last_name, :street_address, :city, :province, :postal_code, :presence => true

          attr_accessible :membership_level, :first_name, :last_name, :title, :organization,
          :street_address, :city, :province, :postal_code, :phone, :fax, :website,
          :enabled, :add_to_member_until, :role_ids

          set_inheritance_column :membership_level

          after_create :set_default_enabled
          after_create :set_default_rejected
          after_create :set_default_roles

          include ::Refinery::Memberships::Member::InstanceMethods
        end
      end

      module InstanceMethods
        def full_name
          "#{self.first_name} #{last_name}"
        end

        def add_to_member_until
          @add_to_member_until || ''
        end

        def add_to_member_until=(n)
          @add_to_member_until = n
          extend_membership n.to_i if n && n.to_i > 0
        end

        def email=(e)
          write_attribute(:email, e)
          write_attribute(:username, e)
        end

        def enabled=(e)
          write_attribute(:enabled, e)
          e = read_attribute(:enabled)
          e ? ensure_member_role : remove_member_role
          e
        end

        def mail_data
          allowed_attributes = %w(email first_name last_name title organization
          street_address city province postal_code phone fax website)
          d = attributes.to_hash
          d.reject!{|k,v| !allowed_attributes.include?(k.to_s)}
          d[:activation_url] = Rails.application.routes.url_helpers.activate_members_url(:confirmation_token => self.confirmation_token) if Refinery::Setting::find_or_set('memberships_confirmation', 'admin') == 'email'
          d[:member_until] = I18n.localize(member_until.to_date, :format => :long) if member_until && Refinery::Setting::find_or_set('memberships_timed_accounts', true)
          d
        end

        def is_member?
          has_role?(:member)
        end

        def active_for_authentication?
          a = self.enabled && self.is_member?

          if Refinery::Setting::find_or_set('memberships_timed_accounts', true)
            if member_until.nil?
            a = false
            else
              a = a && member_until.future?
            end
          end
          a
        end

        alias :active? :active_for_authentication?

        def confirmed?
          Refinery::Setting::find_or_set('memberships_confirmation', 'admin') != 'email' || !!confirmed_at
        end

        def unconfirmed?
          !self.confirmed?
        end

        def seen?
          self.seen == true
        end

        def unseen?
          !self.seen?
        end

        def enabled?
          self.enabled == true
        end

        def disabled?
          !self.enabled?
        end

        def rejected?
          self.rejected == 'YES'
        end

        def accepted?
          self.rejected == 'NO'
        end

        def undecided?
          self.rejected == 'UNDECIDED'
        end

        def lapsed?
          if Refinery::Setting::find_or_set('memberships_timed_accounts', true)
            if member_until.nil?
            false
            else
              member_until.past?
            end
          else
          false
          end
        end

        def almost_lapsed?
          !lapsed? && member_until.present? && (member_until-7.days).past?
        end

        def never_member?
          !Refinery::Setting::find_or_set('memberships_timed_accounts', true) || member_until.nil?
        end

        def confirm!
          unless_confirmed do
            self.enabled = true
          end
          super
        end

        def seen!
          self.update_attribute(:seen, true)
        end

        def enable!
          self.enabled = true
          save
        end

        def disable!
          self.enabled = false
          save
        end

        def extend!
          extend_membership if Refinery::Setting::find_or_set('memberships_timed_accounts', true)
        end

        def reject!
          update_attribute(:rejected, 'YES')
        end

        def accept!
          update_attribute(:rejected, 'NO')
          enable!
        end

        def inactive_message
          self.seen? ? I18n.translate('devise.failure.locked') : super
        end

        # devise confirmable

        # override... the token was sent with the welcome email
        def send_confirmation_instructions
          generate_confirmation_token! if self.confirmation_token.nil?
        end

        # resend the welcome email
        def resend_confirmation_token
          unless_confirmed do
            generate_confirmation_token! if self.confirmation_token.nil?
            member_email('member_created', member).deliver if Refinery::Setting.find_or_set("memberships_deliver_mail_on_member_created", true)
          end
        end

        protected

        def confirmation_required?
          Refinery::Setting::find_or_set('memberships_confirmation', 'admin') == 'email' && !confirmed?
        end

        def set_default_enabled
          update_attribute(:enabled, Refinery::Setting::find_or_set('memberships_confirmation', 'admin') == 'no')
        end

        def set_default_rejected
          update_attribute(:rejected, 'NO') if Refinery::Setting::find_or_set('memberships_confirmation', 'admin') != 'admin'
        end

        def set_default_roles
          ids = Refinery::Setting::find_or_set('memberships_default_roles', [])
          if ids.present?
            Role::find(:all, :conditions => {'id' => ids}).each do | role |
              self.roles << role
            end
            save
          end
        end

        def extend_membership(amount = 1)

          step = Refinery::Setting.find_or_set("memberships_default_account_validity", 12) # months
          amount = amount*step
          if amount && amount > 0
            self.member_until = member_until.nil? || lapsed? ? amount.month.from_now : member_until + amount.month
            save
          end
        end

        def ensure_member_role
          self.add_role(:member) unless has_role?(:member)
        end

        def remove_member_role
          self.roles.delete(Role[:member]) if has_role?(:member)
        end
      end
    end
  end
end
