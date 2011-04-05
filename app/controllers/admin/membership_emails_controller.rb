module Admin
  class MembershipEmailsController < Admin::BaseController
    crudify :membership_email, 
      :title_attribute => :title,
      :order => "title ASC",
      :xhr_paging => true
  end
end