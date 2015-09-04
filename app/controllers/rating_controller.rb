class RatingController < ApplicationController
  
  def setRating
    ratingStatus = Rating.save(params[:ext_id],params[:rating], session)
    succesMessage  = 'Your rating has been set'
    if ratingStatus.details.attributes['message'] == succesMessage
      result = 'Saved'
    else
      result = 'Not Saved'
    end
    render :text => result
  end
  
end
