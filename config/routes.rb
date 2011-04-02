Refinery::Application.routes.draw do
  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :memberships, :only => :index
    resources :roles 
    resources :members, :except => :index
    resources :membership_emails
  end

  resource :members, :except => [:destroy] do
    get :login
    get :thank_you
    get :profile
	end	
end
