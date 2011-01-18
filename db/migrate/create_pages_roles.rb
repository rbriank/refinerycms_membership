class CreatePagesRoles < ActiveRecord::Migration

  def self.up
    create_table :pages_roles, :id => false, :force => true do |t|
      t.references :page
      t.references :role
    end

  end

  def self.down
    UserPlugin.destroy_all({:name => "memberships"})
    drop_table :pages_roles
  end

end
