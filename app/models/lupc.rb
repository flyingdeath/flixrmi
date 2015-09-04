class Lupc < ActiveRecord::Base
  belongs_to :ltitle, :foreign_key => 'ltitle_id'
end
