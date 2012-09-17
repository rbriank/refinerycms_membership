(Refinery.i18n_enabled? ? Refinery::I18n.frontend_locales : [:en]).each do |lang|
  I18n.locale = lang

  if defined?(Refinery::User)
    Refinery::User.all.each do |user|
      if user.plugins.where(:name => 'refinerycms-memberships').blank?
        user.plugins.create(:name => 'refinerycms-memberships',
                            :position => (user.plugins.maximum(:position) || -1) +1)
      end
    end
  end
  
end

r = Refinery::Role.new
r.title = 'Member'
r.save