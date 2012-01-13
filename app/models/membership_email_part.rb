class MembershipEmailPart < ActiveRecord::Base
  translates :body
  
  validates_uniqueness_of :title
  
  class << self
    def [](title)
      r = find(:first, :conditions => {:title => title})
      raise ActiveRecord::RecordNotFound.new(":title = #{title}") unless r
      r
    end
  end
end