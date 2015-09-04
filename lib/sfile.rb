class Sfile
  @path = ""
  @cache_file = ""
 
  def initialize(varName)
    @path  =    File::join Rails.root, "tmp/cache/"
    @cache_file =  @path + varName + ".cacheflie"
  end

  def read()
    return lockRead(@cache_file)
  end 
  
  def write(text)
    lockwrite(@cache_file, text)
  end 

  def lockwrite(path, text)
    # We need to check the file exists before we lock it.
    begin
        File.open(path, File::RDWR|File::CREAT) {|f|
          f.flock(File::LOCK_EX)
          f.write(text)
          f.flock(File::LOCK_UN)
        }
    rescue
      Logger.new(STDOUT).info 'retry = '+ path
      retry
    end
  end

  def lockRead(path)
    # We need to check the file exists before we lock it
    ret = nil
    begin
      if File.exist?(path)
        File.open(path, File::RDWR|File::CREAT) {|f|
          f.flock(File::LOCK_EX)
          ret = f.read()
          f.flock(File::LOCK_UN)
        }
      end
    rescue
      Logger.new(STDOUT).info 'retry = '+ path
      retry
    end


    return ret
  end


end

