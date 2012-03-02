require 'nokogiri'
require 'webrat'

class MembershipMailer < ActionMailer::Base
  
  class << self
    def deliver_member_created(member)
      member_email('member_created', member).deliver if RefinerySetting.find_or_set("memberships_deliver_mail_on_member_created", true)
      member_created_admin(member).deliver
    end
    
    def deliver_member_activated(member)
      member_email('member_activated', member).deliver if RefinerySetting.find_or_set("memberships_deliver_mail_on_member_activated", true)
    end
    
    def deliver_member_rejected(member)
      member_email('member_rejected', member).deliver if RefinerySetting.find_or_set("memberships_deliver_mail_on_member_rejected", true)
    end
    
    def deliver_member_deleted(member)
      member_email('member_deleted', member).deliver if RefinerySetting.find_or_set("memberships_deliver_mail_on_member_deleted", true)
    end
    
    def deliver_membership_extended(member)
      member_email('membership_extended', member).deliver if RefinerySetting.find_or_set("memberships_deliver_mail_on_membership_extended", true)
    end
    
    def deliver_member_accepted(member)
      member_email('member_accepted', member).deliver if RefinerySetting.find_or_set("memberships_deliver_mail_on_member_accepted", true)
    end
  end
  
  def member_email(email, member)
    @member = member
    
    @email = MembershipEmail[email]
    
    html = render_to_string :template => 'membership_mailer/email'
    
    html = extract_images(html)
    text = html_to_text(html)
    
    mail(:from => RefinerySetting.find_or_set("memberships_sender_address", nil),
         :to => member.email, :subject => @email.subject) do |format|
      format.text { render :text => text }
      format.html { render :text => html }
    end
    
  end
  
  def member_created_admin(member)
    @member = member
    
    mail(:from => RefinerySetting.find_or_set("memberships_sender_address", nil),
         :to => admins, :subject => "New user registration on #{RefinerySetting::get('site_name')}") do |format|
      format.text
    end
  end
  
  protected
  
  def admins
    addrs = RefinerySetting.get('memberships_deliver_notification_to_users')
		if addrs.blank?
			addrs = User::find(:all, :conditions => ["membership_level <> ?", 'Member']).collect{|u| u.email}
			Rails.logger.debug '-'*90
			Rails.logger.debug addrs.inspect
			RefinerySetting.find_or_set('memberships_deliver_notification_to_users', addrs)
		end
		addrs
  end
  
  def extract_images(html)
    doc = Nokogiri::HTML::parse(html, nil, 'UTF-8')
    img_nodes = doc.search('img')
    
    images = {}
    
    img_nodes.each do | node |
      img_id = node['data-id']
      img_size = node['data-size']
      images["#{img_id}:#{img_size}"] ||= {
        :id => img_id, 
        :size => img_size,
        :nodes => []
      }
      images["#{img_id}:#{img_size}"][:nodes] << node
    end if img_nodes.present?
    
    images.each do |k, v|
      record = Image::find(v[:id])
      image = v[:size] == 'original' ? record.image : record.thumbnail(v[:size].to_sym)
      attachments.inline[image.name] = {
        :mime_type => image.mime_type,
        :content => File::read(image.tempfile.path)
      }
      v[:nodes].each do | node |
        node['src'] = attachments[image.name].url
      end
    end 
    
    doc.to_html
  end
  
  def html_to_text(html)
    doc = Nokogiri::HTML::parse(html, nil, 'UTF-8')
    doc.search('script, style').remove
    doc.text
  end
end
