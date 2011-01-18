Refinery::Application.routes.draw do
  resources :memberships, :only => [:index, :show]

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :memberships, :except => :show do
      collection do
        post :update_positions
      end
    end
  end
end
