class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.column :heading, :string
      t.column :codetype, :string
      t.column :body, :string
      t.column :done, :string
      t.column :name, :string
      t.column :user, :string
      t.column :sessionId, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
