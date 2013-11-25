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
    # initialize sidebar for selection
    sidebar_items = {}
    sidebar_columns = self.conf.list
    for own j,column of sidebar_columns
      sidebar_items[column] = {}
    # initialize headers to create ordered row 
    headers = []
    for own j,value of self.conf.header
      headers.push value.column
    # create each row
    rows = []
    for own i,values of list
      row = {}
      row.id = i
      values = values.split "\t"
      for own j,title of headers  # create ordered row 
        row[title] = values[j]
      for own j,side of sidebar_columns  # create sidebar items
        item = row[side]
        sidebar_items[side][item] = 1
      rows.push row
    # create sidebar including items
    sidebars = []
    for own column,j of sidebar_items
      items = []
      for own item,k of j
        items.push item
      sidebars.push { "name" : column, "items" : items }
    # update data
    console.log sidebars
    self.binding.updateRows rows
    self.binding.updateSidebars sidebars
    self.indexeddb.insert rows

    return

  return
