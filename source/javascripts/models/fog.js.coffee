class sdn.Models.Fog extends Backbone.Model
  urlRoot: "http://www.isitfoggyinsanfrancisco.com/forecast/current?callback=?"
#  urlRoot: "http://localhost:3001/forecast/current?callback=?"
  sync: (method, model, options) ->
    params = _.extend(
      type: 'GET'
      dataType: 'jsonp'
      url: model.url()
      jsonp: 'callback'
      processData: false
      , options)
    $.jsonp(params)


