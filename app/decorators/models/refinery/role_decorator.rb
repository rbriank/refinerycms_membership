Refinery::Role.class_eval do
  has_and_belongs_to_many :pages, :join_table => ::Refinery::Memberships::PagesRoles.table_name
  attr_accessible :id, :title
  validates_presence_of :title
  acts_as_indexed :fields => [:title]
  # Number of settings to show per page when using will_paginate
  def self.per_page
    12
  end
end