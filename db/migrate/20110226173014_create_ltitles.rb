class CreateLtitles < ActiveRecord::Migration
  def self.up
    create_table :ltitles do |t|
      t.column :title, :string
      t.column :ext_id, :string
      t.column :netflixLink, :string
      t.column :release_year, :string
      t.column :updated, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :ltitles
  end
end
