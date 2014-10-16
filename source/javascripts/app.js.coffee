#= require ./init
#= require_tree ./models
#= require_tree ./views

_(sdn).extend(
  app:
    init: ->
      @weather= new sdn.Models.Weather()
      @time = new sdn.Models.Time()
      wf = @weather.fetch()
      tf = @time.fetch()
      $.when(tf,wf).done(=>
#         sometimes the yql service is down but still returns successfully, it just doesnt return results.
        if @weather.has("item")
          @createWeather()
        else
          @setDefaultWeather()
      )
      .fail(=> @setDefaultWeather())
    createWeather: () ->
      new sdn.Views.Weather(model: @weather, ceiling: 80, el: $("#weather_background").get(0)).render()
      new sdn.Views.Weather(model: @weather, el: $("#weather_midground").get(0), delay: 1500, windModifier: .05).render()
      new sdn.Views.Weather(model: @weather, el: $("#weather_foreground", delay: 2500, windModifier: .08).get(0)).render()
      new sdn.Views.Haze(model: @weather).render()
      new sdn.Views.Ocean(model: @weather).render()
      @controlPanel = new sdn.Views.WeatherControlPanel(model: @weather, el: $(".weather-control-panel").get(0))
      @conditions = new sdn.Views.WeatherConditions(model: @weather, el: $(".weather-conditions").get(0))
      @weather.on("change", @controlPanel.render())
      @conditions.on("weatherconditions:change", (=> @controlPanel.show()))
      @controlPanel.render()
      @conditions.render()

      $(window).click((=>
        @controlPanel.hide()
      ))



#   For default weather we may as well make it a beautiful day (except with a few clouds to show them off)
    setDefaultWeather: ->
      @weather.set(
        item:
          condition:
            temp: 68
            code: 30
            text: 'Partly Cloudy'
        wind:
          speed: 12
        conditionCode: 30
        conditionText: 'Partly Cloudy'
      )
      @createWeather()

    stageWeather: ->
      @scene = @getScene()

)
$ =>sdn.app.init()
