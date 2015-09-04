module NetflixObjectTestHelper

  def checkFristOccurrence(aObj,bObj)
    valueType = bObj.class.to_s
   ret = true
    case valueType
      when "Array"
        if bObj[0].eql?(aObj)
          ret = false
        end 
      else
        ret = false
    end
    return ret
  end 
  
  def checkAutoCompleteJsonResponse(aStr, bStr)
    h1 = ActiveResource::Formats::JsonFormat.decode(aStr)
    h2 = ActiveResource::Formats::JsonFormat.decode(bStr)
    h1_key1  = h1.keys[0]
    h1_key2  = h1[h1_key1].keys[0]
    h1_key3  = h1[h1_key1][h1_key2][0].keys[0]
    h1_value = h1[h1_key1][h1_key2][0][h1_key3]
    ret = false
    if h2[h1_key1] 
      if h2[h1_key1][h1_key2] 
        if h2[h1_key1][h1_key2].class == Array
          ret = (h2[h1_key1][h1_key2].index{|x| 
                                             if x[h1_key3] 
                                               x[h1_key3] == h1_value
                                             end 
                                           })
        end
      end
    end
    return ret
  end 
  
  def checkSets(aObj,bObj, partial = false)
    ret = true
    valueType = ""
    aObj.attributes.each{|key,value|
      if key
        valueType = value.class.to_s
        case valueType
          when "Array"
            if bObj.attributes[key]
              for x in 0..(value.length-1)
                if partial
                   ret = bObj.attributes[key].index{|aVal| 
                           (aVal.index(value[x]))
                         }
                 else
                   ret = (bObj.attributes[key].index(value[x]))
                end 
                if !(ret)
                  break
                end
              end 
            else
              ret = false
            end 
          else
            if partial
              ret = (bObj.attributes[key].index(value))
            else
             ret = (bObj.attributes[key] == value) 
            end
        end  
        if !(ret)
          break
        end
      end 
    }
    return ret
  end
 
  def checkArraySet(aList,bList)
    ret = true
    for x in 0..(aList.length-1)
      ret = checkSets(aList[x],bList[x])
      if !ret
        break
      end 
    end 
    return ret
  end
 
  def checkHashSet(aList,bList)
    ret = true
    aList.each{|key,value|
      ret = checkSets(value,bList[key])
      if !ret
        break
      end 
    } 
    return ret
  end
  
  def checkAttributes(aObj,bObj)
    ret = true
    valueType = ""
    aObj.attributes.each{|key,value|
      if key
        if !(bObj.attributes[key])
          ret = false
          break
        end 
      end 
    }
    return ret
  end
  
  def checkArrayAttributes(aList,bList)
    return checkAttributes(aList,bList[0])
  end
  
  
  
  def isDataSet(obj)
    ret = true
    if !(obj.details)
      ret = false
    end
    
    if !(obj.set)
      ret = false
    end 
    return ret
  end 
  
  def isArraySet(obj)
    ret = true
    valueType = obj.class.to_s
    
    if !(valueType == "Array")
      ret = false
    end
    return ret
  end 
  
  def isHashSet(obj)
    ret = true
    valueType = obj.class.to_s
    
    if !(valueType == "Hash")
      ret = false
    end
    return ret
  end 
  
  
  
  
  
end

