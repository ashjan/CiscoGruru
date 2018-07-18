class @NoteContent extends @Command
  _apply_command: (is_forward) ->
    note = app.schema.notes.findWhere idx: @data.idx
    if is_forward
      note?.set content: @data.new_content
    else
      note?.set content: @data.old_content
    return

  description: -> "Note content changed"