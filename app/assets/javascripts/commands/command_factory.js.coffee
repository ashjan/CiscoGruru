class @CommandFactory

  createCommand: (type, data) ->
    klass = switch type
      when Command::NOTE_CREATE then NoteCreate
      when Command::NOTE_MOVE then NoteMove
      when Command::NOTE_RESIZE then NoteResize
      when Command::NOTE_CONTENT then NoteContent
      when Command::NOTE_DESTROY then NoteCreate
      when Command::TABLE_CREATE then TableCreate
      when Command::TABLE_MOVE then TableMove
      when Command::TABLE_DESTROY then TableCreate
      when Command::TABLE_CHANGE then TableChange
      when Command::TABLE_RENAME then TableRename
      when Command::TABLE_SORT then TableSort
      when Command::FIELD_CREATE then FieldCreate
      when Command::FIELD_CHANGE then FieldChange
      when Command::FIELD_DESTROY then FieldCreate
      when Command::SCHEMA_SORT then SchemaSort
      when Command::ENTITY_MOVE then EntityMove
    if @schema
      schema = @schema
    else
      schema = app.schema
    return new klass(type, data, schema)
