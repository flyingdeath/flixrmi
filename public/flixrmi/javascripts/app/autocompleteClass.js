  function autoCompleteClass(options){
    this.mv = options.mv;
    this.initialize(options.elements);
  }
  
  autoCompleteClass.prototype.constructor = autoCompleteClass;

    
  /*------------------------------------------------------------------------------------------------*/
  
  autoCompleteClass.prototype.initialize = function(elements){
    for(var el in elements){
      this.initializeElement(elements[el]);
    }
  }

  autoCompleteClass.prototype.initializeElement = function(element){
    // Use an XHRDataSource
    var oDS = new YAHOO.util.XHRDataSource(element.url);
    // Set the responseType
    oDS.responseType = YAHOO.util.XHRDataSource.TYPE_JSON;
    // Define the schema of the JSON results
    oDS.responseSchema = {
        resultsList : "ResultSet.Result",
        fields : ["Title"]
    };
    var currentClasName = new helperClass().getClassName(element.fieldId);
    // Instantiate the AutoComplete
    var oAC = new YAHOO.widget.AutoComplete(element.fieldId, element.listContainerId, oDS);
   // new helperClass().changeClassName(element.fieldId,currentClasName);
    // Throttle requests sent
    oAC.queryDelay = .5;
    // The webservice needs additional parameters
    oAC.generateRequest = function(sQuery) {
        return "?query=" + sQuery ;
    };
    
  //  oAC.subscribe("textboxKey", this.mv.searchFieldKeyWatcher, element.searchSet);
    oAC.itemSelectEvent.subscribe(this.mv.submitNewSearch, element.searchSet);
    oAC.dataRequestEvent.subscribe(this.mv.checkSumbiting, element.searchSet);
    
    
   // oAC.unmatchedItemSelectEvent.subscribe( this.mv.submitNewSearch, element.searchSet);
    
   // oAC.textboxKeyEvent.subscribe( this.mv.searchFieldKeyWatcher, element.searchSet);
    
    
    return {
        oDS: oDS,
        oAC: oAC
    };
  };
  
  
    
  /*------------------------------------------------------------------------------------------------*/
  /*------------------------------------------------------------------------------------------------*/