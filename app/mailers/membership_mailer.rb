class MembershipMailer < ActionMailer::Base
  
  class << self
    def deliver_member_created(member)
      
    end
    
    def deliver_member_accepted(member)
      
    end
    
    def deliver_member_deleted(member)
      
    end
    
    def deliver_member_rejected(member)
      
    end
    
    def deliver_membership_extended(member)
      
    end
  end

    
  def member_created_member
    
  end
  
  def member_created_admin
    
  end
  
  
  
  def member_accepted_member
    
  end
  
  def member_accepted_admin
    
  end
  
  
  def member_deleted_member
    
  end
  
  
  
  def member_rejected_member
    
  end
  
  
  
  def membership_extended_admin
    
  end
end
