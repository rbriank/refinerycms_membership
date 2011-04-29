class CreateMembershipEmails < ActiveRecord::Migration

  def self.up
    create_table :membership_emails, :force => true do |t|
      t.string  :title
      t.string  :subject
      t.text    :body
      t.timestamps
    end
    
    add_index :membership_emails, :title, :unique => true
    MembershipEmail.create_translation_table! :subject => :string, :body => :text
    
    if (seed_file = Rails.root.join('db', 'seeds', 'refinerycms_membership_emails.rb')).file?
      load seed_file.to_s unless MembershipEmail.count > 0
    end
  end

  def self.down
    drop_table :membership_emails
    MembershipEmail.drop_translation_table!
  end
end
