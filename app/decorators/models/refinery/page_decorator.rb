::Refinery::Page.class_eval do
  has_and_belongs_to_many :roles
  attr_accessible :role_ids

  def user_allowed?(user)
    # if a page has no roles assigned, let everyone see it
    if roles.blank?
      true

    else
      # if a page has roles, but the user doesn't or is nil
      if user.nil? || user.roles.blank?
        false

      # otherwise, check user vs. page roles
      else
        # restricted pages must be available for admins
        (roles & user.roles).any? || user.has_role?('Refinery') || user.has_role?('Superuser')

      end
    end
  end
end # Page.class_eval
