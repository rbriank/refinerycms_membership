# this broke as part of config.to_prepare
# Do this or lost password non-admins still goes to the dashboard
# ::Refinery::Admin::DashboardController.class_eval do
#   old_index = instance_method(:index)
#   define_method(:index){|*args|
#     if current_refinery_user.has_role?(:super_user) || current_refinery_user.has_role?(:refinery)
#       old_index.bind(self).call(*args)
#     else
#       redirect_to '/'
#     end
#   }
# end
