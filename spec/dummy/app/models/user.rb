class User < ApplicationRecord
  include JWT::Auth::Authenticatable

  def self.find_by_token(params)
    find_by params.merge :activated => true
  end
end
