class Aconnector < ActiveRecord::Base
  belongs_to :ltitle,  :class_name => "Ltitle", :foreign_key => 'ltitles_id'
  belongs_to :lactor,  :class_name => "Lactor", :foreign_key => 'lactors_id'
end
