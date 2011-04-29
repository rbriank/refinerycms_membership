Role.create(:id => 3, :title => 'Member')

members_page = Page.create({:title => "Members",
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


page = members_page.children.create({:title => "Thank you",
  :deletable => false,
  :link_url => "/members/thank_you",
  :show_in_menu => false,
  :menu_match => "^/members/thank_you*$"})
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
