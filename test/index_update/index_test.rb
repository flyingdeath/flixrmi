ENV["RAILS_ENV"] = "production"
#require 'RubyGems'
  
require File.expand_path('../../../config/environment', __FILE__)
$LOAD_PATH << File.dirname(__FILE__) + "/../"
$LOAD_PATH << File.dirname(__FILE__) + "/../lib/"

require "ApiFixtures"
require "NetflixObjectTestHelper"
require 'sys/proctable'


class IndexTest 

  include Sys
  include ApiFixtures
  include NetflixObjectTestHelper

  def setup
    getFixtures :users
    getSymbolizedFixtures :session
  end
  
  def teardown
    @users = nil
    @session = nil
  end 
  
  def isProcessRunning(name,max)
    ret = false
  i = 0 
    ProcTable.ps{ |process|
      if process.cmdline
        if process.cmdline.index(name) 
      if i >= max
            ret = true
      end
      i += 1
        end
      end
    }
    return ret
  end 
  

  def run 
    if !isProcessRunning("index_test.rb",2)
      #generes = Genre.find(@session['session'])
      ret = Index.find(@session['session'])
          Logger.new(STDOUT).info ret.to_s
      if ret
        Index.parse()
      end
    end
  end 
end



  iObj = IndexTest.new 
  iObj.setup
  iObj.run
  iObj.teardown
  