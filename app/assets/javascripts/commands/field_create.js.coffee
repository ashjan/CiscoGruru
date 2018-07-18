class @FieldCreate extends @Command
  _apply_command: (is_forward) ->
    is_forward = !is_forward if @type is @FIELD_DESTROY
    if is_forward
      table = app.schema.tables.findWhere({idx: @data.table_idx})
      idx = table?.addField @data
      @data.idx = idx unless @data.idx
      table?.get("fields").sort(silent: true)
      table?.trigger("sort")
    else
      field = app.schema.findField(@data.idx)
      field?.destroy()
    app.schemaView.canvasView.refresh()
    return

  description: -> ""
