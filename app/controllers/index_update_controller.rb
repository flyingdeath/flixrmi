
require "modelParsers"

class IndexUpdateController < ApplicationController
  before_filter :authorize
  
  def index
  end 
  
  def add_customGenres()
    sets = getCustomGenres()

    sets.each { |genre|
      node = Lgenre.new({:name =>  genre })
      node.save
    }
  end 
   
 
 def build_Genretree()
  sets = getGenreTree()
  sets.each{|newSet|
    curParent = newSet[0]
    newSet[1].each{|child|
      node = Genrestree.new({:parent_id =>  curParent, :child_id => child })
      node.save
    }
  }
 end 
 
 def updateavailability
   list = Fconnector.all
   list.each{|f|
    if f.availability
      f.availability   = Time.parse("January 1, 1970 00:00:00") + f.availability_int
      f.save
    end
   }
 end
 
 
  def resetKnownformats()
    dvd       = Lformat.new({:name => "DVD"}) 
    blueRay   = Lformat.new({:name => "Blu-ray"}) 
    instant   = Lformat.new({:name => "instant"}) 
    
    dvd.save
    blueRay.save
    instant.save
  end 
  
  def updateGenres
      generes = Genre.find(session)
      parser = IndexParser.new(0)
      parser.updateXmlSet(generes['category_scheme']['category_item'],'term',Lgenre)
      return  parser.pushDataToHash(Lgenre, 'name')
  end 
  
  
  def receiveData
    Index.find(session)
    render :nothing => true
  end
  
  def parseData
    Index.parse()
    render :nothing => true
  end 
  
  def receiveData
    Index.find(session)
    render :nothing => true
  end
  
  def receiveParseData
    Index.find(session)
    Index.parse()
    render :nothing => true
  end 
  
  
  def getCustomGenres()
    return ["Main_Menu",
            "Political",
            "Art",
            "War",
            "Musicals",
            "Music",
            "Sports Instruction",
            "Movie Release Co.",
            "Foreign countries",
            "Foreign Language "]
        
 end 
  #-------------------------------------------------------------------------------------------------#
  #-------------------------------------------------------------------------------------------------#
 def getTempGenreTree()
  return  [
          [127,[47,52,288,480,513]],
          [104,[14,54,85,94,122,131,292,363,389,407,413,420,433,435,439,483]],
          [487,[94,95,96,287,298,334,335,396,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476]],
        [138,[15,55,119,132,225,234,312,316,321,350,364,379,386,395,406,425,436,496]],
        ]
 end
 
 def getGenreTree()
   return [
        [519,[522,520,521,5,28,59,60,83,103,104,138,139,151,173,178,242,249,328,329,331,336,387,398,431,434,449,487,494,509]],
        [5,  [10,6,7,8,9,13,58,106,118,153,231,310,444]],
        [387,[17,388,389,390,440,485]],
        [520,[363,364,365,366]],
        [249,[251,252,253,254,255,256,257,258]],
        [521,[39,127,156,178,180,249,345,353,357,408,411,416,492,493]],
        [328,[526,136,247,315]],
        [103,[6,65,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,167,184,243,252,388,401,455]],
        [238,[150,206,239]],
        [494,[9,97,121,152,154,173,199,231,336,366,373,404,432,447,449]],
        [522,[98,310,311,312]],
        [329,[523,524]],
        [523,[89,93,111,113,191,333,345]],
        [139,[16,31,56,72,87,95,107,116,120,140,141,142,143,144,169,183,187,205,210,255,259,263,293,306,311,320,335,354,365,370,390,395,402,411,414,426,437,457,458,460,462,463,473,481,484,497]],
        [434,[525,43,46,48,49,62,66,124,158,159,160,161,174,177,212,217,244,246,248,276,284,296,302,304,319,325,326,327,344,346,347,348,20,418,419,422,423,424,435,436,437,438,442,448,489,507,511,516]],
        [525,[4,50,63,78,129,213,303,409,441,512,517]],
        [526,[73,201,295,352,427,499,506]],
        [466,[2,3,45,67,74,75,80,105,135,137,200,224,225,236,297,337,338,342,349,400,415,452]],
        [178,[528,527,40,41,54,70,71,72,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199]],
        [527,[11,38,42,51,68,84,126,147,202,216,220,241,250,265,266,269,270,274,282,289,308,309,339,356,361,391,397,428,429,491,498]],
        [398,[24,35,92,96,171,170,195,399,400,401,402,403,404,445,446,447]],
        [83, [19,20,21,22,23,26,81,106,108,165,166,167,168,169,170,264,277,278,279,280,281,342]],
        [28, [1112,24,810,29,30,31,32,33,34,35,36,81,106,108,277]],
        [528,[37,53,76,125,130,146,172,204,215,221,223,230,232,245,268,271,283,300,301,343,362,368,374,392,410,430,450,477,479,488,490,502]],
        [431,[77,79,109,127,133,355,145,148,149,162,175,214,228,229,235,237,238,240,286,299,305,307,313,314,317,318,330,351,355,358,359,360,371,372,405,443,478,482,505]],
        [162,[162,163,164,369,379,380,381,382]],
        [175,[114,176,510]],
        [242,[40,44,117,123,203,243,267,323,403,421,445,486,501,508,518]],
        [127,[47,52,288,480,513]],
        [104,[14,54,85,94,122,131,292,363,389,407,413,420,433,435,439,483]],
        [487,[94,95,96,287,298,334,335,396,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476]],
        [138,[15,55,119,132,225,234,312,316,321,350,364,379,386,395,406,425,436,496]],
        [208,[57,207,209,210,211,285,294]],
        [524,[18,12,25,61,69,82,86,88,90,91,100,101,102,110,112,115,128,134,155,218,219,222,226,227,233,260,261,262,272,273,275,290,291,322,332,340,341,367,375,376,377,378,383,384,385,393,394,412,417,451,495,500,503,504,514,515]]
        ]
 end 
   
end
  #-------------------------------------------------------------------------------------------------#
  #-------------------------------------------------------------------------------------------------#

