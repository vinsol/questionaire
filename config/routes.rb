PriyankQuestionaire::Application.routes.draw do

  resources :questions 
  
  devise_for :admins, :controllers => { :omniauth_callbacks => "admins/omniauth_callbacks"}
  
  get 'change_answer_div', :to => 'questions#change_answer_div', :as => 'change_answer_div'
  get 'for_option_answer', :to => 'questions#for_option_answer', :as => 'for_option_answer'
  get 'ques_tags', :to => 'questions#ques_tags', :as => 'ques_tags'
  get 'make_test', :to => 'questions#make_test', :as => 'make_test'
  get 'fetch_questions', :to => 'questions#fetch_questions', :as => 'fetch_questions'
  get 'show_fetch_ques/:id', :to => 'questions#show_fetch_ques', :as => 'show_fetch_ques'
  
  resources :admins
 
  match '/questions/tags/:name', :to => "questions#tags_index", :as => 'tag_index'
  match '/questions/level/:id', :to => "questions#level_index", :as => 'level_index'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "questions#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
