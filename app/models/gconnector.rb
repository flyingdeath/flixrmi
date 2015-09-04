class Gconnector < ActiveRecord::Base
  belongs_to :ltitle,  :class_name => "Ltitle", :foreign_key => 'ltitles_id'
  belongs_to :lgenre,  :class_name => "Lgenre", :foreign_key => 'lgenres_id'
end
