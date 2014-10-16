class sdn.Models.Time extends Backbone.Model
  urlRoot: "http://www.isitfoggyinsanfrancisco.com/forecast/time?callback=?"
  sync: (method, model, options) ->
    params = _.extend(
      type: 'GET'
      dataType: 'jsonp'
      url: model.url()
      jsonp: 'callback'
      processData: false
      , options)
    $.jsonp(params)

  parse: (response) ->
    response?.query?.results?.channel

