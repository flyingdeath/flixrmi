class NetflixApiConnectionData

  @@baseurls = {:catalog =>      "http://api-public.netflix.com/catalog",
                :users =>        "http://api-public.netflix.com/users",
                :oauth =>        "http://api-public.netflix.com/oauth",
                :categories =>   "http://api-public.netflix.com/categories",
                :category =>     "http://api-public.netflix.com/category",
                :fill =>         "_fill_"}
                 
  @@baseurls[:access_token]        = @@baseurls[:oauth]           + "/access_token"
  @@baseurls[:request_token]       = @@baseurls[:oauth]           + "/request_token"
  @@baseurls[:titles]              = @@baseurls[:catalog]         + "/titles"
  @@baseurls[:index]               = @@baseurls[:titles]          + "/index"
  @@baseurls[:people]              = @@baseurls[:catalog]         + "/people"
  @@baseurls[:genres]              = @@baseurls[:categories]      + "/genres"
  @@baseurls[:genre]               = @@baseurls[:catalog]         + "/genres"
  @@baseurls[:person]              = @@baseurls[:people]          + "/_person_id_"
  @@baseurls[:filmography]         = @@baseurls[:fill]            + "/filmography"
  @@baseurls[:movies]              = @@baseurls[:titles]          + "/movies"
  @@baseurls[:autocomplete]        = @@baseurls[:titles]          + "/autocomplete"
  @@baseurls[:title]               = @@baseurls[:fill]            + ""
  @@baseurls[:cast]                = @@baseurls[:fill]            + "/cast"
  @@baseurls[:directors]           = @@baseurls[:fill]            + "/directors"
  @@baseurls[:format_availability] = @@baseurls[:fill]            + "/format_availability"
  @@baseurls[:awards]              = @@baseurls[:fill]            + "/awards"
  @@baseurls[:screen_formats]      = @@baseurls[:fill]            + "/screen_formats"
  @@baseurls[:languages_and_audio] = @@baseurls[:fill]            + "/languages_and_audio"
  @@baseurls[:synopsis]            = @@baseurls[:fill]            + "/synopsis"
  @@baseurls[:title_format]        = @@baseurls[:categories]      + "/title_format"
  @@baseurls[:similars]            = @@baseurls[:fill]            + "/similars"
  @@baseurls[:box_art]             = @@baseurls[:fill]            + "/box_art"
  @@baseurls[:currentUser]         = @@baseurls[:users]           + "/_user_id_"
  @@baseurls[:titles_states]       = @@baseurls[:currentUser]     + "/title_states"
  @@baseurls[:reviews]             = @@baseurls[:currentUser]     + "/reviews"
  @@baseurls[:feeds]               = @@baseurls[:currentUser]     + "/feeds"
  @@baseurls[:at_home]             = @@baseurls[:currentUser]     + "/at_home"
  @@baseurls[:reviews]             = @@baseurls[:currentUser]     + "/reviews"
  @@baseurls[:recommendations]     = @@baseurls[:currentUser]     + "/recommendations"
  @@baseurls[:rental_history]      = @@baseurls[:currentUser]     + "/rental_history"
  @@baseurls[:shipped]             = @@baseurls[:rental_history]  + "/shipped"
  @@baseurls[:returned]            = @@baseurls[:rental_history]  + "/returned"
  @@baseurls[:watched]             = @@baseurls[:rental_history]  + "/watched"
  @@baseurls[:ratings]             = @@baseurls[:currentUser]     + "/ratings/title"
  @@baseurls[:ratings_actual]      = @@baseurls[:ratings]         + "/actual"
  @@baseurls[:predicted]           = @@baseurls[:ratings]         + "/predicted"
  @@baseurls[:queues]              = @@baseurls[:currentUser]     + "/queues"
  @@baseurls[:instant]             = @@baseurls[:queues]          + "/instant"
  @@baseurls[:disc]                = @@baseurls[:queues]          + "/disc"
  @@baseurls[:instant_available]   = @@baseurls[:instant]         + "/available"
  @@baseurls[:disc_available]      = @@baseurls[:disc]            + "/available"
  @@baseurls[:instant_saved]       = @@baseurls[:instant]         + "/saved"
  @@baseurls[:disc_saved]          = @@baseurls[:disc]            + "/saved"
  
  @@params = {
    :search => [
        {:term => ""},
        {:start_index => ""},
        {:max_results => ""}  
      ],
    :search_simple => [
        {:term => ""}
      ],
    :list_simple => [
        {:start_index => ""},
        {:max_results => ""}
      ],
    :empty =>[],
    :titles_states => [
        {:title_refs => ""}
     ],
    :qlist =>[
        {:sort => ""},
        {:start_index => ""},
        {:max_results => ""},
        {:updated_min => ""}
      ],
    :delete => [
        {:method => "delete"},
        {:etag => ""},
      ],
    :delete_instant => [
        {:method => "delete"},
      ],
    :queue_update =>[
        {:etag => ""},
        {:title_ref => ""},
        {:format => ""},
        {:position => ""}
      ],
    :queue_instant_update =>[
        {:title_ref => ""},
        {:format => ""},
        {:position => ""}
      ],
    :queue_add =>[
        {:etag => ""},
        {:format => ""},
        {:position => ""}
      ],
    :queue_instant_add =>[
        {:format => ""},
        {:position => ""}
      ],
    :qlist_simple => [
        {:start_index => ""},
        {:max_results => ""},
        {:updated_min => ""}
      ],
    :create_rating => [
        {:title_ref => ""},
        {:rating => ""}
      ],
    :update_rating => [
        {:rating => ""}
      ],
    :list_bluk => [
        {:title_refs => ""},
        {:start_index => ""},
        {:max_results => ""},
        {:updated_min => ""}
      ],
    :userAuth =>[
        {:user_id => ""},
        {:oauth_token=> ""},
        {:oauth_token_secret => ""}   
    ]
  }
  
  @@prototypes = {:user => {:userAuth => true,
                            :user_id  => "_user_id_"}}
                            
  @@prototypes[:qlist] =          @@prototypes[:user].merge({:paramSet => @@params[:qlist]})
  @@prototypes[:delete] =         @@prototypes[:user].merge({:paramSet => @@params[:delete],
                                                             :verb =>     "DELETE",
                                                             :title_id => "_title_id"})
  @@prototypes[:Add] =            @@prototypes[:user].merge({:paramSet => @@params[:queue_update],
                                                             :verb =>     "POST"})
  @@prototypes[:AddOne] =         @@prototypes[:user].merge({:paramSet => @@params[:queue_add],
                                                             :verb =>     "POST",
                                                             :title_id => "_title_id"})
  @@prototypes[:deleteInstant] =   @@prototypes[:user].merge({:paramSet => @@params[:delete_instant],
                                                       :verb =>     "DELETE",
                                                       :title_id => "_title_id"})
  @@prototypes[:AddInstant] =      @@prototypes[:user].merge({:paramSet => @@params[:queue_instant_update],
                                                       :verb =>     "POST"})
  @@prototypes[:AddOneInstant] =   @@prototypes[:user].merge({:paramSet => @@params[:queue_instant_add],
                                                       :verb =>     "POST",
                                                             :title_id => "_title_id"})
  @@prototypes[:edit] =           @@prototypes[:user].merge({:paramSet => @@params[:queue_update],
                                                             :verb =>     "POST"})
  @@prototypes[:editInstant] =           @@prototypes[:user].merge({:paramSet => @@params[:queue_instant_update],
                                                             :verb =>     "POST"})
  @@prototypes[:rental_history] = @@prototypes[:user].merge({:paramSet => @@params[:qlist_simple]})
  
  @@methods = {:genaral_request =>            {:url =>          "fill"},
               :access_token =>               {:userAuth =>     true},
               :request_token =>              {},
               :autocomplete =>               {:paramSet =>     @@params[:search_simple]},
               :get_genres =>                 {:url =>          @@baseurls[:genres], 
                                               :nonUserCall => true},
               :get_full_index =>             {:url =>          @@baseurls[:index], 
                                               :writeToFile =>  ""},
               :search_tiles =>               {:url =>          @@baseurls[:titles],
                                               :paramSet =>     @@params[:search]},
               :search_people =>              {:url =>          @@baseurls[:people],
                                               :paramSet =>     @@params[:search] },
               :get_person =>                 {:url =>          @@baseurls[:person],
                                               :person_id =>    "_person_id_"},
               :get_filmography =>            {:url =>          @@baseurls[:filmography],
                                               :person_id =>    "_fill_"},
               :get_title =>                  {:url =>          @@baseurls[:title],
                                               :title_id =>     "_fill_"},
               :get_similars =>               {:url =>          @@baseurls[:similars],
                                               :title_id =>     "_fill_",
                                               :paramSet    =>  @@params[:list_simple]},
               :get_box_art =>                {:url =>          @@baseurls[:box_art],
                                               :title_id =>     "_fill_"},
               :get_cast =>                   {:url =>          @@baseurls[:cast],
                                               :title_id =>     "_fill_"},
               :get_directors =>              {:url =>          @@baseurls[:directors],
                                               :title_id =>     "_fill_"},
               :get_format_availability =>    {:url =>          @@baseurls[:format_availability],
                                               :title_id =>     "_fill_"},
               :get_awards =>                 {:url =>          @@baseurls[:awards],
                                               :title_id =>     "_fill_"},
               :get_screen_formats =>         {:url =>          @@baseurls[:screen_formats],
                                               :title_id =>     "_fill_"},
               :get_languages_and_audio =>    {:url =>          @@baseurls[:languages_and_audio],
                                               :title_id =>     "_fill_"},
               :get_synopsis =>               {:url =>          @@baseurls[:synopsis],
                                               :title_id =>     "_fill_"},
               :get_current_user =>           {:url =>          @@baseurls[:currentUser],
                                               :param =>        @@prototypes[:user]},
               :get_feeds =>                  {:url =>          @@baseurls[:feeds],
                                               :param =>        @@prototypes[:user]},
               :get_etag_instant =>           {:url =>          @@baseurls[:instant_available],
                                               :param =>        @@prototypes[:user]},
               :get_etag_disc =>              {:url =>          @@baseurls[:disc_available],
                                               :param =>        @@prototypes[:user]},
               :titles_states =>              {:url =>          @@baseurls[:titles_states],
                                               :paramSet =>     @@params[:titles_states],
                                               :userAuth =>     true,
                                               :user_id =>      "_user_id_"},
               :get_reviews =>                {:url =>          @@baseurls[:reviews],
                                               :paramSet =>     @@params[:list_bluk],
                                               :userAuth =>     true,
                                               :user_id =>      "_user_id_"},
               :get_queues =>                 {:url =>          @@baseurls[:queues],
                                               :param =>        @@prototypes[:qlist]},
               :get_instant_q =>              {:url =>          @@baseurls[:instant],
                                               :param =>        @@prototypes[:qlist]},
               :get_disc_q =>                 {:url =>          @@baseurls[:disc],
                                               :param =>        @@prototypes[:qlist]},
               :get_instant_available_q =>    {:url =>          @@baseurls[:instant_available],
                                               :param =>        @@prototypes[:qlist]},
               :get_disc_available_q =>       {:url =>          @@baseurls[:disc_available],
                                               :param =>        @@prototypes[:qlist]},
               :get_instant_saved_q =>        {:url =>          @@baseurls[:instant_saved],
                                               :param =>        @@prototypes[:qlist]},
               :get_disc_saved_q =>           {:url =>          @@baseurls[:disc_saved],
                                               :param =>        @@prototypes[:qlist]},
               :delete_instant_available_q => {:url =>          @@baseurls[:instant_available],
                                               :param =>        @@prototypes[:deleteInstant]},
               :delete_disc_available_q =>    {:url =>          @@baseurls[:disc_available],
                                               :param =>        @@prototypes[:delete]},
               :delete_instant_saved_q =>     {:url =>          @@baseurls[:instant_saved],
                                               :param =>        @@prototypes[:deleteInstant]},
               :delete_disc_saved_q =>        {:url =>          @@baseurls[:disc_saved],
                                               :param =>        @@prototypes[:delete]},
               :add_instant_q =>              {:url =>          @@baseurls[:instant],
                                               :param =>        @@prototypes[:AddInstant]},
               :add_disc_q =>                 {:url =>          @@baseurls[:disc],
                                               :param =>        @@prototypes[:Add]},
               :edit_instant_q =>             {:url =>          @@baseurls[:instant],
                                               :param =>        @@prototypes[:editInstant]},
               :edit_disc_q =>                {:url =>          @@baseurls[:disc],
                                               :param =>        @@prototypes[:edit]},
               :edit_instant_available_q =>   {:url =>          @@baseurls[:instant_available],
                                               :param =>        @@prototypes[:editInstant]},
               :edit_disc_available_q =>      {:url =>          @@baseurls[:disc_available],
                                               :param =>        @@prototypes[:Add]},
               :edit_instant_saved_q =>       {:url =>          @@baseurls[:instant_saved],
                                               :param =>        @@prototypes[:editInstant]},
               :edit_disc_saved_q =>          {:url =>          @@baseurls[:disc_saved],
                                               :param =>        @@prototypes[:Add]},
               :get_at_home =>                {:url =>          @@baseurls[:at_home],
                                               :param =>        @@prototypes[:rental_history]},
               :get_rental_history =>         {:url =>          @@baseurls[:rental_history],
                                               :param =>        @@prototypes[:rental_history]},
               :get_shipped =>                {:url =>          @@baseurls[:shipped],
                                               :param =>        @@prototypes[:rental_history]},
               :get_returned =>               {:url =>          @@baseurls[:returned],
                                               :param =>        @@prototypes[:rental_history]},
               :get_watched =>                {:url =>          @@baseurls[:watched],
                                               :param =>        @@prototypes[:rental_history]},
               :get_ratings =>                {:url =>          @@baseurls[:ratings],
                                               :paramSet =>     @@params[:titles_states],
                                               :userAuth =>     true,
                                               :user_id =>      "_user_id_"},
               :get_actual_ratings =>         {:url =>          @@baseurls[:ratings_actual],
                                               :paramSet =>     @@params[:titles_states],
                                               :userAuth =>     true,
                                               :user_id =>      "_user_id_"},
               :get_predicted_ratings =>      {:url =>          @@baseurls[:predicted],
                                               :paramSet =>     @@params[:titles_states],
                                               :userAuth =>     true,
                                               :user_id =>      "_user_id_"},
               :create_rating =>              {:url =>          @@baseurls[:ratings_actual],
                                               :paramSet =>     @@params[:create_rating],
                                               :userAuth =>     true,
                                               :user_id =>      "_user_id_",
                                               :verb =>         "POST"},
               :update_rating =>              {:url =>          @@baseurls[:ratings_actual],
                                               :paramSet =>     @@params[:update_rating],
                                               :userAuth =>     true,
                                               :rating_id =>    "_rating_id_",
                                               :user_id =>      "_user_id_",
                                               :verb =>         "PUT"},
               :get_reviews =>                {:url =>          @@baseurls[:reviews],
                                               :paramSet =>     @@params[:list_bluk],
                                               :userAuth =>     true,
                                               :user_id =>      "_user_id_"},
               :get_recommendations =>        {:url =>          @@baseurls[:recommendations],
                                               :paramSet =>     @@params[:list_simple],
                                               :userAuth =>     true,
                                               :user_id =>      "_user_id_"}            
            }
  


  def initialize

  end

  def getMethodData(methodName)
    return  @@methods[methodName]
  end

  def getParamsData(paramSetName)
    return  @@params[paramSetName]
  end

  def getbaseurlsData(methodName)
    return  @@baseurls[methodName]
  end
end
