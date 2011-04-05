class MembershipEmail < ActiveRecord::Base
  translates :subject, :text
  
  validates_uniqueness_of :title
  
  validates_presence_of :subject, :text
end