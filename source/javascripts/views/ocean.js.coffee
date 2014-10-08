#= require ../init

class sdn.Views.Ocean extends Backbone.View
  initialize: ->
    @model.on("change:scene", @render, this)
  css:
    "mcloud": "mostly-cloudy"
    "rain":  "storm"
    "thunder": "storm"
  el: "#ocean"
  render: ->
    scene = @model.get("scene")
    @$el.removeClass().addClass(@.css[scene]) unless !scene