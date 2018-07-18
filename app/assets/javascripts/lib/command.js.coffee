class @Command
  @::NOTE_CREATE   = 10
  @::NOTE_MOVE     = 11
  @::NOTE_RESIZE   = 12
  @::NOTE_CONTENT  = 13
  @::NOTE_DESTROY  = 14
  @::TABLE_CREATE  = 20
  @::TABLE_MOVE    = 21
  @::TABLE_DESTROY = 22
  @::TABLE_RENAME  = 23
  @::TABLE_SORT    = 24
  @::TABLE_CHANGE  = 25
  @::FIELD_CREATE  = 30
  @::FIELD_CHANGE  = 31
  @::FIELD_DESTROY = 32
  @::SCHEMA_SORT   = 40
  @::ENTITY_MOVE   = 50

  constructor: (@type, @data, @schema) ->
    @created_at = new Date
    @data.scrollTop = $("div.canvas-container").scrollTop()
    @data.scrollLeft = $("div.canvas-container").scrollLeft()
    return

  toJSON: ->
    type: @type
    data: @data

  apply_command: ->
    @_scroll()
    @_apply_command(true)

  take_back_command: ->
    @_scroll()    
    @_apply_command(false)

  _scroll: ->
    $("div.canvas-container").scrollTop @data.scrollTop
    $("div.canvas-container").scrollLeft @data.scrollLeft
    return

  _apply_command: ->
    throw "Abstract method called"
    return
