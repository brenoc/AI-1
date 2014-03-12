(function() {
  requirejs.config({
    baseUrl: 'scripts/js/'
  });

  requirejs(['render/artist'], function(Artist) {
    var artist;
    artist = new Artist();
    return artist.render();
  });

}).call(this);
