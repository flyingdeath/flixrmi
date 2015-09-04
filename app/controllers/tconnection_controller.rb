class TconnectionController < ApplicationController
  before_filter :authorize
  
   def getTags
     i = Rails.cache.read("taglist"+ session[:persistentHash][:user_id])
    render :text => i.to_yaml
   end 
   
   def clearTags
     Rails.cache.write("taglist"+ session[:persistentHash][:user_id], [])
     getTags
   end

   def userTable
     @users = Users.all 
   end
   
  
   def testApiCalls
    runApiCalls
    render :action => "index"
   end
   
   def nextApiCall
    runApiCalls
    render :partial => 'listTestData', :locals => {:apiObj => @titleInfo}
   end
   
   def runApiCalls
   
    id = params[:id].to_f
    
    #if !index 
    #  index = 1
    #end 
    
    # Title
      case id

        when 1 
          @titleInfo = Title.find_by_name(session, "La Femme Nikita")

        when 2 
          @titleInfo = Title.find_by_name(session,"La Femme Nikita",true)

        when 3 
          @titleInfo = Title.find(session,"http://api-public.netflix.com/catalog/titles/movies/60029028")
          
        when 4 
          @titleInfo = Title.find_similars(session,"http://api-public.netflix.com/catalog/titles/movies/60029028")

        when 5 
          @titleInfo = Title.find_cast(session,"http://api-public.netflix.com/catalog/titles/movies/60029028")

        when 6 
          @titleInfo = Title.find_directors(session, "http://api-public.netflix.com/catalog/titles/movies/60029028")

        when 7 
          @titleInfo = Title.find_format_availability(session,"http://api-public.netflix.com/catalog/titles/movies/60029028")

        when 8 
          @titleInfo = Title.find_awards(session, "http://api-public.netflix.com/catalog/titles/movies/60029028")

        when 9 
          @titleInfo = Title.find_screen_formats(session,"http://api-public.netflix.com/catalog/titles/movies/60029028")

        when 10 
          @titleInfo = Title.find_languages_and_audio(session, "http://api-public.netflix.com/catalog/titles/movies/60029028")

        when 11 
          @titleInfo = Title.find_synopsis(session, "http://api-public.netflix.com/catalog/titles/movies/60029028")

        when 12
          @titleInfo = Title.find_recommendations(session)

            # People


        when 13 
          @titleInfo = People.find_by_name(session, "Anne Parillaud")

        when 15 
          @titleInfo = People.find(session, "71310")

        when 16 
          @titleInfo = People.find_filmography(session, "http://api-public.netflix.com/catalog/people/71310")

            # User


        when 17 
          @titleInfo = User.find(session)

        when 18 
          @titleInfo = User.find_feeds(session)
          
        when 19 
          @titleInfo = User.find_reviews(session,"http://api-public.netflix.com/catalog/titles/movies/60029028")


            # RentalHistory


        when 20 
          @titleInfo = RentalHistory.find(session)

        when 21 
          @titleInfo = RentalHistory.find_shipped(session)

        when 22 
          @titleInfo = RentalHistory.find_returned(session)

        when 23 
          @titleInfo = RentalHistory.find_watched(session)

        when 24 
          @titleInfo = RentalHistory.find_at_home(session)


            # Queue


        when 25 
          @titleInfo = Cue.find(session)

        when 26 
          @titleInfo = Cue.find_defined(session)

        when 27 
         # @titleInfo = Cue.find_defined2(session)
          static_date =  Time.parse("January 1, 1970 00:00:00")
       #  @titleInfo      = Cue.find_defined2(session, 0, 500,"28800","queue_sequence",false)
         @titleInfo      = Cue.find_defined2(session,  0, 500,"28800","queue_sequence",true)


        when 28 
          @titleInfo = Cue.save(session,"http://api-public.netflix.com/catalog/titles/movies/60029028","",50)
          
        when 29 
          @titleInfo = Cue.destroy(session,"60029028")
          
        when 30 
          @titleInfo = Cue.save(session,"http://api-public.netflix.com/catalog/titles/movies/60029028")
          
        when 31 
          @titleInfo = Cue.edit_defined(session,"http://api-public.netflix.com/catalog/titles/movies/60029028","","25")

        when 32 
          @titleInfo = Cue.edit(session,"http://api-public.netflix.com/catalog/titles/movies/60029028","","15")
        
        when 33 
          @titleInfo = Cue.destroy(session,"60000713")

        when 34 
           # @titleInfo = People.find_Data_Url("http://api-public.netflix.com/categories/award_types/golden_globe_awards")

          @titleInfo = Cue.find_titles_states(session,"http://api-public.netflix.com/catalog/titles/movies/70145758,http://api-public.netflix.com/catalog/titles/movies/60029028")
          

            # Rating


        when 35 
          @titleInfo = Rating.find("http://api-public.netflix.com/catalog/titles/movies/60029028", session)

        when 36
          @titleInfo = Rating.find_actual("http://api-public.netflix.com/catalog/titles/movies/60029028", session)

        when 37
          @titleInfo = Rating.find_predicted("http://api-public.netflix.com/catalog/titles/movies/60029028", session)

        when 38
          @titleInfo = Rating.save("http://api-public.netflix.com/catalog/titles/movies/60029028", "4", session)

        when 39
          @titleInfo = Rating.save("http://api-public.netflix.com/catalog/titles/series/60030843/seasons/60030843", "3", session)
        when 40
          @titleInfo = Rating.find("http://api-public.netflix.com/catalog/titles/movies/1005269,http://api-public.netflix.com/catalog/titles/movies/1010877,http://api-public.netflix.com/catalog/titles/movies/1039377,http://api-public.netflix.com/catalog/titles/movies/542276,http://api-public.netflix.com/catalog/titles/movies/543533,http://api-public.netflix.com/catalog/titles/movies/21840788,http://api-public.netflix.com/catalog/titles/movies/620933,http://api-public.netflix.com/catalog/titles/movies/60002728,http://api-public.netflix.com/catalog/titles/movies/60001106,http://api-public.netflix.com/catalog/titles/movies/670874,http://api-public.netflix.com/catalog/titles/movies/60004227,http://api-public.netflix.com/catalog/titles/movies/60000627,http://api-public.netflix.com/catalog/titles/movies/60003142,http://api-public.netflix.com/catalog/titles/movies/60001899,http://api-public.netflix.com/catalog/titles/movies/60001904,http://api-public.netflix.com/catalog/titles/movies/60002595,http://api-public.netflix.com/catalog/titles/movies/60001902,http://api-public.netflix.com/catalog/titles/movies/60001112,http://api-public.netflix.com/catalog/titles/movies/60001473,http://api-public.netflix.com/catalog/titles/movies/671014,http://api-public.netflix.com/catalog/titles/movies/60001506,http://api-public.netflix.com/catalog/titles/movies/60010651,http://api-public.netflix.com/catalog/titles/movies/60011267,http://api-public.netflix.com/catalog/titles/movies/60021928,http://api-public.netflix.com/catalog/titles/movies/60010878,http://api-public.netflix.com/catalog/titles/movies/60032975,http://api-public.netflix.com/catalog/titles/movies/60032979,http://api-public.netflix.com/catalog/titles/movies/60030178,http://api-public.netflix.com/catalog/titles/movies/60010582,http://api-public.netflix.com/catalog/titles/movies/60030302,http://api-public.netflix.com/catalog/titles/series/60030651,http://api-public.netflix.com/catalog/titles/discs/60011207,http://api-public.netflix.com/catalog/titles/discs/60026670,http://api-public.netflix.com/catalog/titles/movies/60023740,http://api-public.netflix.com/catalog/titles/movies/60010268,http://api-public.netflix.com/catalog/titles/movies/60011633,http://api-public.netflix.com/catalog/titles/movies/60010764,http://api-public.netflix.com/catalog/titles/movies/60010464,http://api-public.netflix.com/catalog/titles/movies/60010922,http://api-public.netflix.com/catalog/titles/movies/60032976,http://api-public.netflix.com/catalog/titles/movies/60010794,http://api-public.netflix.com/catalog/titles/movies/60010015,http://api-public.netflix.com/catalog/titles/movies/60011178,http://api-public.netflix.com/catalog/titles/movies/60032947,http://api-public.netflix.com/catalog/titles/movies/60036918,http://api-public.netflix.com/catalog/titles/movies/60010546,http://api-public.netflix.com/catalog/titles/movies/60011430,http://api-public.netflix.com/catalog/titles/movies/60036917,http://api-public.netflix.com/catalog/titles/movies/60026964,http://api-public.netflix.com/catalog/titles/movies/60010166,http://api-public.netflix.com/catalog/titles/movies/60028560,http://api-public.netflix.com/catalog/titles/movies/60031682,http://api-public.netflix.com/catalog/titles/movies/60023782,http://api-public.netflix.com/catalog/titles/movies/60025170,http://api-public.netflix.com/catalog/titles/movies/60029483,http://api-public.netflix.com/catalog/titles/movies/60032238,http://api-public.netflix.com/catalog/titles/movies/60031833,http://api-public.netflix.com/catalog/titles/movies/60020642,http://api-public.netflix.com/catalog/titles/movies/60010585,http://api-public.netflix.com/catalog/titles/movies/60011567,http://api-public.netflix.com/catalog/titles/movies/60010666,http://api-public.netflix.com/catalog/titles/movies/60011465,http://api-public.netflix.com/catalog/titles/movies/60036713,http://api-public.netflix.com/catalog/titles/movies/60024040,http://api-public.netflix.com/catalog/titles/movies/60010413,http://api-public.netflix.com/catalog/titles/movies/60032237,http://api-public.netflix.com/catalog/titles/movies/60011270,http://api-public.netflix.com/catalog/titles/movies/60010783,http://api-public.netflix.com/catalog/titles/movies/60025646,http://api-public.netflix.com/catalog/titles/movies/60010379,http://api-public.netflix.com/catalog/titles/movies/60011364,http://api-public.netflix.com/catalog/titles/movies/60010170,http://api-public.netflix.com/catalog/titles/movies/60031173,http://api-public.netflix.com/catalog/titles/movies/60029662,http://api-public.netflix.com/catalog/titles/movies/60033193,http://api-public.netflix.com/catalog/titles/movies/60023331,http://api-public.netflix.com/catalog/titles/movies/731705,http://api-public.netflix.com/catalog/titles/movies/70005505,http://api-public.netflix.com/catalog/titles/movies/70000542,http://api-public.netflix.com/catalog/titles/movies/70017461,http://api-public.netflix.com/catalog/titles/movies/70000553,http://api-public.netflix.com/catalog/titles/movies/70003265,http://api-public.netflix.com/catalog/titles/movies/70020788,http://api-public.netflix.com/catalog/titles/movies/70000551,http://api-public.netflix.com/catalog/titles/movies/70002643,http://api-public.netflix.com/catalog/titles/movies/70002644,http://api-public.netflix.com/catalog/titles/movies/70002641,http://api-public.netflix.com/catalog/titles/movies/70002639,http://api-public.netflix.com/catalog/titles/movies/70000547,http://api-public.netflix.com/catalog/titles/movies/70007741,http://api-public.netflix.com/catalog/titles/movies/791040,http://api-public.netflix.com/catalog/titles/movies/70000541,http://api-public.netflix.com/catalog/titles/movies/70020513,http://api-public.netflix.com/catalog/titles/movies/70016084,http://api-public.netflix.com/catalog/titles/movies/70020794,http://api-public.netflix.com/catalog/titles/movies/70000550,http://api-public.netflix.com/catalog/titles/movies/305718,http://api-public.netflix.com/catalog/titles/movies/70010825,http://api-public.netflix.com/catalog/titles/movies/70000544,http://api-public.netflix.com/catalog/titles/movies/70002642,http://api-public.netflix.com/catalog/titles/movies/70000543,http://api-public.netflix.com/catalog/titles/movies/304449,http://api-public.netflix.com/catalog/titles/movies/19586121,http://api-public.netflix.com/catalog/titles/movies/777567,http://api-public.netflix.com/catalog/titles/movies/70051900,http://api-public.netflix.com/catalog/titles/movies/70032609,http://api-public.netflix.com/catalog/titles/movies/70044832,http://api-public.netflix.com/catalog/titles/movies/70025302,http://api-public.netflix.com/catalog/titles/movies/70033960,http://api-public.netflix.com/catalog/titles/movies/818041,http://api-public.netflix.com/catalog/titles/movies/70024541,http://api-public.netflix.com/catalog/titles/movies/70033018,http://api-public.netflix.com/catalog/titles/movies/336044,http://api-public.netflix.com/catalog/titles/movies/70035736,http://api-public.netflix.com/catalog/titles/series/70048547,http://api-public.netflix.com/catalog/titles/movies/70050320,http://api-public.netflix.com/catalog/titles/movies/70039488,http://api-public.netflix.com/catalog/titles/movies/70025291,http://api-public.netflix.com/catalog/titles/movies/70032659,http://api-public.netflix.com/catalog/titles/movies/70050681,http://api-public.netflix.com/catalog/titles/movies/70050313,http://api-public.netflix.com/catalog/titles/movies/70050322,http://api-public.netflix.com/catalog/titles/movies/70041565,http://api-public.netflix.com/catalog/titles/movies/70033116,http://api-public.netflix.com/catalog/titles/movies/70030024,http://api-public.netflix.com/catalog/titles/movies/70033104,http://api-public.netflix.com/catalog/titles/movies/70050321,http://api-public.netflix.com/catalog/titles/movies/70024432,http://api-public.netflix.com/catalog/titles/movies/70035178,http://api-public.netflix.com/catalog/titles/movies/804679,http://api-public.netflix.com/catalog/titles/movies/318278,http://api-public.netflix.com/catalog/titles/movies/70040605,http://api-public.netflix.com/catalog/titles/movies/70050323,http://api-public.netflix.com/catalog/titles/movies/70034661,http://api-public.netflix.com/catalog/titles/movies/70035061,http://api-public.netflix.com/catalog/titles/movies/70048908,http://api-public.netflix.com/catalog/titles/movies/70032780,http://api-public.netflix.com/catalog/titles/movies/70037973,http://api-public.netflix.com/catalog/titles/movies/70039594,http://api-public.netflix.com/catalog/titles/movies/70029718,http://api-public.netflix.com/catalog/titles/movies/70026183,http://api-public.netflix.com/catalog/titles/movies/70050319,http://api-public.netflix.com/catalog/titles/movies/70050324,http://api-public.netflix.com/catalog/titles/movies/70070142,http://api-public.netflix.com/catalog/titles/series/70052052,http://api-public.netflix.com/catalog/titles/movies/70063411,http://api-public.netflix.com/catalog/titles/movies/70059226,http://api-public.netflix.com/catalog/titles/movies/70070671,http://api-public.netflix.com/catalog/titles/movies/70067922,http://api-public.netflix.com/catalog/titles/movies/70059222,http://api-public.netflix.com/catalog/titles/series/70057419,http://api-public.netflix.com/catalog/titles/series/70052051,http://api-public.netflix.com/catalog/titles/movies/70071827,http://api-public.netflix.com/catalog/titles/movies/70075847,http://api-public.netflix.com/catalog/titles/movies/70077107,http://api-public.netflix.com/catalog/titles/movies/70078719,http://api-public.netflix.com/catalog/titles/movies/70075678,http://api-public.netflix.com/catalog/titles/movies/70053210,http://api-public.netflix.com/catalog/titles/movies/70071828,http://api-public.netflix.com/catalog/titles/movies/70057420,http://api-public.netflix.com/catalog/titles/movies/70066879,http://api-public.netflix.com/catalog/titles/series/70052050,http://api-public.netflix.com/catalog/titles/movies/70070672,http://api-public.netflix.com/catalog/titles/movies/70075315,http://api-public.netflix.com/catalog/titles/series/70057421,http://api-public.netflix.com/catalog/titles/movies/70075823,http://api-public.netflix.com/catalog/titles/movies/70071829,http://api-public.netflix.com/catalog/titles/movies/70070400,http://api-public.netflix.com/catalog/titles/movies/70071825,http://api-public.netflix.com/catalog/titles/movies/70075314,http://api-public.netflix.com/catalog/titles/movies/70053212,http://api-public.netflix.com/catalog/titles/movies/7775299,http://api-public.netflix.com/catalog/titles/movies/70052202,http://api-public.netflix.com/catalog/titles/movies/70109913,http://api-public.netflix.com/catalog/titles/movies/70109915,http://api-public.netflix.com/catalog/titles/movies/70091559,http://api-public.netflix.com/catalog/titles/movies/70086322,http://api-public.netflix.com/catalog/titles/movies/70086957,http://api-public.netflix.com/catalog/titles/movies/70085112,http://api-public.netflix.com/catalog/titles/movies/70105854,http://api-public.netflix.com/catalog/titles/movies/70093795,http://api-public.netflix.com/catalog/titles/movies/70107365,http://api-public.netflix.com/catalog/titles/movies/70086323,http://api-public.netflix.com/catalog/titles/movies/70109914,http://api-public.netflix.com/catalog/titles/movies/70103421,http://api-public.netflix.com/catalog/titles/movies/374030,http://api-public.netflix.com/catalog/titles/movies/70090405,http://api-public.netflix.com/catalog/titles/movies/70130138,http://api-public.netflix.com/catalog/titles/movies/70132333,http://api-public.netflix.com/catalog/titles/movies/70120641,http://api-public.netflix.com/catalog/titles/movies/70126479,http://api-public.netflix.com/catalog/titles/movies/70129419,http://api-public.netflix.com/catalog/titles/movies/70126481,http://api-public.netflix.com/catalog/titles/movies/70120280,http://api-public.netflix.com/catalog/titles/movies/420109,http://api-public.netflix.com/catalog/titles/movies/70132240,http://api-public.netflix.com/catalog/titles/movies/70135641,http://api-public.netflix.com/catalog/titles/movies/70126480,http://api-public.netflix.com/catalog/titles/movies/70126699,http://api-public.netflix.com/catalog/titles/movies/70129416,http://api-public.netflix.com/catalog/titles/movies/70129418,http://api-public.netflix.com/catalog/titles/movies/70121619,http://api-public.netflix.com/catalog/titles/movies/70122383,http://api-public.netflix.com/catalog/titles/movies/70132309,http://api-public.netflix.com/catalog/titles/movies/70132307,http://api-public.netflix.com/catalog/titles/movies/70114055,http://api-public.netflix.com/catalog/titles/movies/70132241,http://api-public.netflix.com/catalog/titles/movies/70122379,http://api-public.netflix.com/catalog/titles/movies/988884", session)
    
        when 41
          @titleInfo = Rating.find("http://api-public.netflix.com/catalog/titles/movies/1005269,http://api-public.netflix.com/catalog/titles/movies/1010877,http://api-public.netflix.com/catalog/titles/movies/1039377,http://api-public.netflix.com/catalog/titles/movies/542276,http://api-public.netflix.com/catalog/titles/movies/543533,http://api-public.netflix.com/catalog/titles/movies/21840788,http://api-public.netflix.com/catalog/titles/movies/620933,http://api-public.netflix.com/catalog/titles/movies/60002728,http://api-public.netflix.com/catalog/titles/movies/60001106,http://api-public.netflix.com/catalog/titles/movies/670874,http://api-public.netflix.com/catalog/titles/movies/60004227,http://api-public.netflix.com/catalog/titles/movies/60000627,http://api-public.netflix.com/catalog/titles/movies/60003142,http://api-public.netflix.com/catalog/titles/movies/60001899,http://api-public.netflix.com/catalog/titles/movies/60001904,http://api-public.netflix.com/catalog/titles/movies/60002595,http://api-public.netflix.com/catalog/titles/movies/60001902,http://api-public.netflix.com/catalog/titles/movies/60001112,http://api-public.netflix.com/catalog/titles/movies/60001473,http://api-public.netflix.com/catalog/titles/movies/671014,http://api-public.netflix.com/catalog/titles/movies/60001506,http://api-public.netflix.com/catalog/titles/movies/60010651,http://api-public.netflix.com/catalog/titles/movies/60011267,http://api-public.netflix.com/catalog/titles/movies/60021928,http://api-public.netflix.com/catalog/titles/movies/60010878,http://api-public.netflix.com/catalog/titles/movies/60032975,http://api-public.netflix.com/catalog/titles/movies/60032979,http://api-public.netflix.com/catalog/titles/movies/60030178,http://api-public.netflix.com/catalog/titles/movies/60010582,http://api-public.netflix.com/catalog/titles/movies/60030302,http://api-public.netflix.com/catalog/titles/series/60030651,http://api-public.netflix.com/catalog/titles/discs/60011207,http://api-public.netflix.com/catalog/titles/discs/60026670,http://api-public.netflix.com/catalog/titles/movies/60023740,http://api-public.netflix.com/catalog/titles/movies/60010268,http://api-public.netflix.com/catalog/titles/movies/60011633,http://api-public.netflix.com/catalog/titles/movies/60010764,http://api-public.netflix.com/catalog/titles/movies/60010464,http://api-public.netflix.com/catalog/titles/movies/60010922,http://api-public.netflix.com/catalog/titles/movies/60032976,http://api-public.netflix.com/catalog/titles/movies/60010794,http://api-public.netflix.com/catalog/titles/movies/60010015,http://api-public.netflix.com/catalog/titles/movies/60011178,http://api-public.netflix.com/catalog/titles/movies/60032947,http://api-public.netflix.com/catalog/titles/movies/60036918,http://api-public.netflix.com/catalog/titles/movies/60010546,http://api-public.netflix.com/catalog/titles/movies/60011430,http://api-public.netflix.com/catalog/titles/movies/60036917,http://api-public.netflix.com/catalog/titles/movies/60026964,http://api-public.netflix.com/catalog/titles/movies/60010166,http://api-public.netflix.com/catalog/titles/movies/60028560,http://api-public.netflix.com/catalog/titles/movies/60031682,http://api-public.netflix.com/catalog/titles/movies/60023782,http://api-public.netflix.com/catalog/titles/movies/60025170,http://api-public.netflix.com/catalog/titles/movies/60029483,http://api-public.netflix.com/catalog/titles/movies/60032238,http://api-public.netflix.com/catalog/titles/movies/60031833,http://api-public.netflix.com/catalog/titles/movies/60020642,http://api-public.netflix.com/catalog/titles/movies/60010585,http://api-public.netflix.com/catalog/titles/movies/60011567,http://api-public.netflix.com/catalog/titles/movies/60010666,http://api-public.netflix.com/catalog/titles/movies/60011465,http://api-public.netflix.com/catalog/titles/movies/60036713,http://api-public.netflix.com/catalog/titles/movies/60024040,http://api-public.netflix.com/catalog/titles/movies/60010413,http://api-public.netflix.com/catalog/titles/movies/60032237,http://api-public.netflix.com/catalog/titles/movies/60011270,http://api-public.netflix.com/catalog/titles/movies/60010783,http://api-public.netflix.com/catalog/titles/movies/60025646,http://api-public.netflix.com/catalog/titles/movies/60010379,http://api-public.netflix.com/catalog/titles/movies/60011364,http://api-public.netflix.com/catalog/titles/movies/60010170,http://api-public.netflix.com/catalog/titles/movies/60031173,http://api-public.netflix.com/catalog/titles/movies/60029662,http://api-public.netflix.com/catalog/titles/movies/60033193,http://api-public.netflix.com/catalog/titles/movies/60023331,http://api-public.netflix.com/catalog/titles/movies/731705,http://api-public.netflix.com/catalog/titles/movies/70005505,http://api-public.netflix.com/catalog/titles/movies/70000542,http://api-public.netflix.com/catalog/titles/movies/70017461", session)
       when 42
          @titleInfo = Rating.find("http://api-public.netflix.com/catalog/titles/movies/1005269,http://api-public.netflix.com/catalog/titles/movies/1010877,http://api-public.netflix.com/catalog/titles/movies/1039377,http://api-public.netflix.com/catalog/titles/movies/542276,http://api-public.netflix.com/catalog/titles/movies/543533,http://api-public.netflix.com/catalog/titles/movies/21840788,http://api-public.netflix.com/catalog/titles/movies/620933,http://api-public.netflix.com/catalog/titles/movies/60002728,http://api-public.netflix.com/catalog/titles/movies/60001106,http://api-public.netflix.com/catalog/titles/movies/670874,http://api-public.netflix.com/catalog/titles/movies/60004227,http://api-public.netflix.com/catalog/titles/movies/60000627,http://api-public.netflix.com/catalog/titles/movies/60003142,http://api-public.netflix.com/catalog/titles/movies/60001899,http://api-public.netflix.com/catalog/titles/movies/60001904,http://api-public.netflix.com/catalog/titles/movies/60002595,http://api-public.netflix.com/catalog/titles/movies/60001902,http://api-public.netflix.com/catalog/titles/movies/60001112,http://api-public.netflix.com/catalog/titles/movies/60001473,http://api-public.netflix.com/catalog/titles/movies/671014,http://api-public.netflix.com/catalog/titles/movies/60001506,http://api-public.netflix.com/catalog/titles/movies/60010651,http://api-public.netflix.com/catalog/titles/movies/60011267,http://api-public.netflix.com/catalog/titles/movies/60021928,http://api-public.netflix.com/catalog/titles/movies/60010878,http://api-public.netflix.com/catalog/titles/movies/60032975,http://api-public.netflix.com/catalog/titles/movies/60032979,http://api-public.netflix.com/catalog/titles/movies/60030178,http://api-public.netflix.com/catalog/titles/movies/60010582,http://api-public.netflix.com/catalog/titles/movies/60030302,http://api-public.netflix.com/catalog/titles/series/60030651,http://api-public.netflix.com/catalog/titles/discs/60011207,http://api-public.netflix.com/catalog/titles/discs/60026670,http://api-public.netflix.com/catalog/titles/movies/60023740,http://api-public.netflix.com/catalog/titles/movies/60010268,http://api-public.netflix.com/catalog/titles/movies/60011633,http://api-public.netflix.com/catalog/titles/movies/60010764,http://api-public.netflix.com/catalog/titles/movies/60010464,http://api-public.netflix.com/catalog/titles/movies/60010922,http://api-public.netflix.com/catalog/titles/movies/60032976,http://api-public.netflix.com/catalog/titles/movies/60010794,http://api-public.netflix.com/catalog/titles/movies/60010015,http://api-public.netflix.com/catalog/titles/movies/60011178,http://api-public.netflix.com/catalog/titles/movies/60032947,http://api-public.netflix.com/catalog/titles/movies/60036918,http://api-public.netflix.com/catalog/titles/movies/60010546,http://api-public.netflix.com/catalog/titles/movies/60011430,http://api-public.netflix.com/catalog/titles/movies/60036917,http://api-public.netflix.com/catalog/titles/movies/60026964,http://api-public.netflix.com/catalog/titles/movies/60010166,http://api-public.netflix.com/catalog/titles/movies/60028560,http://api-public.netflix.com/catalog/titles/movies/60031682,http://api-public.netflix.com/catalog/titles/movies/60023782,http://api-public.netflix.com/catalog/titles/movies/60025170,http://api-public.netflix.com/catalog/titles/movies/60029483,http://api-public.netflix.com/catalog/titles/movies/60032238,http://api-public.netflix.com/catalog/titles/movies/60031833,http://api-public.netflix.com/catalog/titles/movies/60020642,http://api-public.netflix.com/catalog/titles/movies/60010585,http://api-public.netflix.com/catalog/titles/movies/60011567,http://api-public.netflix.com/catalog/titles/movies/60010666,http://api-public.netflix.com/catalog/titles/movies/60011465,http://api-public.netflix.com/catalog/titles/movies/60036713,http://api-public.netflix.com/catalog/titles/movies/60024040,http://api-public.netflix.com/catalog/titles/movies/60010413,http://api-public.netflix.com/catalog/titles/movies/60032237,http://api-public.netflix.com/catalog/titles/movies/60011270,http://api-public.netflix.com/catalog/titles/movies/60010783,http://api-public.netflix.com/catalog/titles/movies/60025646,http://api-public.netflix.com/catalog/titles/movies/60010379,http://api-public.netflix.com/catalog/titles/movies/60011364,http://api-public.netflix.com/catalog/titles/movies/60010170,http://api-public.netflix.com/catalog/titles/movies/60031173,http://api-public.netflix.com/catalog/titles/movies/60029662,http://api-public.netflix.com/catalog/titles/movies/60033193,http://api-public.netflix.com/catalog/titles/movies/60023331,http://api-public.netflix.com/catalog/titles/movies/731705,http://api-public.netflix.com/catalog/titles/movies/70005505,http://api-public.netflix.com/catalog/titles/movies/70000542", session)
       when 43
          @titleInfo = Rating.find("http://api-public.netflix.com/catalog/titles/movies/1005269", session)
       
       when 44 
         @titleInfo = Cue.save(session,"http://api-public.netflix.com/catalog/titles/movies/60029028","","",true)
         
       when 45 
         @titleInfo = Cue.edit(session,"http://api-public.netflix.com/catalog/titles/movies/60029028","","25",true)

       when 46 
         @titleInfo = Cue.edit(session,"http://api-public.netflix.com/catalog/titles/movies/60029028","","15",true)
       
       when 47 
          @titleInfo = Cue.destroy(session,"60029028",true)
          
       when 48 
          @titleInfo = Title.find_box_art(session, "http://api-public.netflix.com/catalog/titles/movies/60029028")
          

   end
      
     
     # writeStringToFlie(RAILS_ROOT + '/netflixApiMigratationColumnDefinations/' , 
     #                   getCurrentFileName(id), 'a', 
     #                   getcurrentColumnDefinations(@titleInfo))
    #  writeStringToFlie(RAILS_ROOT + '/yml_return_data/' , getCurrentFileName(id), 'a', @titleInfo.to_yaml)
      
      x = "debugger line"
   end
   
   
   def getcurrentColumnDefinations(apiObj)
        str =""
        if apiObj 
          classType =  (apiObj.class.to_s)  

          case classType 
            when "ActiveDummySet"
              obj = apiObj.set
              str += getMigratationColumnDefinations(apiObj.details)
            else
              obj = apiObj
          end

          classType =  (obj.class.to_s)  

          case classType 
          when "ActiveDummy"
            str += getMigratationColumnDefinations(obj)
          when "Hash" 
            obj.each{|key,value|
              str += getMigratationColumnDefinations(value)
            }
          when "Array" 
            obj.each{|value|
              str += getMigratationColumnDefinations(value)
            }
          when "String" 
            str = obj
          end
        end 
     return str
   end   
     
   
   
   def getMigratationColumnDefinations(obj)
     str = "\n\n"
     if obj
        if obj.class.to_s == "ActiveDummy"
          obj.attributes.each{|key,value|
           #str += "t.column :"+ key +", :"+ value.class.to_s +"\n"
            valueclass = value.class
            str += "t.column :#{key}, :#{valueclass}\n"
          }
       end 
     end
     return str + "\n\n"
   end
   
   def getCurrentFileName(id)

     # filenames =  %w( 1_Title_find_by_name.yml 2_Title_find_by_name.yml 3_Title_find.yml 4_Title_find_similars.yml 5_Title_find_cast.yml 6_Title_find_directors.yml 7_Title_find_format_availability.yml 8_Title_find_awards.yml 9_Title_find_screen_formats.yml 10_Title_find_languages_and_audio.yml 11_Title_find_synopsis.yml 12_People_find_by_name.yml 13_People_find.yml 14_People_find_filmography.yml 15 16_User_find.yml 17_User_find_feeds.yml 18_RentalHistory_find.yml 19_RentalHistory_find_shipped.yml 20_RentalHistory_find_returned.yml 21_RentalHistory_find_watched.yml 22_RentalHistory_find_at_home.yml 23_Cue_find.yml 24_Cue_find_defined.yml 25_Cue_find_defined2.yml 26_Cue_save.yml 27_Cue_destroy.yml 28_Cue_save.yml 29_Cue_edit_defined.yml 30_Cue_edit.yml 31_Cue_destroy.yml 32_Rating_find.yml 33_Rating_find_actual.yml 34_Rating_find_predicted.yml 35_Rating_save.yml 36_Rating_save.yml)
     # name = filenames[id - 1]
     # id = -1
     name = nil
     ext = ".yml"
     case id
       when 1..12
           name = 'title' + ext
       when 12..16
           name = 'People' + ext
       when 17..18
           name = 'User' + ext
       when 20..24
           name = 'RentalHistory' + ext
       when 25..33
           name = 'Cue' + ext
       when 34..43
           name = 'Rating' + ext
       when 44..47
           name = 'Cue' + ext
     end 
     return name
   end 
   
      def writeCache
       Rails.cache.write("something",1)
      end 
      
      def readCache
        i = Rails.cache.read("something")
       render :text => i.to_s
      end 
      
      def index
       
       runApiCalls
      end 
      
      def readSymbols
        tmp_path   = File::join Rails.root, "tmp/symbols.txt"
        a = []
        File.open( tmp_path,'r') do |file|
         a << file.readline()
        end
   
        a.each{|i| i.to_sym}
   
   
      end
   
      
      def testSymbols
         tmp_path   = File::join Rails.root, "tmp/symbols.txt"
         File.open( tmp_path,'w'){|file|
             file.write(Symbol.all_symbols.to_json) 
           }
         render :nothing  => true
      end 
      
   

end
