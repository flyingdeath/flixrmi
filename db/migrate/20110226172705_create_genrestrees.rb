class CreateGenrestrees < ActiveRecord::Migration
  def self.up
    create_table :genrestrees, :id => false do |t|
    t.column :parent_id, :integer
      t.column :child_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :genrestrees
  end
end
