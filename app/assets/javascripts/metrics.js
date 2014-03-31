function Metrics( options ) {

  var settings = $.extend({
    container: "body",
    data: {}
  }, options );


  

  this.render = function () {
    console.log("Rendering");   

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

    return false;
    
    console.log("Rendering Map");

    if (data.data == undefined) {
      throw Error("Data object is null.");
    }

    console.log(data.data);

    var geocoder;
    var map;
   

    geocoder = new google.maps.Geocoder();
    var latlng = new google.maps.LatLng(-34.397, 150.644);
    var mapOptions = {
      zoom: 8,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);


    // data.data.forEach(function(element) {
      var element = data.data[0];
      geocoder.geocode( { 'address': element}, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          console.log(results);
          map.setCenter(results[0].geometry.location);
          var marker = new google.maps.Marker({
              map: map,
              position: results[0].geometry.location
          });
        } else {
          alert('Geocode was not successful for the following reason: ' + status);
        }
      });
    // });

    return this;
  };



  var renderText = function (component) {
     if (component.data == undefined) {
      throw Error("Component data is null.");
    }
    console.log(component.data);
  };
  var renderTable = function (data) {
    console.log("Rendering Table");
    console.log(data);
  };


}

