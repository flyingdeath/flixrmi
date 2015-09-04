
require "modelParsers"
require "ActiveNetflix"

class Cue  < ActiveNetflix

  def self.find(session, start = 0, max = 100, givenDate = "",sortOrder = "")
    return getData(CueResourceParser.new(0), :get_queues, "Single", {:start_index => start,     :max_results => max,
                                             :updated_min => givenDate, :sort        => sortOrder }, session)
  end
  
  def self.find_defined(session, instantQ = false, start = 0, max = 100, givenDate = "", 
                        sortOrder = "")
    params    = {:start_index => start,     :max_results => max,
                 :updated_min => givenDate, :sort =>        sortOrder }
     currentSymbol = instantQ ? :get_instant_q : :get_disc_q;
    return getFullData(CueListParser, currentSymbol, "Data",  params,0, session)
  end
  
  def self.find_defined2(session, start = 0, max = 100, givenDate = "", 
                          sortOrder = "", instantQ = false, saved = false)
    params    = {:start_index => start,     :max_results => max,
                 :updated_min => givenDate, :sort =>        sortOrder }
    if instantQ
      currentSymbol =  saved ? :get_instant_saved_q : :get_instant_available_q;
    else
      currentSymbol =  saved ? :get_disc_saved_q : :get_disc_available_q;
    end
    data = getFullData(CueListParser, currentSymbol, "Data", params,0, session)
    if !saved
      data.set = self.positionSort(data.set)
    end
    return data
  end
  
   def self.positionSort(l)
    i = 0
    ret =  l.collect {|id| 
                i += 1 
                l.detect {|x| (x.attributes["position"] == i.to_s)}    
              }.compact
    dif = l - ret
    return ret.concat(dif)
              
   end
  
  def self.find_titles_states(session,urlRefs)
    connector = NetflixApiConnector.new(session)
    return find_title_refs(urlRefs, :titles_states, TitleStatesParser, 0, session)
  end
  
  def self.save(session, id , format = "", position = "", instantQ = false)
    params        = {:title_ref => id, :format => format, :position => position}
    currentSymbol = instantQ ? :add_instant_q : :add_disc_q;
    return getData(CueListParser.new(""), currentSymbol, "Data", params, session)
  end
  
  def self.edit(session, urlRef , format = "", position ="", instantQ = false)
    params        = {:title_ref => urlRef, :format => format, :position => position}
    currentSymbol = instantQ ? :edit_instant_q : :edit_disc_q;
    return getData(CueListParser.new(0), currentSymbol, "Data", params, session)
  end
  
  def self.edit_defined(session, id, format = "", position = "", 
                        instantQ = false, saved = false)
    params    = {:title_ref => id, :format => format, :position => position}
    if instantQ
      currentSymbol = saved ? :edit_instant_saved_q : :edit_instant_available_q;
    else
      currentSymbol = saved ? :edit_disc_saved_q : :edit_disc_available_q;
    end
    return getData(CueListParser.new(0), currentSymbol, "Data", params, session)
  end
  
  def self.destroy(session, id, instantQ = false , saved = false)
    params    = {:title_id => id}
    if instantQ
      currentSymbol = saved ? :delete_instant_saved_q : :delete_instant_available_q;
    else
      currentSymbol = saved ? :delete_disc_saved_q : :delete_disc_available_q;
    end
    return getData(CueStatusParser.new(0), currentSymbol, "Data", params, session)
  end
  
  
  
  
end
