class AddActivatedToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :activated, :boolean, :default => false
  end
end
