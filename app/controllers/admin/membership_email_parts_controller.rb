module Admin
  class MembershipEmailPartsController < Admin::BaseController
    crudify :membership_email_part, 
      :title_attribute => :title,
      :order => "title ASC"
      
  end
end