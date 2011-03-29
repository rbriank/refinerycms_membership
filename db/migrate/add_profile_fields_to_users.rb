class AddProfileFieldsToUsers < ActiveRecord::Migration

  def self.up
    add_column ::User.table_name, :first_name, :string
    add_column ::User.table_name, :last_name, :string
    add_column ::User.table_name, :title, :string
    add_column ::User.table_name, :phone, :string
    add_column ::User.table_name, :fax, :string
    add_column ::User.table_name, :website, :string
    add_column ::User.table_name, :organization, :string
    add_column ::User.table_name, :street_address, :string
    add_column ::User.table_name, :city, :string
    add_column ::User.table_name, :province, :integer
    add_column ::User.table_name, :postal_code, :string
    add_column ::User.table_name, :member_until, :datetime
    add_column ::User.table_name, :membership_level, :string
  end

  def self.down
    remove_column ::User.table_name, :first_name
    remove_column ::User.table_name, :last_name
    remove_column ::User.table_name, :title
    remove_column ::User.table_name, :phone
    remove_column ::User.table_name, :fax
    remove_column ::User.table_name, :website
    remove_column ::User.table_name, :organization
    remove_column ::User.table_name, :street_address
    remove_column ::User.table_name, :city
    remove_column ::User.table_name, :province
    remove_column ::User.table_name, :postal_code
    remove_column ::User.table_name, :member_until
    remove_column ::User.table_name, :membership_level
  end

end
