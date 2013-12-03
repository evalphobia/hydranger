Hydranger.modules.gvizapi = (self) ->
  'use strict'
  self.gvizapi = {}
  self.gvizapi.config = 
    initialized : false
    url : 'https://docs.google.com/spreadsheet/ccc'
    options : 
      sendMethod : 'auto' 
  self.gvizapi.sheets = {}

  self.gvizapi.init = ->
    my = self.gvizapi
    config = my.config
    if !config.initialized
      google.load "visualization", "1.0", {'packages':['table']}
      config.initialized = true
    return

  self.gvizapi.getSheetContents = (params, callback)->
    my = self.gvizapi
    config = my.config
    if typeof params.pub is 'undefined'
      params.pub = false
    qs = self.net.createQueryString params
    url = config.url+'?'+qs
    query = new google.visualization.Query url, config.options
    query.setQuery 'select *'
    query.send (response)->
      if response.isError()
        console.log "google vizualization api Error:"+response.getDetailedMessage()
        return
      dt = response.getDataTable()
      my.sheets[params.sheet] = dt
      jsondata = JSON.parse dt.toJSON()
      callback jsondata, my.sheets
      return
    return

