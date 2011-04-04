class Admin::MembershipsController < Admin::BaseController
  crudify :member,
    :conditions => ['member_until IS NULL || member_until = \'\''],
    :xhr_paging => true
  
  before_filter do
    columns = [[:last_name, :first_name], [:organization], [:email], [:created_at]]
    params[:order_by] ||= 0
    params[:order_dir] ||= 'asc'
    unless columns[params[:order_by].to_i]
      params[:order_by] = 0
      params[:order_dir] = 'asc'
    end
    if columns[params[:order_by].to_i]
      @order = columns[params[:order_by].to_i].collect{|f| "#{f} #{params[:order_dir]}"}.join(', ')
    end
  end
  
  private
  
  def find_all_members(conditions = ['member_until IS NULL || member_until = \'\''])
    @members = Member.where(conditions).order(@order||'')
  end
end
