class CreateLdirectors < ActiveRecord::Migration
  def self.up
    create_table :ldirectors do |t|
      t.column :ext_id, :string
      t.column :name, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :ldirectors
  end
end
