# binding
Hydranger.modules.binding = (self) ->
  'use strict'
  self.binding = {}
  self.binding.config = {}

  self.binding.config.common = 
    sidebars : ko.observableArray([])
    listrows : ko.observableArray([])
    listheaders : ko.observableArray([])


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
    s.listrows = common.listrows

    return

  return
