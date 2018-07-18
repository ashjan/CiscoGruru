class @NoteCreate extends @Command
  _apply_command: (is_forward) ->
    is_forward = !is_forward if @type is @NOTE_DESTROY
    if is_forward
      @data.idx = @schema.addNote(@data)
    else
      note = @schema.notes.findWhere idx: @data.idx
      note?.destroy()
    app.schemaView.canvasView.refresh()
    return

  description: -> "Note created"
