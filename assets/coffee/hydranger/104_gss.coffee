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
    for own key,value of self.conf.columns
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
    # initialize filters from json data
    columns = self.conf.columns
    filtering_items = {}
    for own j,column of columns
      filtering_items[column.column] = {} if column.filtering
    # create each row
    rows = []
    for own i,values of list
      row = {}
      row.id = i
      values = values.split "\t"
      for own j,column of columns  # create ordered row 
        name = column.column
        row[name] = values[j]
        if column.filtering is true
          item = row[name]
          # create multiple items (e.g. tagging)
          if column.multiple is true
            for own k,v of item.split(",")
              filtering_items[name][v] = true
          # create single item
          else
            filtering_items[name][item] = false
      rows.push row
    # create sidebar including items
    sidebars = []
    for own column,j of filtering_items
      items = []
      for own item,isMultiple of j
        items.push item
      sidebars.push { "name" : column, "items" : items, "multiple" : isMultiple }
    # update data
    self.binding.updateRows rows
    self.binding.updateSidebars sidebars
    self.indexeddb.insert rows

    return

  return
