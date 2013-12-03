# google spread sheet
Hydranger.modules.gss = (self) ->
  'use strict'
  self.gss = {}
  self.gss.config = {}

  self.gss.config.common = 
    key : ->
      return self.conf.key
    sheets: ->
      return self.conf.sheets
    relations: ->
      return self.conf.relations

  self.gss.init = ->
    my = self.gss
    my.getSheet()
    return 

  self.gss.getSheet = ->
    my = self.gss
    common = my.config.common
    sheetkey = common.key()
    sheetlists = common.sheets()
    columns = []
    for own i,sheet of sheetlists
      params = 
        'key' : sheetkey,
        'sheet' : sheet,
        'pub' : false,
        'headers' : 1
      self.gvizapi.getSheetContents params, (data, sheets)->
        if sheetlists.length is Object.keys(sheets).length
          sheet = my.joinSheets sheets
          jsondata = my.getJSONData sheet
          my.updateRows(jsondata)
    return

  self.gss.joinSheets = (sheets) ->
    my = self.gss
    common = my.config.common
    relations = common.relations()
    for own i,relation of relations
      if Object.keys(relation).length is not 2
        throw "Config Error: relations:: must have exact 2 keys"
      dt = []
      for own sheetname,column of relation
        sheet = sheets[sheetname]
        jsondata = my.getJSONData sheet
        columns = []
        for own j,col of jsondata.cols
          if col.label is column
            id = parseInt j, 10
          else
            columns.push my.getColumnNumberById col.id
        dt.push {"sheet" : sheets[sheetname], "id" : id, "columns": columns, "name": sheetname }
      joined_dt = google.visualization.data.join dt[0].sheet, dt[1].sheet, 'left', [[dt[0].id, dt[1].id]],  dt[0].columns, dt[1].columns 
      sheets[dt[0].name] = joined_dt
      sheets[dt[1].name] = joined_dt
      last_dt = joined_dt
    return last_dt

  self.gss.getColumnNumberById = (id)->
      radix = 26
      initialId = 'A'
      initialCharCode = initialId.charCodeAt 0
      id = id.toUpperCase()
      num = 0
      for char,index in id.split ''
        num = (radix * num) + (char.charCodeAt(index) - initialCharCode)
      return num

  self.gss.updateRows = (jsondata) ->
    # initialize filters from json data
    columns = self.conf.columns
    filtering_items = {}
    for own i,column of columns
      # add filtering column
      filtering_items[column.column] = {} if column.filtering
      # set display order
      for own j,label of jsondata.cols
        if column.column is label.label
          column.id = j
          break
    # create each row
    rows = []
    for own i,values of jsondata.rows
      values = values.c
      row = {}
      row._id = i
      for own j,column of columns 
        name = column.column
        row[name] = values[column.id].v
        row[name] = if row[name] is null then "" else row[name]
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

  self.gss.getJSONData = (sheet) ->
    return JSON.parse sheet.toJSON()

  return
