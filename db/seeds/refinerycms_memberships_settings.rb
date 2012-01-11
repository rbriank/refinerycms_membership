RefinerySetting::find_or_set('memberships_timed_accounts', true)

RefinerySetting::find_or_set('memberships_confirmation', 'admin')
RefinerySetting::find_or_set('memberships_default_roles', [])
RefinerySetting.find_or_set("memberships_default_account_validity", 365)


RefinerySetting.find_or_set("memberships_deliver_mail_on_member_deleted", true)
RefinerySetting.find_or_set("memberships_deliver_mail_on_member_rejected", true)
RefinerySetting.find_or_set("memberships_deliver_mail_on_membership_extended", true)
RefinerySetting.find_or_set("memberships_deliver_mail_on_member_accepted", true)
