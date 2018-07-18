class @Browser
  constructor: ->
    @support = {}
    if navigator.appVersion.indexOf("Win") isnt -1
      @os = 'windows'
    else if navigator.appVersion.indexOf("Mac") isnt -1
      @os = "macos"
    else if navigator.appVersion.indexOf("Linux") isnt -1
      @os = "linux"
    else
      @os = "unknown"
    @checkSupportedFeatures()
    return

  checkSupportedFeatures: ->
    a = document.createElement('a')
    @support.download = (typeof a.download != "undefined")
    a = document.createElement('a')
    a.style.cssText = 'filter:blur(2px);'
    @support.cssFilter = !(!!a.style.length && ((document.documentMode == undefined || document.documentMode > 9)))
    return

  setup: ->
    if (/MSIE\s([\d.]+)/.test(navigator.userAgent))
      version = new Number(RegExp.$1)
      if version <= 8
        $.fx.off = true
    $.ajaxSetup
      headers:
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    return
