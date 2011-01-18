class PagesRoles < ActiveRecord::Base
  belongs_to :roles
  belongs_to :pages
end
