class Ldirector < ActiveRecord::Base
    has_many :Dconnectors, :foreign_key => 'ldirectors_id'
    has_many :ltitles, :through => :Dconnectors
end
