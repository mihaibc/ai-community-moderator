class AddJtiToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :jti, :string
    add_index :users, :jti, unique: true
    User.reset_column_information
    User.find_each { |u| u.update_columns(jti: SecureRandom.uuid) }
    change_column_null :users, :jti, false
  end

  def down
    remove_index :users, :jti
    remove_column :users, :jti
  end
end
