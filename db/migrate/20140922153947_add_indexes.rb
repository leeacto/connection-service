class AddIndexes < ActiveRecord::Migration
  def change
    add_index :connections, :merchant_id
    add_index :connections, :user_id
  end
end
