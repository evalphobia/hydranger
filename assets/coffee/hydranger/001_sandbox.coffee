# Sandbox
Hydranger = ->
  'use strict'
  args = Array::slice.call(arguments)
  callback = args.pop()
  modules = (if (args[0] and typeof args[0] is "string") then args else args[0])
  i = undefined
  return new Hydranger(modules, callback)  unless this instanceof Hydranger 
  if not modules or modules[0] is "*"
    modules = []
    for i of Hydranger.modules
      modules.push i  if Hydranger.modules.hasOwnProperty(i)
  i = 0
  max = modules.length

  while i < max
    Hydranger.modules[modules[i]] this
    i++
  callback this

  return
