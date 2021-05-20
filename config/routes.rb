Rails.application.routes.draw do
  devise_for :users
  root to: 'goods#index'
  resources :favorites, except: [:index] do
    collection do
      get :goods
      get :get_data
      delete '/delete_by_favorite/:goods_key', to: 'favorites#delete_by_favorite'
    end
  end
  get '/goods/run_job', to: 'goods#run_job' # для имитации крона с https://cron-job.org/ - запросы идут оттуда
  resources :goods, only: [:show]
end
