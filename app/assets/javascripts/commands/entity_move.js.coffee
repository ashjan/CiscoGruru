class @EntityMove extends @Command
  _apply_command: (is_forward) ->
    _(@data.idx_list).each (idx) =>
      entity = app.schema.notes.findWhere idx: idx
      unless entity
        entity = app.schema.tables.findWhere idx: idx
      unless entity
        app.logger.error "NO ENTITY FOR: #{idx}"
      if is_forward
        entity?.set
          left: entity.get("left") + @data.x
          top: entity.get("top") + @data.y
      else
        entity?.set
          left: entity.get("left") - @data.x
          top: entity.get("top") - @data.y
    app.schemaView.canvasView.refresh()
    return

  description: -> "Entities moved (x: #{@data.x}, y: #{@data.y})"
