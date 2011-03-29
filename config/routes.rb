Refinery::Application.routes.draw do
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
end
