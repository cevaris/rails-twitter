function Metrics( options ) {
  var settings = $.extend({
        container: "body"
    }, options );
 
  this.render = function () {
    console.log("rendering");
    console.log(settings);
  };
}

