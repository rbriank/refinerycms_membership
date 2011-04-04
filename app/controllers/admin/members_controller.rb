class Admin::MembersController < Admin::BaseController
  crudify :member,
    :conditions => ['membership_level IS NOT NULL AND membership_level <> \'\''],
    :xhr_paging => true
    
  
  def index
    columns = [[:last_name, :firstsurname], [:organization], [:email], [:created_at]]
    if params[:order_by] && params[:order_dir] && columns[params[:order_by].to_i]
      params[:order] = columns[params[:order_by].to_i].collect{|f| "#{f} #{params[:order_dir]}"}.join(', ')
    end
    paginate_all_members
  end
end