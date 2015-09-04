require "netflix_api_connector"

module Authorization
  
  def check_session
    session[:persistentHash] = session[:persistentHash] ||= {}
    if !session[:persistentHash][:user_id] and
      (!session[:authing] or params['controller'] != "application")
      session[:authing] = true
      startAuth
    end
  end
 #-------------------------------------------------------------------------------------------------#   
     
  def startAuth
     if session[:authing]
       case  params['action']
       when  "testToken", "startAuth", "check_session"
         session[:controller] = ""
         session[:action]     = ""
       else
         session[:controller] = params['controller']
         session[:action]     = params['action']
       end
       methodName = "testToken"
       returnUrl = "http://" + self.request.host       + ":" +
                              self.request.port.to_s  + "/" +
                              "flixrmi/application"    + "/" +
                              methodName
       connector = NetflixApiConnector.new(session)
       url =  connector.startAuth(returnUrl)
       redirect_to url
     else
        redirect_to "/"
     end
  end
  
   #-------------------------------------------------------------------------------------------------# 
 
 def testToken
    if params['oauth_token']

      connector = NetflixApiConnector.new(session, params)
      connector.testAccessToken()
      session[:authing] = false

      unless connector.checkUserSession()
        session[:persistentHash][:secret] = nil
        session[:persistentHash][:token] = nil
        session[:persistentHash][:user_id] = nil
      end
      
      if session[:controller] != ""
        u = User.find(session)
        user1 = Users.find(:all, :conditions => ["user_id = ? ", u.attributes['user_id']])[0]
        if !user1 
          new_user =  Users.new( {:nickname   => u.attributes['nickname'],
                                  :user_id    => u.attributes['user_id'],
                                  :last_name  => u.attributes['last_name'],
                                  :first_name => u.attributes['first_name']})
          new_user.save
        else
          if user1.session_id
           i = user1.session_id.to_i + 1
          else
           i = 2
          end
          user1.update_attributes({:nickname   => u.attributes['nickname'],
                                  :user_id    => u.attributes['user_id'],
                                  :last_name  => u.attributes['last_name'],
                                  :first_name => u.attributes['first_name'],
                                  :session_id => i.to_s})
        end 
        
      end

   #   if session[:controller] != ""
   #     redirect_to :controller => session[:controller], :action => session[:action]
   #   else
   #     redirect_to "/index_load.html"
   #   end
    end
    redirect_to "/index_load.html"
  end
end
