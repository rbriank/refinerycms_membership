class Member < User
  validates :membership_level, :first_name, :last_name,  :presence => true     #:province,
  attr_accessible :membership_level, :first_name, :last_name, :title, :organization,
    :street_address, :city, :province, :postal_code, :phone, :fax, :website

  def is_member?
    role_ids.include?(MEMBER_ROLE_ID)
  end

  def active?
    if member_until.nil?
      false
    else
      member_until.future? && role_ids.include?(MEMBER_ROLE_ID)
    end
  end

  def lapsed?
    if member_until.nil?
      false
    else
      member_until.past? && role_ids.include?(MEMBER_ROLE_ID)
    end
  end

  # multiple calls extends the membership life
  def activate
    add_year_to_member_until_until
    ensure_member_role
  end

  def deactivate
    nil_paid_until
    remove_member_role
  end

  def add_year_to_member_until_until
    update_attribute(:member_until, member_until.nil? ? 1.year.from_now : member_until + 1.year)
  end

  def ensure_member_role
    roles << Role.find(MEMBER_ROLE_ID) unless role_ids.include?(MEMBER_ROLE_ID)
  end

  def remove_member_role
    roles.delete(Role.find(MEMBER_ROLE_ID)) if role_ids.include?(MEMBER_ROLE_ID)
  end

  def nil_paid_until
    update_attribute(:member_until, nil)
  end
end