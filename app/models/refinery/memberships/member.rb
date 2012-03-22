module Refinery
  module Memberships
    class Member < User
      include ::Refinery::Memberships::Member
    end
  end
end
