# html5 indexed db
Hydranger.modules.indexeddb = (self) ->
  'use strict'
  self.indexeddb = {}
  self.indexeddb.config = {}

  self.indexeddb.config.common =
    db : null
    dbname : "hydranger"
    version : 1

  self.indexeddb.init = ->
    my = self.indexeddb
    my.open()
    return 

  self.indexeddb.open = (callback)->
    my = self.indexeddb
    common = my.config.common
    dbh = indexedDB.open(common.dbname, common.version);
    dbh.onerror = (e)->
      console.log "Error: Indexed DB Open; Error-Code = "+e.target.errorCode
      return
    dbh.onsuccess = (e)->
      common.db = e.target.result
      callback() if typeof callback is "function"
      return
    dbh.onupgradeneeded = (e)->
      e.currentTarget.transaction.onerror = indexedDB.onerror
      db = e.currentTarget.result
      if db.objectStoreNames.contains "items"
        db.deleteObjectStore "items"
        console.log "deleted"
      store = db.createObjectStore "items", { keyPath : "id"}
      store.createIndex "nameIndex", "name", { unique: false }
      return
    return

  self.indexeddb.insert = (data)->
    my = self.indexeddb
    common = my.config.common
    db = common.db
    if !!common.db is false
      my.open ()->
        my.insert(data)
        return
      return
    trans = db.transaction ["items"], "readwrite"
    store = trans.objectStore "items"
    store.onerror = (e)->
      console.log "Error: Indexed DB Insert store; Error-Code = "+e.target.errorCode
      return
    store.onsuccess = (e)->
      return

    data = [data] if not Array.isArray data
    for own key,value of data
      request = store.put value
      request.onerror = (e)-> 
        console.log "Error: Indexed DB Insert request; Error-Code = "+e.target.errorCode
        return
      request.onsuccess = (e)->
        return
    return

  self.indexeddb.select = ()->
    my = self.indexeddb
    common = my.config.common
    db = common.db

  return
