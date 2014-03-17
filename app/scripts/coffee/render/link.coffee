
define ['render/artist'], (Artist) ->
  class Link
    constructor: (x, y) ->
      @artist = new Artist()

      @link =
        map: 'world'
        position:
          x: x
          y: y
        direction:
          'standing'

      @render(x, y, @link.map)

    render: (x, y, map) =>
      # Verifica se ele está parado
      if @link.map is map and
         @link.position.x is x and
         @link.position.y is y
        @remove()
        @link.direction = 'standing'
        @paint()
        return
      # TODO outros casos em que ele muda de direção

    paint: () =>
      map = @artist.getMap(@link.map)
      position = @artist.getPositionSelector @link.position.x,
                                             @link.position.y,
                                             map
      link = '<div class="link link-'+@link.direction+'"></div>'
      $(position, map).append(link)

    remove: () =>
      map = @artist.getMap(@link.map)
      link = @artist.getPositionSelector @link.position.x,
                                         @link.position.y,
                                         map, true
      $(link).remove() if link


