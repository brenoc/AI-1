
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
      @renderMap(@maps.world, $(@worldMap))
      @renderMap(@maps.dungeon1, $(@dungeon1Map))
      @renderMap(@maps.dungeon2, $(@dungeon2Map))
      @renderMap(@maps.dungeon3, $(@dungeon3Map))
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
      map = @getMap('world')

      i = 1
      while i < 4
        current = 'dungeon'+i
        setup = @setup.world[current]

        @getPositionSelector(setup.x, setup.y, map)
          .addClass(current+'-entrance')
          .addClass('P')
          .data('dungeon', i)

        i++

    renderDungeonElements: =>
      i = 1
      while i < 4
        current = 'dungeon'+i
        dungeon = @getMap(current)
        setup = @setup.dungeons[current]

        @getPositionSelector(setup.door.x, setup.door.y, dungeon)
          .addClass('P')
        @getPositionSelector(setup.pendant.x, setup.pendant.y, dungeon)
          .addClass('X')

        i++

    getPositionSelector: (x, y, map, link) ->
      if link
        return $('.map-row-'+y+'.map-col-'+x+' .link', map)
      else
        return $('.map-row-'+y+'.map-col-'+x, map)

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

    getMap: (mapName) =>
      switch mapName
        when 'world'
          return $(@worldMap)
        when 'dungeon1'
          return $(@dungeon1Map)
        when 'dungeon2'
          return $(@dungeon2Map)
        when 'dungeon3'
          return $(@dungeon3Map)


