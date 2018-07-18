class @NoteResize extends @Command
  _apply_command: (is_forward) ->
    note = app.schema.notes.findWhere idx: @data.idx
    if is_forward
      note?.set
        width: @data.to_width
        height: @data.to_height
    else
      note?.set
        width: @data.from_width
        height: @data.from_height
    return

  description: -> "Note resized"
