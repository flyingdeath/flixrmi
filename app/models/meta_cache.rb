class MetaCache < ActiveRecord::Base

   def self.find_by_titleRefs(ext_ids, user_id)
     return find(:all,  :conditions => ["ext_id in (?) and user_id = ? ", ext_ids, user_id ])
   end 
   
   def self.mapAtt(a, att="id")
     ids =  a.map {|x|
                     if x.attributes[att]
                       x.attributes[att]
                     else
                       nil
                     end
                   }.compact
     return ids
   end
   
end
