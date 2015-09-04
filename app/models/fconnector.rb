class Fconnector < ActiveRecord::Base
  belongs_to :ltitle,  :class_name => "Ltitle", :foreign_key => 'ltitles_id'
  belongs_to :lformat,  :class_name => "Lformat", :foreign_key => 'lformats_id'
end
