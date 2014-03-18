
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

    atDungeonDoor: () =>
      map = @world.getMap(@link.map)
      position = @world.getPositionSelector @link.position.x,
                                            @link.position.y,
                                            map

      if @link.map is 'world'
        dungeon = $(position).data('dungeon')
        return if dungeon then 'dungeon'+dungeon else false
      else
        return $(position).hasClass('P')

    enter: =>
      return if not @atDungeonDoor()

      dungeon = @atDungeonDoor()

      x = $('.'+dungeon+' .P').data('x')
      y = $('.'+dungeon+' .P').data('y')
      @link.direction = 'standing'
      @render(x, y, dungeon)

    leave: =>
      return if not @atDungeonDoor()

      x = $('.'+@link.map+'-entrance').data('x')
      y = $('.'+@link.map+'-entrance').data('y')
      @link.direction = 'standing'
      @render(x, y, 'world')

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


