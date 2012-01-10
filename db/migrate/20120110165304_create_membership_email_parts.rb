class CreateMembershipEmailParts < ActiveRecord::Migration

  def self.up
    create_table :membership_email_parts, :force => true do |t|
      t.string  :title
      t.text    :body
      t.timestamps
    end
    
    add_index :membership_email_parts, :title, :unique => true
    MembershipEmailPart.create_translation_table! :body => :text
    
    if (seed_file = Rails.root.join('db', 'seeds', 'refinerycms_membership_email_parts.rb')).file?
      load seed_file.to_s unless MembershipEmailPart.count > 0
    end
  end

  def self.down
    drop_table :membership_email_parts
    MembershipEmailPart.drop_translation_table!
  end
end
