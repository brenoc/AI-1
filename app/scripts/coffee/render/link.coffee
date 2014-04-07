
define ->
  class Link
    constructor: (setup, world) ->
      @world = world

      @map = 'world'
      @position =
        x: setup.link.x
        y: setup.link.y
      @direction = 'standing'

      @render(@position.x, @position.y, @map)

    moveLeft: =>
      @direction = 'left'
      return @render(@position.x-1, @position.y, @map)

    moveRight: =>
      @direction = 'right'
      return @render(@position.x+1, @position.y, @map)

    moveUp: =>
      @direction = 'up'
      return @render(@position.x, @position.y-1, @map)

    moveDown: =>
      @direction = 'down'
      return @render(@position.x, @position.y+1, @map)

    atDungeonDoor: () =>
      position = @world.getPositionSelector @position.x,
                                            @position.y,
                                            @map

      if @map is 'world'
        dungeon = $(position).data('dungeon')
        return if dungeon then 'dungeon'+dungeon else false
      else
        return $(position).hasClass('P')

    getPendant: () =>
      position = @world.getPositionSelector @position.x,
                                            @position.y,
                                            @map

      $(position).removeClass('X')

    enter: =>
      return if not @atDungeonDoor()

      dungeon = @atDungeonDoor()

      x = $('.map-'+dungeon+' .P').data('x')
      y = $('.map-'+dungeon+' .P').data('y')
      @direction = 'standing'
      @render(x, y, dungeon)

    leave: =>
      return if not @atDungeonDoor()

      x = $('.'+@map+'-entrance').data('x')
      y = $('.'+@map+'-entrance').data('y')
      @direction = 'standing'
      @render(x, y, 'world')

    render: (x, y, map) =>
      @remove()
      @position.x = x
      @position.y = y
      @map = map
      position = @world.getPositionSelector @position.x,
                                            @position.y,
                                            @map
      link = '<div class="link link-'+@direction+'"></div>'
      $(position, map).append(link)
      return

    remove: () =>
      link = @world.getPositionSelector @position.x,
                                        @position.y,
                                        @map, true
      $(link).remove() if link
