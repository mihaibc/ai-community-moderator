class AddRoleToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :role, :integer
    change_column_default :users, :role, from: nil, to: 0
    execute "UPDATE users SET role = 0 WHERE role IS NULL"
    change_column_null :users, :role, false
  end

  def down
    change_column_null :users, :role, true
    change_column_default :users, :role, from: 0, to: nil
    remove_column :users, :role
  end
end

