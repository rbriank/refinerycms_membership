class Admin::RolesController < Admin::BaseController
  crudify :role, 
      :conditions => ['title NOT IN (?)',['Superuser','Refinery','Member']],
      :title_attribute => :title,
      :order => "title ASC",
      :xhr_paging => true
end