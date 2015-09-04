class Lformat < ActiveRecord::Base
    has_many :Fconnector, :foreign_key => 'lformats_id'
    has_many :ltitles, :through => :Fconnector
end
