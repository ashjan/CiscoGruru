class @NoteMove extends @Command
  _apply_command: (is_forward) ->
    note = app.schema.notes.findWhere idx: @data.idx
    if is_forward
      note?.set
        left: @data.to_left
        top: @data.to_top
    else
      note?.set
        left: @data.from_left
        top: @data.from_top
    return

  description: -> "Note moved"
