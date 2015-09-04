
 function systemBenchMarkClass(options){
   this.initializeOptions(options);
   this.h = new helperClass();
 }
 
 systemBenchMarkClass.prototype.constructor = systemBenchMarkClass;

 systemBenchMarkClass.prototype.initializeOptions = function(options){
   for( o in options){
     this[o] = options[o];
   }
 }
  
 systemBenchMarkClass.prototype.stop = function () {
   return this.clock('stop');
 }
 
 systemBenchMarkClass.prototype.start = function () {
   return this.clock('start');
 }

 systemBenchMarkClass.prototype.clock = function (action) {
   var d = +(new Date);
   if (this.time < 1 || action === 'start') {
       this.time = d;
       return 0;
   } else if (action === 'stop') {
       var t = d - this.time;
       this.time = 0;    
       return t;
   } else {
       return d - this.time;    
   }
 };
 
 systemBenchMarkClass.prototype.calculateProcessed = function (results) {
   var t = 0; 
   var r = this.h.getResults_p(results);
   if(((r.n - r.s) - r.p) < 0){
     t = (r.n - r.s)
   }else{
     t = r.p
   }
   return t;
 }
 
 systemBenchMarkClass.prototype.calculateBenchAvg = function( processOneItem, benchmarks,n) {
   var sum = 0;
   for(var i = 0;i< benchmarks.length;i++){
    sum += benchmarks[i];
   }
   return (sum/benchmarks.length);
 }
 
 