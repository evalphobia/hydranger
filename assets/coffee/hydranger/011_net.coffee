Hydranger.modules.net = (self) ->
  'use strict'
  self.net = {}

  self.net.getContents = (url, callback)->
    my = self.net
    xhr = new XMLHttpRequest()
    xhr.open "get", url, true
    xhr.onload = ->
        data = my.parseJSON this.responseText
        callback(data)
        return
    xhr.send(null)
    return

  self.net.getJSON = (url, callback)->
    my = self.net
    my.getContents(url, (data)->
        callback(data)
        return
    )
    return

  self.net.parseJSON = (data) ->
    try
        parsed = JSON.parse data
        return parsed
    catch e
        console.log(e)
    parsed = (new Function("return " + data))()
    return parsed
  return
