#= require ../init
#= require cloudgen
class sdn.Views.Weather extends Backbone.View


  clouds:
    "clear":
      density: 0
    "pcloud":
      color: {r: 255, g: 255, b:255}
      density: 4
    "mcloud":
      color: {r: 255, g: 255, b:255}
      density: 10
    "rain":
      color: {r: 190, g: 195, b:209}
      density: 20
    "thunder":
      color: {r: 190, g: 195, b:209}
      density: 28

  initialize: (options) ->
    @windModifier = options.windModifier ? 0
    @delay = options.delay ? 0
    @ceiling = options.ceiling ? 20
    @model.on "change:scene", @render, this
    @model.on "change:windspeed", ->
      @windSpeed = @model.get "windspeed"
      @windSpeed += @windModifier
    ,this

  render: () ->
    if @isRendered
      @$el.html('')
    @width = @$el.width()
    @height = @$el.height()
    @stage = new Kinetic.Stage(container: @$el.get(0), width: @width, height: @height)
    @isRendered = true
    if(@delay > 0)
      setTimeout =>
        @draw()
      , @delay
    else
      @draw()

  createCloud:(height = 3, width = 15, x = 0, y = 0)->
    size = 23.7
    cloudCanvas = document.createElement "canvas"
    context = cloudCanvas.getContext("2d")
    cloudCanvas.width = width * (size)
    cloudCanvas.height = height * (size+20)
    grid = (((Math.round(Math.random())) for num in [0..width]) for num in [0..height])
    #stormy = {r: 190, g: 195, b:209}
    #mostly cloudy = {r: 239, g: 239, b:239}
    $cloudgen.drawCloudGroup(context, grid, 40, 40, 25, @clouds[@model.get('scene')].color)
    new Kinetic.Image(image: cloudCanvas, x: x, y: y, opacity: 0)


  draw: ->
    layer = new Kinetic.Layer()
    if @clouds[@model.get('scene')].density > 0
      cloudDensity = @clouds[@model.get('scene')].density
      segmentSize = Math.floor((@width*2)/cloudDensity)
      @drawCloud(layer, (Math.floor(Math.random()*(x*segmentSize))), (Math.floor(Math.random()*@height) - 120)) for x in [0..cloudDensity]

  drawCloud: (layer, x, y) ->
    cloud =  @createCloud(3, 15, x, y)
    @windSpeed = @model.get('windspeed')
    @windSpeed += @windModifier
    cloudWidth = cloud.getWidth()
    layer.add(cloud)
    @stage.add(layer)
    cloud.transitionTo
      opacity: 1
      duration: 1
    anim = new Kinetic.Animation
      func: (frame) =>
        pos = cloud.getX() - @windSpeed
        if (cloud.getX() + cloudWidth) <= 0
          pos = @stage.getWidth() + 10
          y =  (Math.floor(Math.random()*@height) - 120)
          #reset the y pos too, for cloud randomness
          cloud.setY(y)
        cloud.setX(pos)
      node: layer
    anim.start()