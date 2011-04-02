class Admin::MembersController < Admin::BaseController
  crudify :member,
    :conditions => ['membership_level IS NOT NULL AND membership_level <> \'\''],
    :order => "last_name ASC, first_name ASC",  
    :xhr_paging => true
    
end