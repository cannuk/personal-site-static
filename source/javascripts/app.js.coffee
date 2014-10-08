#= require ./init
#= require_tree ./models
#= require_tree ./views

_(sdn).extend(
  app:
    init: ->
      @weather= new sdn.Models.Weather()
      @weather.fetch(
        success: =>
#         sometimes the yql service is down but still returns successfully, it just doesnt return results.
          if @weather.has("item")
            @createWeather()
          else
            @setDefaultWeather()
        error: => @setDefaultWeather()
      )
    createWeather: () ->
      new sdn.Views.Weather(model: @weather, ceiling: 80, el: $("#weather_background").get(0)).render()
      new sdn.Views.Weather(model: @weather, el: $("#weather_midground").get(0), delay: 1500, windModifier: .05).render()
      new sdn.Views.Weather(model: @weather, el: $("#weather_foreground", delay: 2500, windModifier: .08).get(0)).render()
      new sdn.Views.Haze(model: @weather).render()
      new sdn.Views.Ocean(model: @weather).render()


#   For default weather we may as well make it a beautiful day (except with a few clouds to show them off)
    setDefaultWeather: ->
      @weather.set(
        item:
          condition:
            code: 30
            status: 'Partly Cloudy'
        wind:
          speed: 12
      )
      @createWeather()

    stageWeather: ->
      @scene = @getScene()

)
$ =>sdn.app.init()
