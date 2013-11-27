# binding
Hydranger.modules.binding = (self) ->
  'use strict'
  self.binding = {}
  self.binding.config = {}

  self.binding.config.common = 
    sidebars : ko.observableArray([])
    listheaders : ko.observableArray([])
    listrows : ko.observableArray([])
    allitems : []
    filters : ko.observableArray([])

  self.binding.init = ->
    console.log "init bind"
    my = self.binding
    my.makeBindings()
    return 
 
  self.binding.makeBindings = ->
    my = self.binding
    ko.applyBindings new my.ViewModel
    return

  self.binding.ViewModel = ->
    my = self.binding
    common = my.config.common
    s = this
    s.sidebars = common.sidebars
    s.listheaders = common.listheaders
    s.listrows = ko.computed ()-> 
      # filtering conditions
      filters = common.filters
      if !filters().length
        return common.listrows()
      return ko.utils.arrayFilter common.listrows(), (row)->
        for own i,filter of filters()
          if filter.multiple
            return false if (row[filter.key].indexOf filter.value) < 0
          else
            return false unless row[filter.key] is filter.value
        return true
    s.filterRows = my.filterRows
    s.toggleButton = (type, item)->
      isMulti = if typeof isMulti is "undefined" then false else isMulti
      selected = ko.utils.arrayFirst common.filters(), (filter)->
        return filter.key is type and filter.value is item
      btnclass = if selected then "btn-primary" else "btn-default"
      return btnclass
    return

  self.binding.updateArray = (koArray, items)->
    koArray.removeAll()
    ko.utils.arrayPushAll koArray(), items
    return

  self.binding.updateRows = (items)->
    my = self.binding
    common = my.config.common
    common.allitems = items
    my.updateArray common.listrows, items
    common.listrows.valueHasMutated()
    return 

  self.binding.updateSidebars = (items)->
    my = self.binding
    common = my.config.common
    my.updateArray common.sidebars, items
    common.sidebars.valueHasMutated()
    return 

  self.binding.filterRows = (type, item, isMulti)->
    my = self.binding
    common = my.config.common
    filters = common.filters
    isMulti = if typeof isMulti is "undefined" then false else isMulti
    newItem = { "key": type, "value": item, "multiple": isMulti }
    isSelected = false
    newFilters = ko.utils.arrayFilter filters(), (filter)->
      if filter.key is newItem.key and filter.value is newItem.value
        isSelected = true 
        return false
      if filter.key is newItem.key and not isMulti 
        return false
      else
        return true
    newFilters.push newItem unless isSelected
    my.updateArray filters, newFilters
    filters.valueHasMutated()
    return
