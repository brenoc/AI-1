
define ->
  class Link
    constructor: (setup, world) ->
      @world = world

      @link =
        map: 'world'
        position:
          x: setup.link.x
          y: setup.link.y
        direction:
          'standing'

      @render(@link.position.x, @link.position.y, @link.map)

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

    enterDungeon1: =>
      x = $('.dungeon1 .P').data('x')
      y = $('.dungeon1 .P').data('y')
      @link.direction = 'standing'
      @render(x, y, 'dungeon1')

    enterDungeon2: =>
      x = $('.dungeon2 .P').data('x')
      y = $('.dungeon2 .P').data('y')
      @link.direction = 'standing'
      @render(x, y, 'dungeon1')

    enterDungeon3: =>
      x = $('.dungeon3 .P').data('x')
      y = $('.dungeon3 .P').data('y')
      @link.direction = 'standing'
      @render(x, y, 'dungeon3')

    render: (x, y, map) =>
      @remove()
      @link.position.x = x
      @link.position.y = y
      @link.map = map
      map = @world.getMap(@link.map)
      position = @world.getPositionSelector @link.position.x,
                                            @link.position.y,
                                            map
      link = '<div class="link link-'+@link.direction+'"></div>'
      $(position, map).append(link)
      return

    remove: () =>
      map = @world.getMap(@link.map)
      link = @world.getPositionSelector @link.position.x,
                                        @link.position.y,
                                        map, true
      $(link).remove() if link


