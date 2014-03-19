function Metrics( options ) {

  var settings = $.extend({
    container: "body",
    data: {}
  }, options );


  

  this.render = function () {
    console.log("rendering");   

    if (settings.data == undefined) {
      throw Error("Data object is null.");
    }
    if (settings.data.documents == undefined) {
      throw Error("Data documents is null.");
    }

    var data = settings.data,
        documents = settings.data.documents;

    documents.forEach(function(element) {

      switch (element.render) {
        case "map":
          renderMap(element);
          break;
        case "text":
          renderText(element);
          break;
        case "table":
          renderTable(element);
          break;
        default:
          throw Error("Could not find render type "+data.render);
      }

    });
    

  };

  var renderMap = function (data) {
    console.log("Rendering Map");
    console.log(data);
  };
  var renderText = function (data) {
    console.log("Rendering Text");
    console.log(data);
  };
  var renderTable = function (data) {
    console.log("Rendering Table");
    console.log(data);
  };


}

