class CreatePagesRoles < ActiveRecord::Migration

  def self.up
    create_table :refinery_pages_roles, :id => false, :force => true do |t|
      t.references :page
      t.references :role
    end

    Refinery::Memberships::Engine.load_seed
    
  end

  def self.down
    UserPlugin.destroy_all({:name => "memberships"})
    drop_table :refinery_pages_roles
  end

end
