class @SchemaSort extends @Command
  _apply_command: (is_forward) ->
    app.schema.sorting = true
    _(@data.positions).each (pos) =>
      if pos.is_table
        v = app.schema.tables.findWhere idx: pos.idx
      else
        v = app.schema.notes.findWhere idx: pos.idx
      if is_forward
        v?.set left: pos.to_left, top: pos.to_top
      else
        v?.set left: pos.from_left, top: pos.from_top
    app.schema.sorting = false
    app.schemaView.canvasView.refresh()
    return

  description: -> "Schema sorted"
