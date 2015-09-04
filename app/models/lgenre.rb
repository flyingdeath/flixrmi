class Lgenre < ActiveRecord::Base

    has_many :films, :foreign_key => 'lgenres_id',
                          :class_name => 'Gconnector',
                          :dependent => :destroy
    
    has_many :ltitles,  :through => :films
                         
    has_many :conceived, :foreign_key => 'parent_id',
                         :class_name => 'Genrestree',
                         :dependent => :destroy
                         
    has_many :children,  :through => :conceived
    
    has_many :ancestors, :foreign_key => 'child_id',
                         :class_name => 'Genrestree',
                         :dependent => :destroy
                         
    has_many :parents, :through => :ancestors
end
