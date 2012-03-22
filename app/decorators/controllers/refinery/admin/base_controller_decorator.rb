::Refinery::Admin::BaseController.class_eval do
  def restrict_controller
    admin = refinery_user? || current_refinery_user.has_role?(:superuser)
    if !admin || Refinery::Plugins.active.reject { |plugin| params[:controller] !~ Regexp.new(plugin.menu_match)}.empty?
      warn "'#{current_refinery_user.username}' tried to access '#{params[:controller]}' but was rejected."
      error_404 if admin
      redirect_to '/' unless admin
    end
  end
end