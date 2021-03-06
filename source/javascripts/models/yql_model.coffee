#= require ../init
class sdn.Models.YQLModel extends Backbone.Model
  sync: (method, model, options) ->
      params = _.extend(
        type: 'GET'
        dataType: 'jsonp'
        url: model.url()
        jsonp: '_callback'
        processData: false
        , options)
      $.jsonp(params)

  parse: (response) ->
    response = response?.query?.results?.channel
    if response.item.condition?.code?
      response.conditionCode = response.item.condition.code
      response.conditionText = response.item.condition.text
    response



