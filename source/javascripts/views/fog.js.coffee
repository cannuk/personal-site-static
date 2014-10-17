#= require ../init
#= require ./weather
class sdn.Views.Fog extends sdn.Views.Weather

  initialize: (options) ->
    @model.on("change:foggy", @toggle, this)
    super(options)


  render: () ->
    @width = @$el.width()
    @height = @$el.height()
    @stage = new Kinetic.Stage(container: @$el.get(0), width: @width, height: @height)
    @draw()
    @toggle()


  createCloud:(height = 3, width = 15, x = 0, y = 0)->
    size = 40
    cloudCanvas = document.createElement "canvas"
    context = cloudCanvas.getContext("2d")
    cloudCanvas.width = width * (size)
    cloudCanvas.height = height * (size+20)
    grid = (((Math.round(Math.random())) for num in [0..width]) for num in [0..height])
    #stormy = {r: 190, g: 195, b:209}
    #mostly cloudy = {r: 239, g: 239, b:239}
    $cloudgen.drawCloudGroup(context, grid, 40, 40, 25, {r: 240, g: 240, b:240})
    new Kinetic.Image(image: cloudCanvas, x: x, y: y, opacity: 0)

  show: ->
    @layer.show()

  hide: ->
    @layer.hide()

  toggle: ->
    if @model.get("foggy") is "no"
      @hide()
    else
      @show()


  draw: ->
    @layer = new Kinetic.Layer()
    @layer.visible = false
    cloudDensity = 20
    segmentSize = Math.floor((@width*2)/cloudDensity)
    @drawCloud((Math.floor(Math.random()*(x*segmentSize))), (Math.floor(Math.random()*@height) + 10)) for x in [0..cloudDensity]

  drawCloud: (x, y) ->
    cloud =  @createCloud(10, 25, x, y)
    @windSpeed = 0 #@model.get('windspeed')
    @windSpeed += @windModifier
    cloudWidth = cloud.getWidth()
    @layer.add(cloud)
    @stage.add(@layer)
    cloud.transitionTo
      opacity: .6
      duration: 2
    anim = new Kinetic.Animation
      func: (frame) =>
        pos = cloud.getX() - @windSpeed
        if (cloud.getX() + cloudWidth) <= 0
          pos = @stage.getWidth() + 10
          #reset the y pos too, for cloud randomness
        cloud.setX(pos)
      node: @layer
    anim.start()