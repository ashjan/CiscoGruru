class @TableChange extends @Command
  _apply_command: (is_forward) ->
    table = app.schema.tables.findWhere idx: @data.idx
    if is_forward
      table?.set @data.to_values
    else
      table?.set @data.from_values
    app.schemaView.canvasView.refresh()
    return

  description: -> "Table changed"
