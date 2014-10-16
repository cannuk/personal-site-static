#= require ../init
#= require ./yql_model
class sdn.Models.Weather extends sdn.Models.YQLModel
  urlRoot: "http://query.yahooapis.com/v1/public/yql?q=select%20wind%2C%20astronomy%2C%20item.condition.code%2C%20item.condition.temp%2C%20item.condition.text%20%20%20from%20weather.forecast%20where%20location%3D%2294105%22&format=json&callback=?"
  initialize: ->
    @setScene()
    @setWindspeed()
    @bindEvents()

  bindEvents: =>
    this.listenTo(this, "change", @setWindspeed)
    this.listenTo(this, "change:conditionCode", @setScene)
    this.listenTo(this, "change:conditionText", @setScene)


  setScene: ->
    conditionCode = @get("conditionCode")
    if conditionCode
      code = parseInt(conditionCode)
      console.log code
      scenes =
        'clear':   [32, 31, 33, 34]
        'pcloud':  [29, 30, 44]
        'mcloud':  [26, 27, 28]
        'thunder': [37,38,39,45,47]
        'rain':    [8,9,11,12,40, 28]
      for own scene, codes of scenes
        return @set(scene: scene) if _.indexOf(codes, code) >= 0


  changeWind: (windspeed) ->
    wind = @get("wind")
    wind.speed = windspeed
    @set("wind", wind)
    @setWindspeed()

  setWindspeed: () ->
    wind = @get("wind")
    #I use 7 as the benchmark average wind speed
    windSpeed = .1
    if wind? and wind.speed?
      windSpeed = (parseInt(wind.speed))*.03
      console.log "windspeed is #{windSpeed}"
      @set(windspeed: windSpeed)
