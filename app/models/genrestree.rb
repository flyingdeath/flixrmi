class Genrestree < ActiveRecord::Base
    belongs_to :parent, :class_name => "Lgenre"
    belongs_to :child,  :class_name => "Lgenre"
end
