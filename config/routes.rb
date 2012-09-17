Refinery::Core::Engine.routes.append do
  
  
    # Frontend routes
  namespace :memberships, :path => '' do
    resources :members, :except => :destroy
  end
  
   # Admin routes
  namespace :memberships, :path => '' do
    namespace :admin, :path => 'refinery' do
      resources :memberships, :only => :index
      resources :user_roles, :only => :update do
        collection do
          post 'destroy_multiple'
          post 'create_multiple'
        end
      end
      resources :page_roles, :only => [] do
        collection do
          post 'destroy_multiple'
          post 'create_multiple'
        end
      end
    end
  end
  
=begin
  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :memberships, :only => :index 
    resources :page_roles, :only => [] do
      collection do
        post 'destroy_multiple'
        post 'create_multiple'
      end
    end
    resources :user_roles, :only => [:update] do
      collection do
        post 'destroy_multiple'
        post 'create_multiple'
      end
    end
  end
  resources :members, :except => [:destroy] 
=end

end
