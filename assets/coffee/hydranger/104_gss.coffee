# google spread sheet
Hydranger.modules.gss = (self) ->
  'use strict'
  self.gss = {}
  self.gss.config = {}

  self.gss.config.common = 
    key : ->
      return self.conf.key

  self.gss.init = ->
    my = self.gss
    my.getSheet()
    return 

  self.gss.getSheet = ->
    my = self.gss
    common = my.config.common
    sheetkey = common.key()
    columns = []
    for own key,value of self.conf.header
      columns.push "%"+value.column+"%"
    sheet = new SpreadsheetRenderer
      'key' : sheetkey,
      'pub' : false,
      'gid' : 0,
      'headers' : 1,
      'template' : columns.join("\t")
    sheet.render 'select * ', (list)->
      my.updateRows(list)
    return

  self.gss.updateRows = (list) ->
    bind = self.binding.config.common
    bindrows = bind.listrows
    rows = []
    headers = []
    for own key,value of self.conf.header
      headers.push value.column
    for own i,values of list
      row = {}
      row.id = i
      values = values.split "\t"
      for own j,title of headers
        row[title] = values[j]
      rows.push row
      bindrows.push row
    self.indexeddb.insert rows
    return

  return
