class CreateLgenres < ActiveRecord::Migration
  def self.up
    create_table :lgenres do |t|
      t.column :name, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :lgenres
  end
end
