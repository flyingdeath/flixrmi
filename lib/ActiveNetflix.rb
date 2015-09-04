
 require "netflix_api_connector"
 
class ActiveNetflix

  
  def self.getData(parser, api_method, dataType, params, session)
    connector = NetflixApiConnector.new(session)
    xmlData   =  connector.getNetflixData(api_method,  params,false)
    MainNetFlixParser.new(xmlData,parser)
    case dataType
     when "Data"
    return parser.getParsedData()
     when "Set"
    return parser.getParsedSet()
     when "Single"
    return parser.getParsedSingle()
     when "Attributes"
    return parser.getSetAttributes()
     when "Json"
    return parser.getParsedSetJson()
    end
  end
  
  def self.find_title_refs(urlRefs ,apimethod, parser, parserParam, session)
    count = 4
    connector = NetflixApiConnector.new(session)
    refs = connector.sliptN(urlRefs,",",500)
    if refs.count <= 1 and refs.count > count
      refs = connector.sliptN(urlRefs,",",urlRefs.split(',').length/(count -1))
    end
    
    threads = []
    ret = {}
    i  = 1
    refs.each{|ref|
      if (i % (count + 1)) == 0 and i != 0 
        sleep(1)
        Logger.new(STDOUT).info 'sleep a ' + i.to_s + Time.now.to_s(:db)
      end 
      sleep(0.25)
      threads << Thread.new(parser.new(parserParam)){|p|
        MainNetFlixParser.new(NetflixApiConnector.new(session).getNetflixData(apimethod, {:title_refs => ref }, false)[0], p)
        ret = ret.merge(p.getParsedSet())
      }
      i += 1
    }
    threads.each{|t|
      t.join
    }
    return ret
  end
  
  
  def self.parseData(dataSet, parser,parserParam)
    ret = {}
    threads = []
    dataSet.each{|item|
      threads << Thread.new(parser.new(parserParam)){|p|
        MainNetFlixParser.new(item,p)
        data = parser.getParsedSet()
        ret = ret.merge(data)
      }
    }
    threads.each{|t|
      t.join
    }
    parser = nil
    
    return ret
  end 
  
  def self.getFullData(parser, api_method, dataType, params, parserParam,  session)
    connector = NetflixApiConnector.new(session)
    parserObj = parser.new(parserParam)
    par = params.clone
    par[:max_results] = 1
    MainNetFlixParser.new(connector.getNetflixData(api_method, par,false), parserObj)
    ret = parserObj.getParsedData()
    n = ret.details.attributes['number_of_results'].to_i
    m = params[:max_results].to_i
    if n > m
     t = ((n.to_f/m.to_f).ceil) -1
    elsif n > 4
      t = 3
      m = (n.to_f/4.0).ceil
      params[:max_results] = m.to_s
    else
      t = 1
    end 
    ret.set = []
    threads = []
    count = 4
    
    (0..t).each {|i|
      if ((i+1) % (count + 1)) == 0 and i != 0 
        sleep(1)
        Logger.new(STDOUT).info 'sleep d ' + i.to_s + Time.now.to_s(:db)
      end 
      sleep(0.25)
      threads << Thread.new(parser.new(parserParam),params.clone){|p,params|
        p = parser.new(parserParam)
        params[:start_index] = m*i 
        xml = NetflixApiConnector.new(session).getNetflixData(api_method, params,false)
        
        MainNetFlixParser.new(xml, p)
        ret.set.concat(p.getParsedSet())
      }
   
    }   
      threads.each{|t|
        t.join
      } 
      
    
    return ret
  end

end
