
class sdn.Views.WeatherControlPanel extends Backbone.View

  events:
    "click .close-button": "hide"
    "click": "cancelClose"
    "click .condition": "chooseCondition"
    "click button[data-panel]": "changePanel"
    "change input[name=windspeed]": "selectWind"
    "change input[name=hour]": "selectTime"


  initialize: (options) ->
    @fogModel = options.fogModel
    @model.on("change:conditionCode", @setScene, this)
    @fogModel.on("change:foggy", @selectScene, this)

  render: ->
    @hide()
    @resetPanels()
    @$el.find(".row-panel").first().css("display", "block")
    @$el.find("button[data-panel]").first().addClass("active")
    @setScene()
    @setWind()
    @setFog()


  show: ->
    @_isShown = true
    @$el.addClass("visible")
    false

  hide: ->
    @_isShown = false
    @$el.removeClass("visible")

  resetPanels: ->
    @$el.find(".row-panel").css("display", "none")
    @$el.find("button[data-panel]").removeClass("active")

# when clicking on the control panel cancel the event so the panel doesn't close
  cancelClose: (ev) ->
    ev.preventDefault()
    false

  setScene: ->
    @$el.find("[data-scene]").not("[data-scene=fog]").removeClass("selected")
    @$el.find("[data-scene=#{@model.get("scene")}]").addClass("selected")

  setWind: ->
    wind = @model.get("wind")
    @$el.find("[name=windspeed]").val(wind.speed)
    false

  setTime: ->
    @$el.find("[name=hour]").val(@fogModel.get("hour"))
    false


  selectWind: (ev) ->
    @model.changeWind($(ev.currentTarget).val())
    ev.preventDefault()
    false

  selectTime: (ev) ->
    val = $(ev.currentTarget).val()
    val -= 23 if val > 23
    @fogModel.set("hour", val)
    ev.preventDefault()
    false

  setFog: ->
    @$el.find("[data-scene=fog]").addClass("selected") unless @fogModel.get("foggy") == "no"

  selectFog: (ev) ->
    $wrapper = $(ev.currentTarget)
    if $wrapper.hasClass('selected')
      @fogModel.set("foggy", "no")
      $wrapper.removeClass("selected")
    else
      @fogModel.set("foggy", "yes")
      $wrapper.addClass("selected")


  chooseCondition: (ev) ->
    code = $(ev.currentTarget).data("condition-code")
    if code == "fog"
      @selectFog(ev)
    else
      text = $(ev.currentTarget).data("condition-text")
      item = _.clone @model.get("item")
      @model.set("conditionCode", code)
      @model.set("conditionText", text)
    false


  changePanel: (ev) ->
    $target = $(ev.currentTarget)
    panel = $target.data("panel")
    @resetPanels()
    @$el.find(".panel-#{panel}").css("display", "block")
    $target.addClass("active")
    false

