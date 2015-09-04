class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :nickname, :string
      t.column :user_id, :string
      t.column :last_name, :string
      t.column :first_name, :string
      t.column :session_id, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
