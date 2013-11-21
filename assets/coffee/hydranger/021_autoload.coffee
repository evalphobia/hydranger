Hydranger.modules.autoload = (self) ->
  'use strict'
  self.autoload = {}
  self.autoload.config = {}

  self.autoload.config.common =
    targetId : "autoload"
    preload : "preload"
    postload : "postload"


  self.autoload.init = ->
    my = self.autoload
    common = my.config.common
    my.loader common.preload
    return

  self.autoload.finishPreload = ->
    my = self.autoload
    common = my.config.common
    my.loader common.postload
    return

  self.autoload.loader = (dataname) ->
    my = self.autoload
    common = my.config.common
    my.el = document.getElementById(common.targetId)
    loadings = my.el.dataset[dataname]
    return false  if typeof loadings is "undefined"
    loadings = loadings.split(" ")
    for own key, module_name of loadings
      continue if typeof self[module_name] is "undefined" or typeof self[module_name].init isnt "function"
      self[module_name].init()
    return

  return
