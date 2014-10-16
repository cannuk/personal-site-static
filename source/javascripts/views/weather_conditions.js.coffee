
class sdn.Views.WeatherConditions extends Backbone.View

  events:
    "click .weather-control-panel-button": "changeWeather"

  initialize: ->
    this.listenTo(@model, "change:conditionText", @render)

  render: () ->
    item = @model.get("item")
    @$el.find(".temperature").html("#{item.condition.temp}")
    @$el.find(".conditions").text(@model.get("conditionText"))

  changeWeather: ->
    @trigger("weatherconditions:change")
    false
