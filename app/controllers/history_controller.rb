
require "netflixTitleControl.rb"

class HistoryController < ApplicationController

include NetflixTitleControl

   def listHistory()
     setParamSessionVar(:HistoryType)
     sessionVar = getListSessionVariable('listHistory')
     changeListPostion('listHistory', true,  sessionVar[:inc])
     rentalHistory_p(session[:HistoryType], sessionVar[:index], sessionVar[:inc])
     renderTitles(session[:categoryViewType])
   end 
   
   def history_pagination
     setParamSessionVar(:HistoryType)
     sessionVar = getListSessionVariable('listHistory')
     rentalHistory_p(session[:HistoryType], sessionVar[:index], sessionVar[:inc], true)
      @paginationVars  = session[:paginationVars]
     renderTitles(session[:categoryViewType], false, "Loop")
   end    
   
   private     
   
   def rentalHistory_p(historyType, start = 0, max = 25, requestpage = false)
   
     u = session[:persistentHash][:user_id]
   
     titles = Rails.cache.read(historyType + 'history'+u)
     titlesAll_length  = Rails.cache.read(historyType + 'titlesAll_history'+u)
     
     if !titles
       case historyType
         when "All"
           titlesData = RentalHistory.find(session)
         when "At Home"
           if start == 0
             titlesData = RentalHistory.find_at_home(session)
           else
         end
         when "Shipped"
           titlesData = RentalHistory.find_shipped(session)
         when "Returned"
           titlesData = RentalHistory.find_returned(session)
         when "Watched"  
           titlesData = RentalHistory.find_watched(session)
       end
       if titlesData
         if titlesData.set
           titles = Ltitle.mapAtt(titlesData.set, att="ext_id")
           titlesAll_length = titles.length
           titles = "'"+titles.join("','")+"'"
           Rails.cache.write(historyType + 'history'+u,titles)
           Rails.cache.write(historyType + 'titlesAll_history'+u,titlesAll_length)
         else
           titles = nil
         end
       else
         titles = nil
       end
     end
     
     
     if titles
         sessionVar = getListSessionVariable('listHistory')
         sortSessionVar = getListSessionVariable('listHistory','sort')
         fliters   = getSqlFilters(sessionVar)
         rFlt      = fliters.merge(getRatingFilterType(sessionVar[:filterSet]['rating']))
         sortOrder = getSortOrder(sortSessionVar)
         types     = getQueryTypes(rFlt, sortOrder)
         
         #@titles   = queryDBFilterTitles(@titles, fliters, sortOrder, types[:queryCombos])
         
         fliters['titlesid'] = "ltitles.ext_id in ("+ titles+")"

         @titles   = queryDB(fliters, sortOrder, types[:queryCombos], types[:paginate], start, max)
           
         
         @ratings = getTitleRatings_cached(@titles, session, types[:paginate], requestpage, 'listHistory')

         #@ratings  = getTitleRatings(@titles,session)
         
         
         @titles   = getTitlesfilterByRating(@titles, @ratings, sessionVar[:filterSet]['rating'])
         @titles   = getTitlesOrderByRating(@titles, @ratings, sortSessionVar)
         
         if !types[:paginate]
           titlesAll_length = @titles.length
         end 
         
         @titles   = paginateTitles(@titles, start, max, !types[:paginate])
     
         @states   = getTitleStates(@titles,session)
         
         @titlesData = ActiveDummySet.new
         @titlesData.details = ActiveDummy.new
         @titlesData.details.attributes = {:start_index => start, 
                                           :results_per_page => max, 
                                           :number_of_results => titlesAll_length} 
     else
        @titles    = []
     end 
     @listType = "historyPanel"
   end 

end
