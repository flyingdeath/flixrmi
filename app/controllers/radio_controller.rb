class RadioController < ApplicationController

  before_filter :authlastfm

  def index
    render :nothing => true
  end

  def authlastfm

    session[:auth_lastFM] ||= false

    if !session[:auth_lastFM] or params[:action] == 'authlastfm'
      begin
        lastfm = LastFM12.new(params[:lastfm][:user],
                              params[:lastfm][:pass])
      rescue Exception => e
         lastfm = nil
      end

      if lastfm
        session[:auth_lastFM] = true
        session[:user_lastFM] = params[:lastfm][:user]
        session[:pass_lastFM] = params[:lastfm][:pass]
        text = "Authenticaed !"
      else
        session[:auth_lastFM] = false
        session[:user_lastFM] = nil
        session[:pass_lastFM] = nil
        text = "Not Authenticaed !"
      end
    else
      text = "Authenticaed !"
    end
    
    if params[:action] == 'authlastfm'
        render :text => text
    end
  end 

  def list
      begin
        lastfm = LastFM12.new(session[:user_lastFM],
                              session[:pass_lastFM])

        if params[:lastfm][:tune] and params[:lastfm][:tune] != ""
          lastfm.adjust_station("artist", params[:lastfm][:tune])
        end
        @tracks = lastfm.get_tracks
      rescue Exception => e
          session[:auth_lastFM] = false
          session[:user_lastFM] = nil
          session[:pass_lastFM] = nil
          lastfm = nil
      end
     render :partial => "listAll"
  end

end
