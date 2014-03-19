function Metrics( options ) {

  var settings = $.extend({
    container: "body",
    data: {}
  }, options );


  this.handle = function (type, object) {

  };

  this.render = function () {
    console.log("rendering");   

    if (settings.data == undefined) {
      throw Error("No data found");
    }
  };


}

