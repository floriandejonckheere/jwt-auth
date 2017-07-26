class User < ApplicationRecord
  include JWT::Auth::Authenticatable

  validates :token_version, :presence => true

  def self.find_by_token(params)
    find_by params.merge :activated => true
  end

  def increment_token_version!
    self.token_version += 1
    save!
  end
end
