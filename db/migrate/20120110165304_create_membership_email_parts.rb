class CreateMembershipEmailParts < ActiveRecord::Migration

  def self.up
    create_table Refinery::Memberships::MembershipEmailPart.table_name, :force => true do |t|
      t.string  :title
      t.text    :body
      t.timestamps
    end

    add_index Refinery::Memberships::MembershipEmailPart.table_name, :title, :unique => true
    Refinery::Memberships::MembershipEmailPart.create_translation_table! :body => :text

    if (seed_file = Rails.root.join('db', 'seeds', 'refinerycms_membership_email_parts.rb')).file?
      load seed_file.to_s unless Refinery::Memberships::MembershipEmailPart.count > 0
    end
  end

  def self.down
    drop_table Refinery::Memberships::MembershipEmailPart.table_name
    Refinery::Memberships::MembershipEmailPart.drop_translation_table!
  end
end
