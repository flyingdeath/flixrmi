
module TitleControl

  private
#-------------------------------------------------------------------------------------------------#   
    
   def getQueryTypes(filter, sort)
     
     downConvertData={'RatingPredicted'  => 'normal',
                      'RatingAverage'    => 'normal',
                      'RatingUser'       => 'normal',
                      'Rating Predicted' => 'normal',
                      'Rating Average'   => 'normal',
                      'Rating User'      => 'normal',
                      'availability'     => 'availability',
                      'Availability'     => 'availability',
                      'formatType'       => 'format',
                      'year'             => 'normal',
                      'rating'           => 'normal',
                      'Year'             => 'normal',
                      'Name'             => 'normal'}
                      
     ratingConvertData={'RatingPredicted'  => 'rating',
                        'RatingAverage'    => 'rating',
                        'RatingUser'       => 'rating',
                        'rating'           => 'rating',
                        'Rating Predicted' => 'rating',
                        'Rating Average'   => 'rating',
                        'Rating User'      => 'rating',
                        'rating'           => 'rating'}
                        
     m_querySet = filter.merge(sort)
     
     to_paginate = []
     queryTypes = {}
     
     m_querySet.each{|key,value|
       queryTypes[downConvertData[key]] = 0 
       to_paginate << ratingConvertData[key]
     }
     
     paginate = (to_paginate.compact == [])
      
     queryCombos = queryTypes.keys.sort.join(',')
     
     return {:paginate => paginate, :queryCombos => queryCombos}
   end
#-------------------------------------------------------------------------------------------------#   
      
   def mapAtt(a, att="id")
     ids =  a.map {|x|
                     if x.attributes[att]
                       x.attributes[att]
                     else
                       nil
                     end
                   }.compact
     return ids
   end
   
   def nilOutHashValues(h,a)
     c = h.clone
     a.each{|a|
       c[a] = nil
     }
     return  c
   end 
   
   def getSqlFilters(sortVar)
     ret = {}
     sortVar[:filterSet].each{|key,value|
       case key
         when 'availability'
          ret[key] = getAvailabilityConditions(value)
         when 'formatType'
          ret[key] = getFormatTypeConditions(value)
         when 'year'
          ret[key] = getYearConditions(value)
         else
       end 
     }
     return ret
   end
   
   def joinSqlHash(h)
     ret = ""
     h.each{|key,value|
      if value
        ret += value + " and "
      end
     }
     if ret != "" 
       ret =  ret[0, ret.length - 5]
     end
     return ret
   end
   

#-------------------------------------------------------------------------------------------------#   
      
   def getFormatTypeConditions(set)
     ret = ""
     case set[:FormatType]
       when "Disc"
         ret += " (lformats.name = 'Blu-ray' or lformats.name = 'DVD' )"
       when "Blu-ray", "DVD", "Instant"
         ret += " lformats.name = '" + set[:FormatType] + "'"
       else
     end
     return ret
   end

#-------------------------------------------------------------------------------------------------#   
      
   def getYearConditions(set)
     ret = ""
     if set[:AtMost] 
       ret += " ltitles.release_year <=  " + prepYearValue(set[:AtMost]) + " "
     end
     if set[:AtLeast] 
       if ret != ""
         ret += " and"
       end
       ret += " ltitles.release_year >= "+ prepYearValue(set[:AtLeast]) + " "
     end
     return ret
   end

#-------------------------------------------------------------------------------------------------#   
      
   def getAvailabilityConditions(set)
     ret = ""
     if set[:AtMost] 
       ret += " fconnectors.availability <=  '" + prepAvailabilityValue(set[:AtMost]) + "' "
     end
     
     if set[:AtLeast]
       if ret != ""
         ret += " and"
       end
       ret += " fconnectors.availability >= '" + prepAvailabilityValue(set[:AtLeast]) + "' "
     end
     return ret
   end

#-------------------------------------------------------------------------------------------------#   
      
   def prepYearValue(v)
     return v.gsub("'s",'')
   end 
   
   def prepAvailabilityValue(v)
     if v
       today = Time.now()
       timeSet = {'Plus 1 Year'    => (today.advance(:years  => 1)),
                  'Plus 6 Months'  => (today.advance(:months => 6)),
                  'Plus 3 Months'  => (today.advance(:months => 3)),
                  'Plus 1 Month'   => (today.advance(:months => 1)),
                  'Plus 1 Week'    => (today.advance(:weeks  => 1)),
                  'Today'          => (today),
                  'Minus 1 Week'   => (today.advance(:weeks  => -1)),
                  'Minus 1 Month'  => (today.advance(:months => -1)),
                  'Minus 3 Months' => (today.advance(:months => -3)),
                  'Minus 6 Months' => (today.advance(:months => -6)),
                  'Minus 1 Year'   => (today.advance(:years  => -1))}
                  
        ret = timeSet[v].to_s(:db)
     else
       ret = ""
     end
     return ret
   end 
   
 
