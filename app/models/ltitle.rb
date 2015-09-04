class Ltitle < ActiveRecord::Base
    has_many :lupcs,  :source => :lupcs, :foreign_key => 'ltitle_id'
    has_many :Dconnectors, :foreign_key => 'ltitles_id'
    has_many :Aconnector, :foreign_key => 'ltitles_id'
    has_many :Fconnector, :foreign_key => 'ltitles_id'
    has_many :categories, :foreign_key => 'ltitles_id',
                          :class_name => 'Gconnector',
                          :dependent => :destroy
    
    has_many :lgenres,  :through => :categories
    
    has_many :lformats,   :through => :Fconnector,  :source => :lformat
    has_many :lactors,    :through => :Aconnector,  :source => :lactor
    has_many :ldirectors, :through => :Dconnectors, :source => :ldirector
   
   def self.find_by_netflix_set(titleSet)
     ext_ids  = mapAtt(titleSet,"ext_id")
     return find_by_titleRefs(ext_ids)
   end 
   
   def self.find_by_titleRefs(ext_ids)
     titles = find(:all,  :conditions => ['ext_id in (?)', ext_ids ])
     h = {}
     titles = titles.reject{|x| 
                avalible = (h[x.ext_id])
                h[x.ext_id] = true
                avalible
              }
     titles = ext_ids.collect {|id| 
                  titles.detect {|x| 
                    (x.ext_id == id)
                  }
              }.compact
     return titles
   end 
   
   def self.getTitleRefs(titleSet)
     tiles_refs = ""
     len = titleSet.length
     i = 1
     if titleSet
       titleSet.each{|title|
         if title
           if title.ext_id and title.ext_id != ""
             tiles_refs += title.ext_id 
           end
           if len > i 
             tiles_refs += ","
           end 
           i += 1
         end
       }
      # tiles_refs = tiles_refs.chop
     end
     return tiles_refs
   end
   
   def self.mapAtt(a, att="id")
     ids =  a.map {|x|
                      if x
                       if x.attributes[att]
                         x.attributes[att]
                       else
                         nil
                       end
                     else
                      nil
                     end 
                   }.compact
     return ids
   end
   
  
   def self.getTitlesThroughFormats(titleIds, formatIds, strSort, filter = "")
     
     titles = find_by_sql(['SELECT  DISTINCT ltitles.* FROM ltitles '+
                                   'INNER JOIN fconnectors '+
                                   'ON ltitles.id = fconnectors.ltitles_id '+
                                   'WHERE ' + 
                                    getFilter([' fconnectors.lformats_id in (?) ', getIdFilter(titleIds), filter]) +
                                   ' ORDER BY '+strSort+';', formatIds, titleIds  ].compact)
     return titles
   end 
   
   def self.getTitlesThroughFormats_paginate(titleIds, formatIds, strSort, listIndex, listInc, filter = "")
     titles = find_by_sql(['SELECT DISTINCT ltitles.* FROM ltitles '+
                                   'INNER JOIN fconnectors '+
                                   'ON ltitles.id = fconnectors.ltitles_id '+
                                   'WHERE '+ 
                                    getFilter([' fconnectors.lformats_id in (?) ', getIdFilter(titleIds), filter]) +
                                   ' ORDER BY '+ strSort + 
                                   ' LIMIT ' + listIndex.to_s + ', ' + listInc.to_s, 
                                    formatIds, titleIds ].compact)
     return titles
   end 
   
   def self.getTitlesThroughFconnectors(titleIds, strSort, filter)
     titles = find_by_sql(['SELECT DISTINCT ltitles.* FROM ltitles '+
                                   'INNER JOIN fconnectors '+
                                   'ON ltitles.id = fconnectors.ltitles_id '+
                                   'WHERE ' + getFilter([getIdFilter(titleIds), filter]) +
                                   ' ORDER BY '+strSort+';', titleIds ].compact)
     return titles
   end 
   
   def self.getTitlesThroughFconnectors_paginate(titleIds, strSort, filter, listIndex, listInc)
     titles = find_by_sql(['SELECT DISTINCT ltitles.* FROM ltitles '+
                                       'INNER JOIN fconnectors '+
                                       'ON ltitles.id = fconnectors.ltitles_id '+
                                       'WHERE ' + getFilter([getIdFilter(titleIds), filter])  +
                                       ' ORDER BY '+strSort + 
                                       ' LIMIT ' + listIndex.to_s + ', ' + listInc.to_s, 
                                       titleIds ].compact )
     return titles
   end 
   
   
   def self.getFilter(a)
     a.reject!{|i| i == "" or !i}
     return a.join(" and ")
   end 
   
   
   def self.getIdFilter(titleIds)
     ret = ""
     if titleIds
       if titleIds.length > 0 
         ret = "ltitles.id in (?) "
       end 
     end  
     return ret
   end
   
end
