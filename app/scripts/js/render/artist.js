(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['render/map'], function(Map) {
    var Artist;
    return Artist = (function() {
      function Artist() {
        this.render = __bind(this.render, this);
      }

      Artist.prototype.render = function() {
        var maps;
        maps = new Map();
        return console.log(maps);
      };

      return Artist;

    })();
  });

}).call(this);
