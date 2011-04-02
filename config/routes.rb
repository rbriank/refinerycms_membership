Refinery::Application.routes.draw do
  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :roles 
    resources :memberships, :only => :index 
    resources :user_roles, :only => [:update] do
      collection do
        post 'destroy_multiple'
        post 'create_multiple'
      end
    end
  end

  resource :members, :except => [:destroy] do
    get :login
    get :thank_you
    get :profile
	end	
end
