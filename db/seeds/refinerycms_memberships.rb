Refinery::Role.create(:id => 3, :title => 'Member')

members_page = ::Refinery::Page.create({:title => "Members",
  :deletable => false,
  :link_url => "/members",
  :show_in_menu => false,
  :menu_match => "^/members.*$"})
members_page.parts.create({
  :title => "Body",
  :body => "",
  :position => 0
})
members_page.parts.create({
  :title => "Side Body",
  :body => "",
  :position => 1
})


page = members_page.children.create({:title => "Login",
  :deletable => false,
  :link_url => "/members/login",
  :show_in_menu => false,
  :menu_match => "^/members/login$"})
page.parts.create({
  :title => "Body above",
  :body => "",
  :position => 0
})
page.parts.create({
  :title => "Body below",
  :body => "",
  :position => 1
})
page.parts.create({
  :title => "Side Body",
  :body => "",
  :position => 2
})


new_member_page = members_page.children.create({:title => "New Member",
  :deletable => false,
  :link_url => "/members/new",
  :show_in_menu => false,
  :menu_match => "^/members/(new|create|).*$"})
new_member_page.parts.create({
  :title => "Body above",
  :body => "",
  :position => 0
})
new_member_page.parts.create({
  :title => "Body below",
  :body => "",
  :position => 1
})
new_member_page.parts.create({
  :title => "Side Body",
  :body => "",
  :position => 2
})


page = new_member_page.children.create({:title => "Welcome",
  :deletable => false,
  :link_url => "/members/welcome",
  :show_in_menu => false,
  :menu_match => "^/members/welcome$"})
page.parts.create({
  :title => "Body",
  :body => "",
  :position => 0
})
page.parts.create({
  :title => "Side body",
  :body => "",
  :position => 1
})


lost_password_page = members_page.children.create({:title => "New password",
  :deletable => false,
  :link_url => "/members/new_password",
  :show_in_menu => false,
  :menu_match => "^/members/new_password$"})
lost_password_page.parts.create({
  :title => "Body above",
  :body => "",
  :position => 0
})
lost_password_page.parts.create({
  :title => "Body below",
  :body => "",
  :position => 1
})
lost_password_page.parts.create({
  :title => "Side Body",
  :body => "",
  :position => 2
})


page = lost_password_page.children.create({:title => "New password created",
  :deletable => false,
  :link_url => "/members/new_password/created",
  :show_in_menu => false,
  :menu_match => "^/members/new_password/created$"})
page.parts.create({
  :title => "Body",
  :body => "",
  :position => 0
})
page.parts.create({
  :title => "Side body",
  :body => "",
  :position => 1
})


page = members_page.children.create({:title => "Edit profile",
  :deletable => false,
  :link_url => "/members/edit",
  :show_in_menu => false,
  :menu_match => "^/members/edit$"})
page.parts.create({
  :title => "Body above",
  :body => "",
  :position => 0
})
page.parts.create({
  :title => "Body below",
  :body => "",
  :position => 1
})
page.parts.create({
  :title => "Side Body",
  :body => "",
  :position => 2
})


page = members_page.children.create({:title => "Profile",
  :deletable => false,
  :link_url => "/members/profile",
  :show_in_menu => false,
  :menu_match => "^/members/profile$"})
page.parts.create({
  :title => "Body above",
  :body => "",
  :position => 0
})
page.parts.create({
  :title => "Body below",
  :body => "",
  :position => 1
})
page.parts.create({
  :title => "Side Body",
  :body => "",
  :position => 2
})

page = members_page.children.create({:title => "Activate",
  :deletable => false,
  :link_url => "/members/activate",
  :show_in_menu => false,
  :menu_match => "^/members/activate\/[a-zA-Z0-9]+$"})
page.parts.create({
  :title => "Body",
  :body => "",
  :position => 0
})
page.parts.create({
  :title => "Side Body",
  :body => "",
  :position => 2
})
