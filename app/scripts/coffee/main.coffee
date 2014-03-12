requirejs.config
  baseUrl: 'scripts/js/'

# Main function
requirejs ['render/artist'], (Artist) ->
  artist = new Artist()
  artist.render()
