# view
Hydranger.modules.view = (self) ->
  self.view = {}
  self.view.config = {}

  self.view.config.enableEditButton =
    baseURL : 'https://docs.google.com/spreadsheet/ccc'
    targetNode : 'hr-edit-button'

  self.view.init = ->
    my = self.view
    my.enableEditButton()
    return 
 
  self.view.enableEditButton = ->
    my = self.view
    config = my.config.enableEditButton
    el = document.getElementById(config.targetNode)
    url = config.baseURL+"?key="+self.conf.key
    el.setAttribute("href", url)
    el.removeAttribute("disabled")
    return

  return
