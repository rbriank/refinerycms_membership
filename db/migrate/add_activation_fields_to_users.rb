class AddActivationFieldsToUsers < ActiveRecord::Migration

  def self.up
    add_column ::User.table_name, :enabled, :boolean, :default => false
    add_column ::User.table_name, :is_new, :boolean, :default => true
    Member.all.each do | m |
      m.is_new = false
      m.enabled = m.roles.include?(Role.find(MEMBER_ROLE_ID))
      m.save
    end
  end

  def self.down
    remove_column ::User.table_name, :enabled
    remove_column ::User.table_name, :is_new
  end

end
