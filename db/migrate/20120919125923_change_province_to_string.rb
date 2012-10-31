class ChangeProvinceToString < ActiveRecord::Migration

  def self.up
    change_column Refinery::User.table_name, :province, :string
  end

  def self.down
    change_column Refinery::User.table_name, :province, :integer
  end

end
