class MembershipMailer < ActionMailer::Base
  default :from => ADMIN_EMAIL
  
  def application_confirmation_member(member)
    @member = member
    mail(:to => member.email, :subject => 'EDAC|ACDE')
  end

  def application_confirmation_admin(member)
    @member = member
    mail(:to => ADMIN_EMAIL,
      :subject => "Sign up: #{member.first_name} #{member.last_name} (#{member.email})")
  end

  def acceptance_confirmation_member(member)
    @member = member
    mail(:to => member.email,
      :subject => 'EDAC - Welcome! | ACDE - Bienvenue!')
  end

  def acceptance_confirmation_admin(member, admin)
    @member = member
    @admin = admin
    mail(:to => ADMIN_EMAIL,
      :subject => "Approved: #{member.first_name} #{member.last_name} (#{member.email})")
  end

  def rejection_confirmation_member(member)
    @member = member
    mail(:to => member.email,
      :subject => 'EDAC|ACDE')
  end

  def rejection_confirmation_admin(member, admin)
    @member = member
    @admin = admin
    mail(:to => ADMIN_EMAIL,
      :subject => "Rejected: #{member.first_name} #{member.last_name} (#{member.email})")
  end

  def extension_confirmation_member(member)
    @member = member
    mail(:to => member.email,
      :subject => 'EDAC|ACDE - Extension')
  end

  def extension_confirmation_admin(member, admin)
    @member = member
    @admin = admin
    mail(:to => ADMIN_EMAIL,
      :subject => "Extension (1 yr.): #{member.first_name} #{member.last_name} (#{member.email})")
  end

  def cancellation_confirmation_member(member)
    @member = member
    mail(:to => member.email,
      :subject => 'EDAC | ACDE - Cancellation')
  end

  def cancellation_confirmation_admin(member, admin)
    @member = member
    @admin = admin
    mail(:to => ADMIN_EMAIL,
      :subject => "Cancelled: #{member.first_name} #{member.last_name} (#{member.email})")
  end

  def profile_update_notification_admin(member)
    @member = member
    mail(:to => ADMIN_EMAIL,
      :subject => "Profile Updated: #{member.first_name} #{member.last_name} (#{member.email})")
  end
end
