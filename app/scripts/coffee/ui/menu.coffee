
define ->
  class Menu
    constructor: (setup, world, link, astar) ->
      @setup = setup
      @world = world
      @link = link
      @astar = astar

      @sound = false

      @bind()

    bind: =>
      @bindStart()
      @bindSound()

    bindStart: =>
      $('#start').on 'click', =>
        destination =
          x: 30
          y: 2
          map: 'world'

        start = new Date().getTime()
        result = @astar.findPath  destination.map,
                                  @setup.link.x,
                                  @setup.link.y,
                                  destination.x,
                                  destination.y
        end = new Date().getTime()

        @astar.utils.cleanUp(destination.map)
        @moveAlongThePath(result.path)

        time = end - start
        $('#time').text(time + ' ms')
        $('#cost').text(result.cost)
        return

    bindSound: =>
      $('#sound').on 'click', =>
        theme = $('#theme')[0]
        if @sound
          theme.pause()
          $('#sound').removeClass('glyphicon-volume-up')
          $('#sound').addClass('glyphicon-volume-off')
          @sound = false
        else
          theme.play()
          $('#sound').removeClass('glyphicon-volume-off')
          $('#sound').addClass('glyphicon-volume-up')
          @sound = true

    moveAlongThePath: (path) ->
      for movement, i in path
        setTimeout do (movement) ->
          ->
            if movement[0] > @link.position.x
              @link.moveRight()
            else if movement[0] < @link.position.x
              @link.moveLeft()
            else if movement[1] > @link.position.y
              @link.moveDown()
            else if movement[1] < @link.position.y
              @link.moveUp()
        , 1000 + (i*50)

