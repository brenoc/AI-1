
define ['render/map'], (Map, Link) ->
  class World
    constructor: (setup) ->
      @maps = new Map()
      @setup = setup

      @worldMap = '.map-world tbody'
      @dungeon1Map = '.map-dungeon-bottom-left tbody'
      @dungeon2Map = '.map-dungeon-bottom-right tbody'
      @dungeon3Map = '.map-dungeon-top-right tbody'

      @render()

    render: =>
      @renderMap(@maps.world, 'world')
      @renderMap(@maps.dungeon1, 'dungeon1')
      @renderMap(@maps.dungeon2, 'dungeon2')
      @renderMap(@maps.dungeon3, 'dungeon3')
      @renderConfigElements()

    renderMap: (map, elem) ->
      mapDOM = elem
      y = 0
      for row in map
        x = 0
        for col in row
          @getPositionSelector(x, y, mapDOM)
            .addClass(col)
            .data('cost', @getCost(col))
            .data('x', x)
            .data('y', y)
          x++
        y++

    renderConfigElements: =>
      @renderWorldElements()
      @renderDungeonElements()

    renderWorldElements: =>
      i = 1
      while i < 4
        current = 'dungeon'+i
        setup = @setup.world[current]

        @getPositionSelector(setup.x, setup.y, 'world')
          .addClass(current+'-entrance')
          .addClass('P')
          .data('dungeon', i)

        i++

    renderDungeonElements: =>
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

    getCost: (type) ->
      switch type
        when 'G' then return 10
        when 'S' then return 20
        when 'F' then return 100
        when 'M' then return 150
        when 'W' then return 180
        when 'L' then return 10
        when 'D' then return Infinity
        else return 0

