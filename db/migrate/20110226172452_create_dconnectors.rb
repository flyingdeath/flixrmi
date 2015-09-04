class CreateDconnectors < ActiveRecord::Migration
  def self.up
    create_table :dconnectors, :id => false do |t|
      t.column :ltitles_id, :integer
      t.column :ldirectors_id, :integer 
      t.timestamps
    end
  end

  def self.down
    drop_table :dconnectors
  end
end
