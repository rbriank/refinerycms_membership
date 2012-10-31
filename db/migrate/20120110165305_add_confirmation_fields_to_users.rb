class AddConfirmationFieldsToUsers < ActiveRecord::Migration

  def self.up
    add_column Refinery::User.table_name, :confirmation_token, :string
    add_column Refinery::User.table_name, :confirmed_at, :datetime
    add_column Refinery::User.table_name, :confirmation_sent_at, :datetime
  end

  def self.down
    remove_column Refinery::User.table_name, :confirmation_token
    remove_column Refinery::User.table_name, :confirmed_at
    remove_column Refinery::User.table_name, :confirmation_sent_at
  end

end
