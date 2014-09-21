class UpdateIds < ActiveRecord::Migration
  def up
    change_column :connections, :user_id, 'bigint unsigned', null: false, default: 0
    change_column :connections, :merchant_id, 'bigint unsigned', null: false, default: 0
  end

  def down
    change_column :connections, :user_id, 'bigint signed', null: false, default: 0
    change_column :connections, :merchant_id, 'bigint signed', null: false, default: 0
  end
end
