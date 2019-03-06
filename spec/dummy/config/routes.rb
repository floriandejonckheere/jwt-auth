# frozen_string_literal: true

Rails.application.routes.draw do
  resource :token, :only => %i[create update]

  get '/unauthenticated' => 'content#unauthenticated'
  get '/authenticated' => 'content#authenticated'
end
