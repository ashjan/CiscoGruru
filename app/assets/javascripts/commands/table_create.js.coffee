class @TableCreate extends @Command
  _apply_command: (is_forward) ->
    is_forward = !is_forward if @type is @TABLE_DESTROY
    if is_forward
      # @schema.tables.add(new dbdesigner.models.Table({
      #   top: $("div.canvas-container").scrollTop() + 10
      #   left: $("div.canvas-container").scrollLeft() + 10
      # }))
      unless @data.fields
        @data.fields = []
      idx = @schema.addTable(@data)
      @data.idx = idx unless @data.idx
    else
      table = @schema.tables.findWhere idx: @data.idx
      table?.destroy()
    app.schemaView.canvasView.refresh()
    return

  description: -> "Table created"
