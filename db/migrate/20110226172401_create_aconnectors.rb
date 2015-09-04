class CreateAconnectors < ActiveRecord::Migration
  def self.up
    create_table :aconnectors, :id => false do |t|
      t.column :ltitles_id, :integer
      t.column :lactors_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :aconnectors
  end
end
