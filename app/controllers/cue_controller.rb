class CueController < ApplicationController
   
   def addDisc
      status = Cue.save(session, params[:ext_id],"","",false)
      Rails.cache.write("cueStatus"+ session[:persistentHash][:user_id] , status)
      if "success,Title is already in queue".index(status.details.attributes['message'])
        status.details.attributes['message'] = 'Title Added to Queue'
      else
        status.details.attributes['message'] = 'Title Not Added to Queue'
      end 
      Rails.cache.write("simlars_id"+ session[:persistentHash][:user_id], params[:ext_id] )
      redirect_to :controller => "title", :action => 'getSimlars'
   end 
   
   def addInstant
      status = Cue.save(session, params[:ext_id],"","",true)
      if "success,Title is already in queue".index(status.details.attributes['message'])
        status.details.attributes['message'] = 'Title Added to Queue'
      else
        status.details.attributes['message'] = 'Title Not Added to Queue'
      end 
      Rails.cache.write("cueStatus" + session[:persistentHash][:user_id],status )
      Rails.cache.write("simlars_id" + session[:persistentHash][:user_id],params[:ext_id] )
      redirect_to :controller => "title", :action => 'getSimlars'
   end
   
   def saveDisc
      status = Cue.save(session, params[:ext_id],"","",false)
      if "success,Title is already in queue".index(status.details.attributes['message'])
        status.details.attributes['message'] = 'Title Saved to Queue'
      else
        status.details.attributes['message'] = 'Title Not Saved to Queue'
      end 
      Rails.cache.write("cueStatus"+ session[:persistentHash][:user_id],status )
      Rails.cache.write("simlars_id"+ session[:persistentHash][:user_id],params[:ext_id] )
      redirect_to :controller => "title", :action => 'getSimlars'
   end 
   
   def deleteTitle
      ext_idSet = params[:ext_id].split("/")
      id = ext_idSet[ext_idSet.length - 1]
      @status = Cue.destroy(session, id, (params[:queueType] == "Instant"))
      if ("Title deleted from queue".index(@status.details.attributes['message']))
        @status.details.attributes['message'] = 'Title deleted from Queue'
      else
        @status.details.attributes['message'] = 'Title Not deleted from Queue'
      end 
      render :partial => "category/results"
   end 
   
   def undoDeleteTitle
      @status = Cue.save(session, params[:ext_id],"","", (params[:queueType] == "Instant"))
      if "success,Title is already in queue".index(@status.details.attributes['message'])
        @status.details.attributes['message'] = 'Title Added to Queue'
      else
        @status.details.attributes['message'] = 'Title Not Added to Queue'
      end 
      render :partial => "category/results"
   end
   
   def moveTitle
      @status = Cue.edit(session, params[:ext_id],"",params[:position],(params[:queueType] == "Instant") )
      if "success,Move successful".index(@status.details.attributes['message'])
        @status.details.attributes['message'] = 'Title Moved'
      else
        @status.details.attributes['message'] = 'Title Not Moved'
      end 
      render :partial => "category/results"
   end
   
   
   def listQueue()
     setParamSessionVar(:QueueType)
   #  sessionVar = getListSessionVariable('listQueue')
   #  changeListPostion('listQueue', true, sessionVar[:inc])
     queue_p(session[:QueueType])
     renderTitles(session[:categoryViewType])
   end 
   
   def queue_p(queueType, start = 0, max = 500)
     case queueType
       when "Disc"
         @titlesData      = Cue.find_defined2(session, start, max,"28800","queue_sequence",false)
         @titlesDataSaved = Cue.find_defined2(session, start, max,"28800","queue_sequence",false, true)
       when "Instant"
         @titlesData      = Cue.find_defined2(session, start, max,"28800","queue_sequence",true)
         @titlesDataSaved = Cue.find_defined2(session, start, max,"28800","queue_sequence",true, true)
     end
     if @titlesData
       if @titlesData.set
         @titles      = Ltitle.find_by_netflix_set(@titlesData.set)
         @savedTitles = Ltitle.find_by_netflix_set(@titlesDataSaved.set)
         #all          = @titles.concat(@savedTitles)
         
         @ratings = getTitleRatings(@titles,session)
         @ratings = @ratings.merge(getTitleRatings(@savedTitles,session))
         
     
         
         states1      = getTitleStates(@titles,session)
         states2      = getTitleStates(@savedTitles,session)
         @states      = states2.merge(states1)
         @queueType   = queueType
       else
          @titles = []
       end
     else
        @titles = []
     end 
     @listType = "queuePanel"
   end 
   
   
   
end
