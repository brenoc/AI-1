(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['map/maps'], function(Maps) {
    var Render;
    return Render = (function() {
      function Render() {
        this.render = __bind(this.render, this);
      }

      Render.prototype.render = function() {
        var maps;
        maps = new Maps();
        return console.log(maps);
      };

      return Render;

    })();
  });

}).call(this);
