class PeopleController < ApplicationController

  def showPerson
    if params[:type] == 'director'
      @person = Ldirector.find(params[:id])
    else
      @person = Lactor.find(params[:id])
    end
    ext_idSet = @person.ext_id.split("/")
    personId = ext_idSet[ext_idSet.length - 1]
    @extendedPerson = People.find(session,personId);
    @filmography    = People.find_filmography(session,@person.ext_id);
    @titles         = Ltitle.find_by_netflix_set(@filmography.set)
    @ratings        = getTitleRatings(@titles,session)
    @states         = getTitleStates(@titles,session) 
    
    @listType = @person.id.to_s + '_personInfoPanel'
    
    render :partial => "showPerson"
    
  end 
  
end
