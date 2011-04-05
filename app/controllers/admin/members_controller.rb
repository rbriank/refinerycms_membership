class Admin::MembersController < Admin::BaseController
  crudify :member,
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
  
  
  def extend
    find_member    
    @member.extend
    #MembershipMailer.extension_confirmation_member(@member).deliver
    #MembershipMailer.extension_confirmation_admin(@member, current_user).deliver
    render :nothing => true
  end
  
  def cancel
    find_member
    @member.deactivate
    #MembershipMailer.cancellation_confirmation_member(@member).deliver
    #MembershipMailer.cancellation_confirmation_admin(@member, current_user).deliver
    render :nothing => true
  end
  
  def enable
    find_member
    @member.activate
    render :nothing => true
  end
  
  def accept
    find_member
    @member.activate
    #MembershipMailer.acceptance_confirmation_member(@member).deliver
    #MembershipMailer.acceptance_confirmation_admin(@member, current_user).deliver
    render :nothing => true
  end
  
  def reject
    find_member
    @member.deactivate
    #MembershipMailer.rejection_confirmation_member(@member).deliver
    #MembershipMailer.rejection_confirmation_admin(@member, current_user).deliver
    render :nothing => true
  end
  
  private
  
  def find_all_members(conditions = '')
    @members = Member.where(conditions).order(@order||'')
  end
end