
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

    moveLeft: =>
      @link.direction = 'left'
      return @render(@link.position.x-1, @link.position.y, @link.map)

    moveRight: =>
      @link.direction = 'right'
      return @render(@link.position.x+1, @link.position.y, @link.map)

    moveUp: =>
      @link.direction = 'up'
      return @render(@link.position.x, @link.position.y-1, @link.map)

    moveDown: =>
      @link.direction = 'down'
      return @render(@link.position.x, @link.position.y+1, @link.map)

    render: (x, y, map) =>
      @remove()
      @link.position.x = x
      @link.position.y = y
      @link.map = map
      map = @artist.getMap(@link.map)
      position = @artist.getPositionSelector @link.position.x,
                                             @link.position.y,
                                             map
      link = '<div class="link link-'+@link.direction+'"></div>'
      $(position, map).append(link)
      return

    remove: () =>
      map = @artist.getMap(@link.map)
      link = @artist.getPositionSelector @link.position.x,
                                         @link.position.y,
                                         map, true
      $(link).remove() if link


