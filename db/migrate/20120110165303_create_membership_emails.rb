class CreateMembershipEmails < ActiveRecord::Migration

  def self.up
    create_table Refinery::Memberships::MembershipEmail.table_name, :force => true do |t|
      t.string  :title
      t.string  :subject
      t.text    :body
      t.timestamps
    end

    add_index Refinery::Memberships::MembershipEmail.table_name, :title, :unique => true
    Refinery::Memberships::MembershipEmail.create_translation_table! :subject => :string, :body => :text

    if (seed_file = Rails.root.join('db', 'seeds', 'refinerycms_membership_emails.rb')).file?
      load seed_file.to_s unless Refinery::Memberships::MembershipEmail.count > 0
    end
  end

  def self.down
    drop_table Refinery::Memberships::MembershipEmail.table_name
    Refinery::Memberships::MembershipEmail.drop_translation_table!
  end
end
