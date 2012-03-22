module Refinery
  module Memberships
    class MembershipEmail < ActiveRecord::Base
      translates :subject, :body

      validates_uniqueness_of :title

      validates_presence_of :subject, :body

      class << self
        def [](title)
          r = find(:first, :conditions => {:title => title})
          raise ActiveRecord::RecordNotFound.new(":title = #{title}") unless r
          r
        end
      end


      def interpolated_body(member)
        b = body || ''
        data = member.mail_data.stringify_keys
        b.gsub(/\[:([^\]]+)\]/) do | match |
          key = $1
          data.keys.include?(key) ? data[key] : match
        end
      end
    end
  end
end