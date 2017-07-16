class AddUserIdToCreditCard < ActiveRecord::Migration
  def change
    add_column :credit_cards, :user_id, :int
  end
end
