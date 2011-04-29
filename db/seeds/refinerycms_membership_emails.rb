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