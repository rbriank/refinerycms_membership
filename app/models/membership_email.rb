class MembershipEmail < ActiveRecord::Base
  translates :subject, :body
  
  validates_uniqueness_of :title
  
  validates_presence_of :subject, :body
end