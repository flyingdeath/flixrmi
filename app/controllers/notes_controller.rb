class NotesController < ApplicationController
  before_filter :authorize, :except => [:list, :create]

  def list
    @notes = Note.find(:all, :order => "created_at DESC")
    render :partial => "listAll"
  end

  def create
    @note = Note.new(params[:note])
    @note.body = @note.body.to_s.html_safe
    u = Users.find_by_user_id(session[:persistentHash][:user_id])
    @note.name = u.nickname 
    
    @results = {}
    if @note.save
       @status = "Saved" 
    else
       @status = "Not Saved" 
    end
      render :partial => "results"
  end

  def update
    @note = Note.find(params[:id])
    
    if @note.update_attributes(params[:note])
       @status = "Saved" 
    else
       @status = "Not Saved" 
    end
    render :partial => "results"
  end
  
  def destroy 
    @note = Note.find(params[:id])

    if @note.destroy
       @status = "Destroyed" 
    else
       @status = "Not Destroyed" 
    end
    render :partial => "results"
  end
  
  
end