#-------------------------------------------------------------------------------------------------#   
     
   
   def paginateTitles(titles, listIndex, listInc, paginate)
     if paginate
     
        start = listIndex
        
        stop = (listIndex + listInc) - 1
        
        if stop > titles.length
           stop = titles.length - 1
        end
        
        titles = titles[start..stop]

        if !titles
          titles = []
        end
     end 
     
     return titles
   end    
   
#-------------------------------------------------------------------------------------------------#   
   
      
   def getRatingFilterType(filterVar)
     ret = {'Predicted' => 'RatingPredicted',
            'Average'   => 'RatingAverage',
            'User'      => 'RatingUser'}
     
     #r = {'Predicted' => 'predicted_rating',
     #     'Average'   => 'average_rating',
     #     'User'      => 'user_rating'}
          
          
     att = ret[filterVar[:FliterRatingType]]
     atLeast = filterVar[:AtLeast] ||= 0.0
     atMost  = filterVar[:AtMost] ||= 5.0
     atMost  = atMost.to_f
     atLeast  = atLeast.to_f
     if atLeast != 0.0 or atMost != 5.0 
       return {'rating' => ret[filterVar[:FliterRatingType]]}
     else
       return {}
     end 
   end 
     
   
   def getTitlesfilterByRating(titles, ratings, filter)
     r = {'Predicted' => 'predicted_rating',
          'Average'   => 'average_rating',
          'User'      => 'user_rating'}
          
     att = r[filter[:FliterRatingType]]
     atLeast = filter[:AtLeast] ||= 0.0
     atMost  = filter[:AtMost] ||= 5.0
     atMost  = atMost.to_f
     atLeast  = atLeast.to_f
     if atLeast != 0.0 or atMost != 5.0 
       titles.reject!{|a|
        if ratings[a.ext_id]
           v = ratings[a.ext_id].attributes[att].to_f
           if v
            !(v >= atLeast and v <= atMost)
           else
            (true)
           end 
         else
          (true)
         end 
       }
     end
     temp = 0
     return titles
   end    
   
#-------------------------------------------------------------------------------------------------#   
    
   
   def getTitlesOrderByRating(titles, ratings, sortVar)
    r = {'RatingPredicted' => 'predicted_rating', 
         'RatingAverage'   => 'average_rating', 
         'RatingUser'      => 'user_rating'}
    att = r[sortVar[:Sort]]
    if att
      mValue = 6.0
      titles.sort!{|a,b| 
        if ratings[a.ext_id] and ratings[b.ext_id]
          vA = ratings[a.ext_id].attributes[att].to_f
          vB = ratings[b.ext_id].attributes[att].to_f
          ret = nil
          if !vA or !vB
            if vA
              ret = (vA <=> mValue)
            elsif vB
              ret = (mValue <=> vB)
            end 
            if !ret
              ret = (mValue <=> mValue)
            end
          else
            ret = (vA <=> vB)
          end
        else
          ret = (mValue <=> mValue)
        end
      }
      if sortVar[:SortOrder] == "DESC"
        titles.reverse!
      end
    end
    return titles
   end 
   
