#= require ./init
#= require_tree ./models
#= require_tree ./views

_(sdn).extend(
  app:
    init: ->
      @weather= new sdn.Models.Weather()
      @fog = new sdn.Models.Fog()
      wf = @weather.fetch()
      ff = @fog.fetch()

      @fog.on("change:hour", @setTime, this)

      $.when(ff,wf).done(=>
#       sometimes the yql service is down but still returns successfully, it just doesnt return results.
        @setDefaultWeather() unless @weather.has("item")
        @setDefaultFog() unless @fog.has("foggy")
        @createWeather()
        @setTime()
      )
      .fail(=>
        @setDefaultWeather()
        @setDefaultFog()
        @createWeather()
        @setTime()
      )
    createWeather: ->
      new sdn.Views.Weather(model: @weather, ceiling: 80, el: $("#weather_background").get(0)).render()
      new sdn.Views.Weather(model: @weather, ceiling: 40, el: $("#weather_midground").get(0), delay: 1500, windModifier: .02).render()
      new sdn.Views.Weather(model: @weather, el: $("#weather_foreground").get(0), delay: 2500, windModifier: .06).render()
      new sdn.Views.Fog(model: @fog, el: $("#fog-front").get(0), windModifier: .08).render()
      new sdn.Views.Haze(model: @weather).render()
      new sdn.Views.Ocean(model: @weather).render()
      @controlPanel = new sdn.Views.WeatherControlPanel(model: @weather, fogModel: @fog, el: $(".weather-control-panel").get(0))
      @conditions = new sdn.Views.WeatherConditions(model: @weather, el: $(".weather-conditions").get(0))
      @conditions.on("weatherconditions:change", (=> @controlPanel.show()))
      @controlPanel.render()
      @conditions.render()

      $(window).click((=>
        @controlPanel.hide()
      ))

    setTime: ->
      hour = @fog.get("hour")
      $("#sky").removeClass().addClass("sky-gradient-#{hour}")
      hourOpacity = [.7, .7, .7, .7, .8, .9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, .9, .8, .7, .7, .7]
      $(".postcard").css("opacity", hourOpacity[hour])





#   For default weather we may as well make it a beautiful day (except with a few clouds to show them off)
    setDefaultWeather: ->
      @weather.set
        item:
          condition:
            temp: 68
            code: 30
            text: 'Partly Cloudy'
        wind:
          speed: 12
        conditionCode: 30
        conditionText: 'Partly Cloudy'

    setDefaultFog: ->
      @fog.set
        foggy: "yes"
        hour: 5
        updated_at: "2014-10-15T17:34:07Z"


    stageWeather: ->
      @scene = @getScene()

)
$ =>sdn.app.init()
