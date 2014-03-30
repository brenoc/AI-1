
# This module is responsible for the Menu UI
define ->
  class Menu
    constructor: (adventure) ->
      @adventure = adventure
      @sound = false

      @bind()

    # Bind click events
    bind: =>
      @bindStart()
      @bindSound()

    # Bind the Start button to initialize the algorithm
    bindStart: =>
      $('#start').on 'click', =>
        info = @adventure.start()

        $('#time').text(info.time + ' ms')
        $('#cost').text(info.cost)

    # Bind sound button to play and stop the music
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
