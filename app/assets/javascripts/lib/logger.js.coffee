class @Logger
  info: (args...) ->
    unless renv is 'production'
      console?.info "[INF] #{args[0]}"

  warn: (args...) ->
    unless renv is 'production'
      console?.warn "[WRN] #{args[0]}"

  error: (args...) ->
    unless renv is 'production'
      console?.error "[ERR] #{args[0]}"

  debug: (args...) ->
    unless renv is 'production'
      console?.debug "[DBG] #{args[0]}"

  _log: (str, kaller) ->
    unless renv is 'production'
      console?.log "#{str}"
      if $(".debug").length > 0
        $debug = $(".debug").get(0)
        x = $(".debug").text()
        x += str + "\n"
        $(".debug").text(x)
        $debug.scrollTop = $debug.scrollHeight
    return

