
class sdn.Views.WeatherControlPanel extends Backbone.View

  events:
    "click .close-button": "hide"
    "click": "cancelClose"
    "click .condition": "chooseCondition"
    "click button[data-panel]": "changePanel"
    "change [name=windSpeed]": "setWind"

  render: ->
    @hide()
    @resetPanels()
    @$el.find(".row-panel").first().css("display", "block")
    @$el.find("button[data-panel]").first().addClass("active")
    @selectScene()
    @selectWind()


  show: ->
    @_isShown = true
    @$el.addClass("visible")
    false

  hide: ->
    @_isShown = false
    @$el.removeClass("visible")
    false

  resetPanels: ->
    @$el.find(".row-panel").css("display", "none")
    @$el.find("button[data-panel]").removeClass("active")

# when clicking on the control panel cancel the event so the panel doesn't close
  cancelClose: ->
    false

  selectScene: ->
    @$el.find(".condition-wrapper").removeClass("selected")
    @$el.find("[data-scene=#{@model.get("scene")}]").find(".condition-wrapper").addClass("selected")

  selectWind: ->
    @$el.find("[name=windSpeed]").val(@model.get("windspeed"))


  setWind: (ev) ->
    @model.changeWind($(ev.currentTarget).val())

  chooseCondition: (ev) ->
    code = $(ev.currentTarget).data("condition-code")
    text = $(ev.currentTarget).data("condition-text")
    item = _.clone @model.get("item")
    @model.set("conditionCode", code)
    @model.set("conditionText", text)
    @trigger "controlpanel:changecondition", conditionCode: code

  changePanel: (ev) ->
    $target = $(ev.currentTarget)
    panel = $target.data("panel")
    @resetPanels()
    @$el.find(".panel-#{panel}").css("display", "block")
    $target.addClass("active")
    false

