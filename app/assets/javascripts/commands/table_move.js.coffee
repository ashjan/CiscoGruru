class @TableMove extends @Command
  _apply_command: (is_forward) ->
    table = app.schema.tables.findWhere idx: @data.idx
    if is_forward
      table?.set
        left: @data.to_left
        top: @data.to_top
    else
      table?.set
        left: @data.from_left
        top: @data.from_top
    app.schemaView.canvasView.refresh()
    return

  description: -> "Table moved"