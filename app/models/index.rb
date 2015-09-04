require "netflix_api_connector"
require "modelParsers"
require "ActiveNetflix"

class Index 

  def self.find(session)
    begin
      threads = []
      ret = ""
      threads << Thread.new(){
        tmp_path =    File::join Rails.root, "tmp/cache/"
        index_file =  tmp_path + "index.xml"
        connector = NetflixApiConnector.new(session)
        Logger.new(STDOUT).info Time.now.to_s(:short) + ' download initi' 
        ret = connector.getNetflixData(:get_full_index,{:writeToFile => index_file })
      }
      threads.each{|t|
        t.join
      }
      return ret 
    rescue  Exception => e
      Logger.new(STDOUT).info Time.now.to_s(:short) + "\n"+ e.message + "\n" +  e.backtrace.join("\n")
    #  File.delete(index_file)
      return nil
    end
    
  end  
  
  def self.parse()
    threads = []
    threads << Thread.new(){
      begin
        parser     = IndexParser.new(Ltitle.count)
        parser.updateGlobalVars(parser.pushDataToHash(Lgenre, 'name'),  
                    parser.pushDataToHash(Lformat, 'name')) 
        tmp_path   = File::join Rails.root, "tmp/cache/"
        index_file = tmp_path + "index.xml"
        if File.exist?(index_file)
          Logger.new(STDOUT).info Time.now.to_s(:short) + ' parse initi' 
          IndexFlieNetFlixParser.new(index_file,parser)
          File.delete(index_file)
        end
      rescue  Exception => e
        Logger.new(STDOUT).info Time.now.to_s(:short) + "\n"+ e.message + "\n" +  e.backtrace.join("\n")

     #   File.delete(index_file)
      end
    }
    threads.each{|t|
      t.join
    }
  end
  
  
end
