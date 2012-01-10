MembershipEmail.new({
  :title => 'member_created',
  :subject => 'Welcome',
  :body => '<p>Welcome email</p>'
}).save(false)
MembershipEmail.new({
  :title => 'member_accepted',
  :subject => 'Accepted',
  :body => '<p>Accepted email</p>'
}).save(false)
MembershipEmail.new({
  :title => 'member_deleted',
  :subject => 'Account deleted',
  :body => '<p>Account deleted email</p>'
}).save(false)
MembershipEmail.new({
  :title => 'member_rejected',
  :subject => 'Account rejected',
  :body => '<p>Account rejected email</p>'
}).save(false)
MembershipEmail.new({
  :title => 'membership_extended',
  :subject => 'Membership extended',
  :body => '<p>Membership extended email</p>'
}).save(false)

RefinerySetting.find_or_set("deliver_mail_on_member_created", true);
RefinerySetting.find_or_set("deliver_mail_on_member_accepted", true);
RefinerySetting.find_or_set("deliver_mail_on_member_deleted", true);
RefinerySetting.find_or_set("deliver_mail_on_member_rejected", true);
RefinerySetting.find_or_set("deliver_mail_on_membership_extended", true);