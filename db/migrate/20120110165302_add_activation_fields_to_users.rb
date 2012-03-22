class AddActivationFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column Refinery::User.table_name, :enabled,  :boolean, :default => false
    add_column Refinery::User.table_name, :seen,     :boolean, :default => false
    add_column Refinery::User.table_name, :rejected, :string,  :default => 'UNDECIDED' # uff true, false, FileNotFound......
    Refinery::Memberships::Member.all.each do | m |
      m.seen = true
      m.enabled = m.has_role?(:member)
      m.rejected = 'NO'
      m.save
    end
  end

  def self.down
    remove_column Refinery::User.table_name, :enabled
    remove_column Refinery::User.table_name, :seen
    remove_column Refinery::User.table_name, :rejected
  end

end
