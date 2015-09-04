class CreateGconnectors < ActiveRecord::Migration
  def self.up
    create_table :gconnectors, :id => false do |t|
      t.column :ltitles_id, :integer
      t.column :lgenres_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :gconnectors
  end
end
