module Refinery
  module Memberships
    class MembershipEmailPart < ActiveRecord::Base

      attr_accessible :title, :body

      validates_uniqueness_of :title

      translates :body if respond_to?(:translates)

      self.translation_class.send :attr_accessible, :locale if self.respond_to?(:translation_class)

      class << self
        def [](title)
          r = find(:first, :conditions => {:title => title})
          raise ActiveRecord::RecordNotFound.new(":title = #{title}") unless r
          r
        end
      end
    end
  end
end