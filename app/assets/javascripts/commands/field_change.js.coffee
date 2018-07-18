class @FieldChange extends @Command
  _apply_command: (is_forward) ->
    field = app.schema.findField(@data.idx)
    if is_forward
      field?.set @data.new_state
      app.schema.updateForeignFieldName @data.table_name, @data.old_state.name, @data.new_state.name
    else
      field?.set @data.old_state
      app.schema.updateForeignFieldName @data.table_name, @data.new_state.name, @data.old_state.name
    unless @data.new_state.fk_table
      field?.unset("fk_table", silent: true)
      field?.unset("fk_field", silent: true)
    app.schemaView.canvasView.refresh()
    return

  description: -> "Field changed"