#-------------------------------------------------------------------------------------------------#   
    
    
   def setSortOrder(sortVar)
       if params[:Sort] == sortVar[:Sort]
          if sortVar[:SortOrder] == "DESC"
            sortVar[:SortOrder] = "ASC"
          else
            sortVar[:SortOrder] = "DESC"
          end
          setParamVar(sortVar, :Sort)
       else
         setInitSortOrder(sortVar)
       end
   end
   
   def setInitSortOrder(sortVar)
     setParamVar(sortVar, :Sort)
      if sortVar[:Sort] == "Name"
        sortVar[:SortOrder] = "ASC"
      else
        sortVar[:SortOrder] = "DESC"
      end 
   end 
   
   def getSortOrder(sortVar)
      fieldSet = {'RatingPredicted'  => 'ltitles.title',
                  'RatingAverage'    => 'ltitles.title',
                  'RatingUser'       => 'ltitles.title',
                  'Rating Predicted' => 'ltitles.title',
                  'Rating Average'   => 'ltitles.title',
                  'Rating User'      => 'ltitles.title',
                  'Name'             => 'ltitles.title',
                  'Availability'     => 'Fconnectors.availability',
                  'Year'             => 'ltitles.release_year'}
       ret = {}
       ret[sortVar[:Sort]] =  fieldSet[sortVar[:Sort]] + " " + sortVar[:SortOrder]
     return ret
   end 
   
   
 #-------------------------------------------------------------------------------------------------#   

    def getClassSessionVariable(key)
    
      if session[:ViewEnvelop] == 'ViewEnvelop'
        key = 'EnvelopedOptions'
      end 
      
      unless session[key]
        session[key] = {:viewType => :List}
      end 
      return session[key]
    end 
    
    def getPanelListKey(key)
       convert = {'recommendationsPanel' => 'listRecommendations',
                  'categoryPanel'        => 'listCategory',
                  'searchPanel'          => 'listSearch',
                  'historyPanel'         => 'listHistory',
                  'simlarsPanel'         => 'listSimlars',
                  'newfilmsPanel'        => 'listNew'}
      return convert[key]
   end   
            
   
   def getListSessionVariable(key, stype = 'filter')
     e = 'EnvelopedOptions'
     
     viewEnvelop = (session[:ViewEnvelop] == "true")
     filterEnvelop = (session[:FilterEnvelop] == "true")
     sortEnvelop = (session[:SortEnvelop] == "true")
     
     if (stype == 'filter' and filterEnvelop) or 
        (stype == 'view' and viewEnvelop ) or 
        (stype == 'sort' and sortEnvelop )
       key = e
     end 
     
     unless session[key]
      session[key] = {:filterSet => {'rating'=> {:FliterRatingType => 'Predicted'}}, 
                      :Sort => "Name", 
                      :SortOrder => "ASC" , 
                      :viewType => 'Thumbnails Grid', 
                      :index => 0, 
                      :inc => 25}
     end 
     return session[key]
     
   end

   def setFilters(fltVar)
   
     unless fltVar[:filterSet][params[:filterKey]]
       fltVar[:filterSet][params[:filterKey]] = {} 
     end
       
     if params[:filterKey]
       [:AtMost, :AtLeast, :FliterRatingType, :FormatType].each{|sym|
         if params[sym]
           fltVar[:filterSet][params[:filterKey]][sym] = params[sym]
         end
       }
     end 
     fltVar[:filterSet] = cleanFilterSet(fltVar[:filterSet])
   end
 #-------------------------------------------------------------------------------------------------#   
       
         
  def clientVarsUpdate_core()
     configs :updatableVars 
     @updatableVars.each{|item|
       if params[item]
          session[item] = params[item]
       end
     }
  end  
  
   def cleanFilterSet(h)
     h.each{|key,value|
       value = rejectValues(value,"All")
     }
     h = rejectValues(h,{})
     return  h
   end
   
   def rejectValues(h,rValue)
     ret = {}
     if h.delete_if
       ret = h.delete_if{|key,value|
         (value == rValue)
       }
     end
     return ret
   end
   #-------------------------------------------------------------------------------------------------#   
    
     def changeListPostion(lName, reset, inc = 25, page = 0)
       sessionVar = getListSessionVariable(lName)
       if !reset
         sessionVar[:index]  = (inc * page)
       else
         sessionVar[:index] = 0
         sessionVar[:inc] = inc
       end 
       @paginationVars = {:pageIndex => sessionVar[:index], 
                          :perPage   => sessionVar[:inc],
                          :listType  => lName,
                          :isReset   => reset,
                          :page      => page}
       session[:paginationVars] = @paginationVars 
     end
     
   #-------------------------------------------------------------------------------------------------#   
     
     def renderTitles(categoryViewType, nothing = false, surfix = "")
       @categoryViewType = categoryViewType
       if nothing
         render :nothing  => true
       else
         case categoryViewType
           when "ViewGrid"
             @columnsMax =getColumnsMaxWidth( session[:clientwidth]) 
             render :partial => "category/listTableCategory" + surfix
           when "ViewList"
             render  :partial => "category/listCategory" + surfix
           else
             render  :partial => "category/listCategory" + surfix
         end
       end
     end
  #-------------------------------------------------------------------------------------------------#   
   
      def getColumnsMaxWidth(clientWidth)
        if clientWidth
          return clientWidth.to_i / 120
        else
          return 2
        end 
      end
  #-------------------------------------------------------------------------------------------------#   
  
     def setParamSessionVar(key, sessionkey = nil)
       if sessionkey
         session[sessionkey] = params[key] ||= session[sessionkey]
       else
         session[key] = params[key] ||= session[key]
       end 
     end    
     
     def setParamVar(var, key, sessionkey = nil)
       if sessionkey
         var[sessionkey] = params[key] ||= session[sessionkey]
       else
         var[key] = params[key] ||= var[key]
       end 
     end  
   
  #-------------------------------------------------------------------------------------------------#   
       
      def getTitleStates(titleSet,session)
        return Cue.find_titles_states(session,Ltitle.getTitleRefs(titleSet))
      end 
   #-------------------------------------------------------------------------------------------------#   
        
        
      def getTitleRatings(titleSet,session)
        
        ratings = Rating.find(Ltitle.getTitleRefs(titleSet),session)
        
        return ratings
      end
      
      def getTitleRatings_cached(titleSet, session, paginate, requestpage, prefix)
        u = session[:persistentHash][:user_id]
        if !requestpage or (requestpage and paginate)
          ret = getTitleRatings(titleSet,session)
          Rails.cache.write(prefix + "ratings"+ u, nil)
          if !paginate
            Rails.cache.write(prefix + "ratings"+ u, ret)
          end 
        else  
          ret = Rails.cache.read(prefix + "ratings"+ u)
        end
        return ret
      end
   #-------------------------------------------------------------------------------------------------#   
  
   #-------------------------------------------------------------------------------------------------#   
     def unfreezeArray(a)
        if a 
         return [].concat(a)
        else
         return []
        end
     end 
   #-------------------------------------------------------------------------------------------------#   
   
end
