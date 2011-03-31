class CreatePagesRoles < ActiveRecord::Migration

  def self.up
    create_table :pages_roles, :id => false, :force => true do |t|
      t.references :page
      t.references :role
    end
    if (seed_file = Rails.root.join('db', 'seeds', 'refinerycms_memberships.rb')).file?
      load seed_file.to_s unless Page.where(:link_url => '/members').any?
    end
  end

  def self.down
    UserPlugin.destroy_all({:name => "memberships"})
    drop_table :pages_roles
  end

end
