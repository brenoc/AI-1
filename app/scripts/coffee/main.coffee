requirejs.config
  baseUrl: 'scripts/js/'

# Main function
requirejs ['render/artist', 'render/link'], (Artist, Link) ->
  artist = new Artist()
  window.link = new Link(24, 27)


