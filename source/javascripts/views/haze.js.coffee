#= require ../init

class sdn.Views.Haze extends Backbone.View
  initialize: ->
    @model.on("change:scene", @render, this)
  css:
    "mcloud": "mostly-cloudy"
    "rain":  "raining"
    "thunder": "stormy"
  el: "#haze"
  render: ->
    scene = @model.get("scene")
    console.log scene
    @$el.removeClass().addClass(@css[scene]) unless !scene