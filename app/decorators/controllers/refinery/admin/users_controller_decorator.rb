# show only admins in Users administration
::Refinery::Admin::UsersController.class_eval do
	def index
		find_all_users ["membership_level <> ?", 'Member']
		paginate_all_users
		render :partial => 'users' if request.xhr?
	end
end