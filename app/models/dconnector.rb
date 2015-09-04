class Dconnector < ActiveRecord::Base
  belongs_to :ltitle,  :class_name => "Ltitle", :foreign_key => 'ltitles_id'
  belongs_to :ldirector,  :class_name => "Ldirector", :foreign_key => 'ldirectors_id'
end
