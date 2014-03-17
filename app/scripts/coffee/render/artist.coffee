
define ['render/map'], (Map, Link) ->
  class Artist
    constructor: (x, y) ->
      @maps = new Map()

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

    renderMap: (map, elem) ->
      mapDOM = elem
      y = 0
      for row in map
        x = 0
        for col in row
          @getPositionSelector(x, y, mapDOM).addClass(col)
          x++
        y++

    getPositionSelector: (x, y, map, link) ->
      if link
        return $('.map-row-'+y+'.map-col-'+x+' .link', map)
      else
        return $('.map-row-'+y+'.map-col-'+x, map)

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
