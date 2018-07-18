class @TableSort extends @Command
  _apply_command: (is_forward) ->
    _sort = (order) =>
      _(order).each (o) =>
        app.schema.findField(o.idx)?.set("order", o.order)
    table = app.schema.tables.findWhere idx: @data.idx
    if is_forward
      _sort @data.new_sort_order
    else
      _sort @data.old_sort_order
    table?.get("fields").sort(silent: true)
    table?.trigger("sort")
    app.schemaView.canvasView.refresh()
    return

  description: -> "Table sorted"