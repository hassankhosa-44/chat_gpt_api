Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'extension/get_summary', to: 'extension#get_summary'
    end
  end
end
