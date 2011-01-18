class CreateMemberships < ActiveRecord::Migration

  def self.up
    create_table :memberships do |t|
      t.integer :page_id
      t.integer :role_id
      t.string :title
      t.integer :position

      t.timestamps
    end

    add_index :memberships, :id

    load(Rails.root.join('db', 'seeds', 'memberships.rb'))
  end

  def self.down
    UserPlugin.destroy_all({:name => "memberships"})

    Page.delete_all({:link_url => "/memberships"})

    drop_table :memberships
  end

end
