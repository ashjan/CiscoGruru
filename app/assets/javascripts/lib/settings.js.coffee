class @Settings
  constructor: (@_defaults) ->
    unless @_defaults
      throw "Default value missing in Settings constructor"
    # if chrome?.permissions
    #   @impl = new ChromeStorageImpl(@_defaults)
    # else
    if typeof localStorage is 'undefined'
      @impl = new MemoryImpl(@_defaults)
    else
      @impl = new LocalStorageImpl(@_defaults)
    return

  read: (key) ->
    @impl.read(key)

  set: (key, value) ->
    @impl.set(key, value)

  saveToServer: ->
    $.post '/users/save_settings', settings: JSON.stringify({
      showIcon: @read("showIcon")
      show_default_value: @read("show_default_value")
      show_fk_icon: @read("show_fk_icon")
      show_not_null: @read("show_not_null")
      lineColor: @read("lineColor")
      show_fk_icon: @read("show_fk_icon")
      show_not_null: @read("show_not_null")
      show_default_value: @read("show_default_value")
      invert_line_direction: @read("invert_line_direction")
      language: @read("language")
    })
    return

class MemoryImpl
  constructor: (@_defaults) ->
    @tmp = {}

  read: (key) ->
    @tmp[key] or @_defaults[key]

  set: (key, value) ->
    @tmp[key] = value

class ChromeStorageImpl
  constructor: (@_defaults) ->

  read: (key) ->
    p = new $.Deferred
    chrome.storage.local.get key, (items) ->
      if chrome.runtime.lastError
        p.reject()
        return
      if items.length == 0
        p.resolve(@_defaults[key])
      else
        p.resolve items[0]
      return
    p

  set: (key, value) ->
    chrome.storage.local.set key, value

class LocalStorageImpl
  constructor: (@_defaults) ->

  read: (key) ->
    item = localStorage.getItem(key)
    if item is null
      @_defaults[key]
    else
      item

  set: (key, value) ->
    localStorage.setItem(key, value)
