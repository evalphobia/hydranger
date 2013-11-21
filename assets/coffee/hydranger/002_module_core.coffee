# modules
Hydranger.modules = {}
Hydranger.modules.core = (self) ->
  'use strict'
  self.onload = (e) ->
    if window.addEventListener
      window.addEventListener "load", e, false
    else if window.attachEvent #for IE
      window.attachEvent "onload", e
    else if window.jQuery
      window.jQuery("document").ready ->
        e()
    else
      window.onload = e
    return

  return

