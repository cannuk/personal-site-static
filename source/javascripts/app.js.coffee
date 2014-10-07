#= require ./init


_(@sdn).extend(
  app:
    init: ->
      @landscape= new sdn.landscape.Weather({})
      @landscape.fetch(
        success: => @createWeather()
        error: => @setDefaultWeather()
      )
    createWeather: () ->
      new sdn.landscape.views.Weather(model: @landscape, ceiling: 80, el: $("#weather_background").get(0)).render()
      new sdn.landscape.views.Weather(model: @landscape, el: $("#weather_midground").get(0), delay: 1500, windModifier: .05).render()
      new sdn.landscape.views.Weather(model: @landscape, el: $("#weather_foreground", delay: 2500, windModifier: .08).get(0)).render()
      new sdn.landscape.views.Haze(model: @landscape).render()
      new sdn.landscape.views.Ocean(model: @landscape).render()

    setDefaultWeather: ->
      @landscape.set(
        item:
          condition:
            code: 30
            status: 'Partly Cloudy'
          wind: 12
      )
      @createWeather()

    stageWeather: ->
      @scene = @getScene()

)
$ =>@sdn.app.init()
