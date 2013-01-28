class AddCalTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cal_token, :string
    add_index :users, :cal_token
  end
end
