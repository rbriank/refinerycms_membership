Refinery::Setting::find_or_set('memberships_timed_accounts', true)

Refinery::Setting::find_or_set('memberships_confirmation', 'admin')
Refinery::Setting::find_or_set('memberships_default_roles', [])
Refinery::Setting.find_or_set("memberships_default_account_validity", 12)


Refinery::Setting.find_or_set("memberships_deliver_mail_on_member_deleted", true)
Refinery::Setting.find_or_set("memberships_deliver_mail_on_member_rejected", true)
Refinery::Setting.find_or_set("memberships_deliver_mail_on_membership_extended", true)
Refinery::Setting.find_or_set("memberships_deliver_mail_on_member_accepted", true)

Refinery::Setting.find_or_set('memberships_deliver_notification_to_users', '')