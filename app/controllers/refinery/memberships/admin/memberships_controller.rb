module Refinery
  module Memberships
    module Admin
      class MembershipsController < ::Refinery::AdminController
        include Admin::MembershipsHelper

        crudify :'refinery/memberships/member',
          :conditions => {:seen => false},
          :title_attribute => :full_name,
          :xhr_paging => true

        before_filter do
          columns = [[:last_name, :first_name], [:organization], [:email], [:created_at]]
          params[:order_by] ||= 0
          params[:order_dir] ||= 'asc'
          unless columns[params[:order_by].to_i]
            params[:order_by] = 0
            params[:order_dir] = 'asc'
          end
          if columns[params[:order_by].to_i]
            @order = columns[params[:order_by].to_i].collect{|f| "#{f} #{params[:order_dir]}"}.join(', ')
          end
        end

        before_filter :load_settings, :only => [:settings, :save_settings]


        def settings
        end

        def save_settings

          prefs = %w(notification_setting memberships_timed_accounts memberships_confirmation memberships_default_roles memberships_default_account_validity member_deleted member_rejected membership_extended membership_extended member_accepted)

          all_valid = true

          prefs.each do | name |
            next if params[name].blank?
            instance_variable_get("@#{name}".to_sym).send("value=", params[name][:value])
            valid = true
            case name
            when 'notification_setting' then
              value = params[name][:value].split(/[\s,]/).collect{|a|a.strip}.reject{|e|e.blank?}
              Rails.logger.debug "#{value.inspect} #{value.present?} && #{value.any?} && #{(value.reject{|e| e =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/}).blank?}"
              valid = value.present? && value.any? && (value.reject{|e| e =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/}).blank?
            end
            instance_variable_get("@#{name}".to_sym).errors.add :value, :invalid unless valid
            all_valid = false unless valid && instance_variable_get("@#{name}".to_sym).save
          end

          if all_valid
            render :text => "<script>parent.window.location.reload();</script>"
          else
            render :action => :settings
          end
        end

        private

        def load_settings

          @membership_emails = MembershipEmail::find(:all)
          @roles = Role::find(:all, :conditions => ['title NOT IN (?)',['Superuser','Refinery','Member']])

          @notification_setting = Refinery::Setting.find_by_name('memberships_deliver_notification_to_users')
          @notification_setting ||= Refinery::Setting.new({:name => 'memberships_deliver_notification_to_users'})


          @memberships_timed_accounts = Refinery::Setting.find_by_name('memberships_timed_accounts')
          @memberships_timed_accounts ||= Refinery::Setting.new({:name => 'memberships_timed_accounts', :value => false})

          @memberships_confirmation = Refinery::Setting.find_by_name('memberships_confirmation')
          @memberships_confirmation ||= Refinery::Setting.new({:name => 'memberships_confirmation', :value => 'admin'})

          @memberships_default_roles = Refinery::Setting.find_by_name('memberships_default_roles')
          @memberships_default_roles ||= Refinery::Setting.new({:name => 'memberships_default_roles', :value => []})

          @memberships_default_account_validity = Refinery::Setting.find_by_name('memberships_default_account_validity')
          @memberships_default_account_validity ||= Refinery::Setting.new({:name => 'memberships_default_account_validity', :value => 12})

          @member_deleted = Refinery::Setting.find_by_name('memberships_deliver_mail_on_member_deleted')
          @member_deleted ||= Refinery::Setting.new({:name => 'memberships_deliver_mail_on_member_deleted', :value => true})

          @member_rejected = Refinery::Setting.find_by_name('memberships_deliver_mail_on_member_rejected')
          @member_rejected ||= Refinery::Setting.new({:name => 'memberships_deliver_mail_on_member_rejected', :value => true})

          @membership_extended = Refinery::Setting.find_by_name('memberships_deliver_mail_on_membership_extended')
          @membership_extended ||= Refinery::Setting.new({:name => 'memberships_deliver_mail_on_membership_extended', :value => true})

          @member_accepted = Refinery::Setting.find_by_name('memberships_deliver_mail_on_member_accepted')
          @member_accepted ||= Refinery::Setting.new({:name => 'memberships_deliver_mail_on_member_accepted', :value => true})

        end

        def find_all_members(conditions = {:seen => false})
          @members = Member.where(conditions).order(@order||'')
        end
      end
    end
  end
end
