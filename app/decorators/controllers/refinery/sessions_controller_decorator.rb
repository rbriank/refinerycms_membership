Refinery::SessionsController.class_eval do

    # This defines the devise method for refinery routes
    # need to respect :redirect param or it goes to /refinery by default
    def signed_in_root_path(resource_or_scope)
      params[:redirect] || super
    end

end
