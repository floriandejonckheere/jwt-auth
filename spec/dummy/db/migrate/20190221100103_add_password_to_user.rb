# frozen_string_literal: true

class AddPasswordToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :password, :string
  end
end
