requirejs.config
  baseUrl: 'scripts/js/'

# Main function
requirejs ['render/world', 'render/link'], (World, Link) ->
  window.world = new World()
  window.link = new Link(24, 27)
