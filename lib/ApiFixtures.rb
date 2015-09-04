require "YAMLConverter"

module ApiFixtures

  
  def getFixtures(*names)
    names.each{|file|
      temp = apiFixture file
      if temp.data
       eval("@#{file} = temp.data.clone")
      end 
    }
  end 
  
  def getSymbolizedFixtures(*names)
    names.each{|file|
      temp = symbolHash file
      if temp.data
        eval("@#{file} = temp.data.clone")
      end 
    }
  end 
  
  def getStringFixtures(*names)
    names.each{|file|
      temp = stringHash file
      if temp.data
        eval("@#{file} = temp.data.clone")
      end 
    }
  end 
  
  def getIndifferentFixtures(*names)
    names.each{|file|
      temp = indifferent file
      if temp.data
        eval("@#{file} = temp.data.clone")
      end 
    }
  end 
  
  def symbolHash(name)
    path = File.dirname(__FILE__) +  "/../test/api_fixtures/" 
    temp =  YAMLConverter.new("#{path}#{name}.yml","SymbolizedHash")
    return temp
  end
  
  def stringHash(name)
    path = File.dirname(__FILE__) +  "/../test/api_fixtures/" 
    temp =  YAMLConverter.new("#{path}#{name}.yml","StringHash")
    return temp
  end
  
  def indifferent(name)
    path = File.dirname(__FILE__) +  "/../test/api_fixtures/" 
    temp =  YAMLConverter.new("#{path}#{name}.yml","none")
    return temp
  end
  
  
  
  def apiFixture(name)
    path = File.dirname(__FILE__) +  "/../test/api_fixtures/" 
    temp =  YAMLConverter.new("#{path}#{name}.yml","ActiveDummy")
    return temp
  end
  
end 
