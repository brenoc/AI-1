
define ['render/map', 'structure/grid'], (Map, Grid) ->
  class World
    constructor: (setup) ->
      @maps = new Map()
      @setup = setup

      @worldMap = '.map-world tbody'
      @dungeon1Map = '.map-dungeon-bottom-left tbody'
      @dungeon2Map = '.map-dungeon-bottom-right tbody'
      @dungeon3Map = '.map-dungeon-top-right tbody'

      @grid = {}
      @gridEverything()

      @render()

    gridEverything: =>
      world = new Grid(@maps.world)
      dungeon1 = new Grid(@maps.dungeon1)
      dungeon2 = new Grid(@maps.dungeon2)
      dungeon3 = new Grid(@maps.dungeon3)

      delete @grid
      @grid =
        'world': world
        'dungeon1': dungeon1
        'dungeon2': dungeon2
        'dungeon3': dungeon3

    render: =>
      @renderMap(@grid.world, 'world')
      @renderMap(@grid.dungeon1, 'dungeon1')
      @renderMap(@grid.dungeon2, 'dungeon2')
      @renderMap(@grid.dungeon3, 'dungeon3')
      @renderConfigElements()

    renderMap: (map, elem) ->
      mapDOM = elem

      for row in map
        for node in row
          @getPositionSelector(node.x, node.y, mapDOM)
            .addClass(node.type)
            .data('cost', node.cost)
            .data('x', node.x)
            .data('y', node.y)

    renderConfigElements: =>
      @renderWorldElements()
      @renderDungeonElements()

    renderWorldElements: =>
      # Render dungeons doors
      i = 1
      while i < 4
        current = 'dungeon'+i
        setup = @setup.world[current]

        @getPositionSelector(setup.x, setup.y, 'world')
          .addClass(current+'-entrance')
          .addClass('P')
          .data('dungeon', i)

        i++

      # Render Lost Woods
      setup = @setup.world['lostwoods']
      @getPositionSelector(setup.x, setup.y, 'world')
        .addClass('lost-woods')
        .addClass('O')

    renderDungeonElements: =>
      # Render dungeons doors and pendants
      i = 1
      while i < 4
        current = 'dungeon'+i
        setup = @setup.dungeons[current]

        @getPositionSelector(setup.door.x, setup.door.y, current)
          .addClass('P')
        @getPositionSelector(setup.pendant.x, setup.pendant.y, current)
          .addClass('X')

        i++

    getPositionSelector: (x, y, map, link) ->
      if link
        return $('.map-'+map+' .map-row-'+y+'.map-col-'+x+' .link')
      else
        return $('.map-'+map+' .map-row-'+y+'.map-col-'+x)

    getNode: (x, y, map) ->
      if @grid[map][y]?[x]?
        return @grid[map][y][x]
      else
        return false
