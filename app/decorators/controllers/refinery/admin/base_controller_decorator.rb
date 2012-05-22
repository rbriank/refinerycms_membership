::Refinery::Admin::BaseController.class_eval do
  # HACK NOTE:
  # how will certain users can edit pages only under certain parent pages?
  # this is to prevent everyone except from superusers from viewing any admin pages
  # but refinery already requires any user (except superuser) to have plugins enabled to admin them
  # (does having a plugin enabled for a user mean something else???)
  # NOTE: alternative hack is to alias_method_chain this to keep refinery:authentication logic
  # but add a condition to bail if no superuser

  # def restrict_controller
  #   admin = refinery_user? || current_refinery_user.has_role?(:superuser)
  #   if !admin || Refinery::Plugins.active.reject { |plugin| params[:controller] !~ Regexp.new(plugin.menu_match)}.empty?
  #     warn "'#{current_refinery_user.username}' tried to access '#{params[:controller]}' but was rejected."
  #     error_404 if admin
  #     redirect_to '/' unless admin
  #   end
  # end
end