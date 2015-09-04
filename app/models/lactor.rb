class Lactor < ActiveRecord::Base
    has_many :Aconnector, :foreign_key => 'lactors_id'
    has_many :ltitles, :through => :Aconnector
end
