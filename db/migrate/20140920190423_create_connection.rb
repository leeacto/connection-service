class CreateConnection < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.integer :merchant_id, null: false
      t.integer :user_id, null: false
      t.timestamps
    end
  end
end
