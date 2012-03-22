# override image dialog
::Refinery::Admin::DialogsController.class_eval do
  def render(*args)
    if @dialog_type && @dialog_type == 'image'
      if args[0].kind_of?(Hash)
        args[0][:action] = 'admin/memberships/image_dialog'
      end
      super(*args)
    else
      super
    end
  end
end
