class CreateMetaCaches < ActiveRecord::Migration
  def self.up
    create_table :meta_caches do |t|
      t.column :alternate_link, :string
      t.column :BoxArtMedium, :string
      t.column :BoxArtLarge, :string
      t.column :BoxArtSmall, :string
      t.column :runtime, :string
      t.column :ext_id, :string
      t.column :predicted_rating, :string
      t.column :average_rating, :string
      t.column :user_rating, :string
      t.column :user_id, :string
      t.column :title_formats, :string 
      t.column :title_states, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :meta_caches
  end
end
