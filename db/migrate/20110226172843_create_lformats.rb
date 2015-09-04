class CreateLformats < ActiveRecord::Migration
  def self.up
    create_table :lformats do |t|
      t.column :name,         :string
      t.column :availability, :string
      t.timestamps
    end
    
   # add_column(:lformats, :availability, :string)
   # script/generate migration add_fieldname_to_tablename fieldname:string

  end

  def self.down
    drop_table :lformats
  end
end
