class MembershipEmailPart < ActiveRecord::Base
  translates :body
  
  validates_uniqueness_of :title
end