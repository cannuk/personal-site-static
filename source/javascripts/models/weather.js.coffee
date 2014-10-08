#= require ../init
#= require ./yql_model
class sdn.Models.Weather extends sdn.Models.YQLModel
  urlRoot: "http://query.yahooapis.com/v1/public/yql?q=select%20wind%2C%20astronomy%2C%20item.condition.code%2C%20item.condition.temp%2C%20item.condition.text%20%20%20from%20weather.forecast%20where%20location%3D%2294105%22&format=json&callback=?"
  initialize: ->
    @setScene()
    @setWindspeed()

    console.log this
    @on("change:wind", @setWindspeed)
    @on("change:item", @setScene)
  setScene: ->
    item = @get("item")
    code = if item?.condition?.code then item.condition.code else 29
    console.log code
    scenes =
      'pcloud':  [30, 44, 29]
      'mcloud':  [26, 27]
      'thunder': [37,38,39,45,47]
      'rain':    [8,9,11,12,40, 28]
    for own scene, codes of scenes
      return @set(scene: scene) unless _.indexOf(codes, code) == -1
  setWindspeed: () ->
    wind = @get("wind")
    #I use 7 as the benchmark average wind speed
    windSpeed = .1
    if wind? and wind.speed?
      windSpeed = (parseInt(wind.speed)/7)*.04
      @set(windspeed: windSpeed)
