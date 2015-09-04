class CreateFconnectors < ActiveRecord::Migration
  def self.up
    create_table :fconnectors, :id => false do |t|
      t.column :ltitles_id, :integer
      t.column :lformats_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :fconnectors
  end
end
