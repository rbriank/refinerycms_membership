# override image dialog iframe
::Refinery::Admin::ImagesController.class_eval do
  def render(*args)
    if args[0].kind_of?(Hash) && args[0][:action] == 'insert'
      args[0][:action] = 'insert_patched'
      super(*args)
    else
      super
    end
  end
end