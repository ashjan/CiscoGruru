class @TableRename extends @Command
  _apply_command: (is_forward) ->
    table = app.schema.tables.findWhere idx: @data.idx
    if is_forward
      table?.set("name", @data.new_name)
      table?.set("comment", @data.new_comment)
      app.schema.updateForeignTableName @data.old_name, @data.new_name
    else
      table?.set("name", @data.old_name)
      table?.set("comment", @data.old_comment)
      app.schema.updateForeignTableName @data.new_name, @data.old_name
    return

  description: -> "Table renamed"