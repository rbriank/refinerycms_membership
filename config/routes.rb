Refinery::Application.routes.draw do
  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :memberships, :only => :index
    resources :roles 
    resources :members do
      member do
        put :reject
        put :accept
        put :cancel
        put :extend
        put :enable
      end
    end
    resources :membership_emails, :except => :show do
      collection do
        get :settings
        put :save_settings
      end
    end
    resources :membership_email_parts, :except => :index
  end

  resource :members, :except => [:destroy] do
    get :login
    get :thank_you
    get :profile
	end	
end
