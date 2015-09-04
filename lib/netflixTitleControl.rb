
module NetflixTitleControl

#-------------------------------------------------------------------------------------------------#  
   
   def queryDB(filter, sort, queryCombos, paginate, page, per_page)
     sortOrder = sort[sort.keys[0]]
     filter['titletype'] = "ltitles.titletype in ('movie','series')"
     case queryCombos
       when 'normal'
        if paginate
         ret = Ltitle.find(:all, :conditions => joinSqlHash(filter), :order => sortOrder,
                                       :offset =>  (page),  :limit =>  per_page)
        else
         ret = Ltitle.find(:all, :conditions => joinSqlHash(filter), :order => sortOrder)
        end
       when 'availability', 'availability,normal'
         ret = getTitlesThroughFconnectors( sortOrder, filter, paginate, page, per_page )
       when 'format','format,normal'
         ret = getTitlesThroughFormats( sortOrder, filter, paginate, page, per_page )
       when 'availability,format', 'availability,format,normal'
         titleIds = mapAtt(getTitlesThroughFormats(sortOrder, filter, false, page, per_page), "ltitles_id" )
         s_filter = joinSqlHash(nilOutHashValues(filter,['formatType','normal']))
         if paginate
           ret = Ltitle.getTitlesThroughFconnectors_paginate(titleIds, sortOrder, s_filter, 
                                                            page, per_page )
         else
           ret = Ltitle.getTitlesThroughFconnectors(titleIds, sortOrder, s_filter)
         end 
       else
     end
     
     return ret
   end
#-------------------------------------------------------------------------------------------------#   
   
   def getTitlesThroughFormats(strSort, filter, paginate, page, per_page)
   
     af       = joinSqlHash(nilOutHashValues(filter,['year','formatType','titlesid']))
     f        = joinSqlHash(nilOutHashValues(filter,['formatType','availability']))
     f_filter = joinSqlHash(nilOutHashValues(filter,['year','availability','titletype','titlesid']))
     
     titleIds  = mapAtt(Ltitle.find(:all,  :conditions => f, :select=>'id'))
     formatIds = mapAtt(Lformat.find(:all, :conditions => f_filter))
     
     if paginate
       titles   = Ltitle.getTitlesThroughFormats_paginate(nil, formatIds, strSort, page, per_page, af)
     else
       titles   = Ltitle.getTitlesThroughFormats(nil, formatIds, strSort, f)
     end 
     
     return titles
   end 
#-------------------------------------------------------------------------------------------------#   
   
   def getTitlesThroughFconnectors(strSort, filter, paginate,page, per_page)
     f = joinSqlHash(filter)
     if paginate
       titles = Ltitle.getTitlesThroughFconnectors_paginate(nil, strSort, f, 
                                                          page, per_page)
     else
       titles = Ltitle.getTitlesThroughFconnectors(nil, strSort, f)
     end 
     return titles
   end 
#-------------------------------------------------------------------------------------------------# 
      
end
