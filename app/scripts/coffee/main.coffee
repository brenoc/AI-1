requirejs.config
  baseUrl: 'scripts/js/'

setup =
  world:
    dungeon1:
      x: 5
      y: 32
    dungeon2:
      x: 39
      y: 17
    dungeon3:
      x: 24
      y: 1
    sword:
      x: 2
      y: 1
    lostwoods:
      x: 6
      y: 5

  dungeons:
    dungeon1:
      door:
        x: 14
        y: 26
      pendant:
        x: 13
        y: 3
    dungeon2:
      door:
        x: 13
        y: 25
      pendant:
        x: 13
        y: 2
    dungeon3:
      door:
        x: 14
        y: 25
      pendant:
        x: 15
        y: 19

  link:
    x: 24
    y: 27

# Main function
requirejs ['render/world', 'render/link', 'ai/astar'], (World, Link, AStar) ->
  window.world = new World(setup)
  window.link = new Link(setup, world)
  window.AStar = new AStar(setup, world)
