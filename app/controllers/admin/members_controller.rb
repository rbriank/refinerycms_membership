class Admin::MembersController < Admin::BaseController
  
  include Admin::MembersHelper
  
  crudify :member,
    :title_attribute => :full_name,
    :xhr_paging => true
  
  before_filter do
    columns = [[:last_name, :first_name], [:organization], [:email], [:created_at], [:member_until], [:is_new, :member_until, :enabled]]
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
  
  before_filter(:only => :update) do
    if params[:member][:password].blank? and params[:member][:password_confirmation].blank?
      params[:member].delete(:password)
      params[:member].delete(:password_confirmation)
    end
  end
  
  before_filter(:only => :edit) do
    step = RefinerySetting.find_or_set("memberships_default_account_validity", 12)
    @activation_steps = []
    1.upto(11) do | n |
      @activation_steps << [I18n.t('months', :count => n), n] if n%step.to_i == 0
    end
    1.upto(10) do | n |
      @activation_steps << [I18n.t('years', :count => n), n*12]
    end
  end
  
  def redirect_back_or_default(default)
    params[:redirect_to_url].present? ? redirect_to(params[:redirect_to_url]) : super 
  end
  
  def extend
    find_member    
    @member.seen!
    @member.extend!
    
    #MembershipMailer.extension_confirmation_member(@member).deliver
    #MembershipMailer.extension_confirmation_admin(@member, current_user).deliver
    
    render :partial => 'member', :layout => false, :locals => {:member => @member}
  end
  
  def enable
    find_member    
    @member.seen!
    @member.enable!
    @member.reload
    
    #MembershipMailer.extension_confirmation_member(@member).deliver
    #MembershipMailer.extension_confirmation_admin(@member, current_user).deliver
    
    @members = [@member]
    
    render :partial => 'admin/members/members_table', :layout => false
  end
  
  def disable
    find_member   
    @member.seen!
    @member.disable!
    @member.reload 
    
    #MembershipMailer.extension_confirmation_member(@member).deliver
    #MembershipMailer.extension_confirmation_admin(@member, current_user).deliver
    
    @members = [@member]    
    render :partial => 'admin/members/members_table', :layout => false
  end

  
  def accept
    find_member
    @member.seen!
    @member.accept!
    @member.reload 
    
    #MembershipMailer.acceptance_confirmation_member(@member).deliver
    #MembershipMailer.acceptance_confirmation_admin(@member, current_user).deliver
    
    @members = [@member]    
    render :partial => 'admin/members/members_table', :layout => false
  end
  
  def reject
    find_member
    @member.seen!
    @member.reject!
    @member.reload 
    
    #MembershipMailer.rejection_confirmation_member(@member).deliver
    #MembershipMailer.rejection_confirmation_admin(@member, current_user).deliver
    
    @members = [@member]    
    render :partial => 'admin/members/members_table', :layout => false
  end
  
  private
  
  def find_all_members(conditions = '')
    @members = Member.where(conditions).order(@order||'')
  end
end