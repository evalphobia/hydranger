# load config
Hydranger.modules.configManager = (self) ->
  'use strict'
  self.configManager = {}
  self.configManager.config = {}

  self.configManager.config.common =
    targetNode: ->
      return self.autoload.el  # div-element having id#autoload

  # initialize
  self.configManager.init = ->
    my = self.configManager
    my.loadConfig()
    return 

  # load data from json file
  self.configManager.loadConfig = ->
    my = self.configManager
    common = my.config.common
    el = common.targetNode()
    url = el.dataset.config
    self.net.getJSON url, (data)->
      self.conf = data
      self.autoload.finishPreload() # run postload
      my.setConfig()
      return
    return

  self.configManager.setConfig = ->
    data = self.conf
    bind = self.binding.config.common
    for own key,value of data.list  # sidebar items
      bind.sidebars.push value
    for own key,value of data.columns # table header cells
      value.name = value.column if not value.name  
      bind.listheaders.push value
    return


  return
