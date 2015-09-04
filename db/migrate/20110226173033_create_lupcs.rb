class CreateLupcs < ActiveRecord::Migration
  def self.up
    create_table :lupcs do |t|
      t.column :number, :string
      t.column :ltitle_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :lupcs
  end
end