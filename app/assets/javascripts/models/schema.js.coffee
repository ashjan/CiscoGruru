class dbdesigner.models.Schema extends Backbone.Model
  defaults:
    title: 'Untitled'
    db: 'generic'
    template: false

  urlRoot: "/api/v1/schemas/"
  url: ->
    if @id is undefined
      @urlRoot
    else
      @urlRoot + @id

  initialize: ->
    @notes = new dbdesigner.collections.Notes
    @tables = new dbdesigner.collections.Tables
    @collaborators = new dbdesigner.collections.Collaborators({
      schema: this
      })
    @comments = new dbdesigner.collections.Comments({
      schema: this
      })
    @_entity_idx = 0
    @loading = false
    @sorting = false
    @datatypes = dbdesigner.datatypes['generic']
    return

  is_owner: ->
    @get "is_owner"

  saveToLocalStorage: =>
    localStorage['unsaved-schema'] = JSON.stringify(@serialize())

  has_unsaved_schema: ->
    typeof localStorage['unsaved-schema'] isnt 'undefined'

  load_unsaved_schema: ->
    @parse
      status: 'success'
      schema_data: localStorage['unsaved-schema']

  parse: (response) ->
    @_cleanUp()

    if response.status == "fail"
      alert(response.message)
      return
    rdata = $.parseJSON(response.schema_data)
    @set("db", rdata.db)
    @set("title", rdata.title)
    @set("template", rdata.template)
    if rdata.db
      @datatypes = dbdesigner.datatypes[rdata.db]
    else
      @datatypes = dbdesigner.datatypes.generic
    @addNote(note) for note in rdata.notes
    @addTable(table) for table in rdata.tables
    # @addTables rdata.tables
    delete response.schema_data
    return response

  resetSchema: (title = "Untitled", db = "generic") ->
    @_cleanUp()
    @clear()
    @set("title", title)
    @set("db", db)
    @datatypes = dbdesigner.datatypes[db]
    @collaborators.reset()
    @comments.reset()
    @_entity_idx = 0
    app.clearUndoStack()
    app.router.navigate "schema/new"

  _cleanUp: ->
    app.schemaView.canvasView.clearLines()
    while note = @notes.pop()
      note.destroy()
    while table = @tables.pop()
      table.destroy()
    return

  _getRandomInt: (min, max) ->
    Math.floor(Math.random() * (max - min)) + min

  _get_entity_idx: ->
    @_getRandomInt(0, 1000) * 10000 + @_entity_idx++

  findField: (model_idx) ->
    for table in @tables.models
      for field in table.get("fields").models
        if field.get("idx") == model_idx
          return field
    return

  updateForeignTableName: (old_table_name, new_table_name) ->
    for table in @tables.models
      for field in table.get("fields").models
        if field.get("fk_table") == old_table_name
          field.set("fk_table", new_table_name)
    return

  updateForeignFieldName: (table_name, old_field_name, new_field_name) ->
    for table in @tables.models
      for field in table.get("fields").models
        if field.get("fk_table") is table_name
          if field.get("fk_field") is old_field_name
            field.set("fk_field", new_field_name)
    return

  addNote: (noteData) ->
    note = @notes.add(noteData)
    if !note.get("idx")
      note.set("idx", @_get_entity_idx())
    else if note.get("idx") < 10000
      note.set("idx", @_get_entity_idx())
    note.get("idx")

  removeNote: (note) ->
    @notes.remove(note)

  addTable: (t) ->
    table = new dbdesigner.models.Table
      left: t.left
      top: t.top
      name: t.name
      comment: t.comment
      idx: t.idx
      color: t.color
    table.addFields t.fields
    if !table.get("idx")
      table.set("idx", @_get_entity_idx())
    else if table.get("idx") < 10000
      table.set("idx", @_get_entity_idx())
    @tables.add table
    table.get("idx")

  addTables: (tables) ->
    _tables = []
    for t in tables
      table = new dbdesigner.models.Table
        left: t.left
        top: t.top
        name: t.name
        comment: t.comment
        idx: t.idx
        color: t.color
      table.addFields t.fields
      if !table.get("idx")
        table.set("idx", @_get_entity_idx())
      else if table.get("idx") < 10000
        table.set("idx", @_get_entity_idx())
      _tables.push(table)
    @tables.add _tables
    return

  serialize: ->
    @serializeForDb(@get("db"))

  serializeForDb: (database) ->
    {
      title: @get("title")
      notes: @notes.toJSON()
      tables: @tables.toJSON()
      db: database
    }

  saveSchemaAs: (title) ->
    @unset 'id', silent: true
    @set "title", title
    @set "template", false
    @collaborators.reset()
    @comments.reset()
    @saveSchema(false)

  saveSchema: (replace=true) ->
    NProgress.start()
    defer = new $.Deferred()
    @loading = true
    if @id is undefined
      newSchema = true
      app.logger.info "new schema"
    @set("schema", {
      title: @get("title"),
      template: @get("template"),
      db: @get("db"),
      schema_data: JSON.stringify(@serialize())
      })
    @save {},
      success: =>
        @loading = false
        @tables.trigger "change"
        app.clearUndoStack()
        app.showNotification("Schema has been saved")
        app.schemaView.canvasView.refresh()
        if newSchema
          app.router.navigate("schema/#{@id}", replace: replace)
        defer.resolve()
        return
      error: (model, response, options) =>
        @loading = false
        if response?.responseJSON?.message
          app.showAlert response.responseJSON.message
        else
          app.showAlert Handlebars.helpers.t('alerts.server_error')
        defer.reject()
        return
    defer.always -> NProgress.done()
    defer

  loadVersion: (id, version_id) ->
    NProgress.start()
    @loading = true
    defer = new $.Deferred()
    @id = id
    # @collaborators.reset()
    # @comments.reset()
    @fetch
      data: $.param({version_id: version_id})
      success: =>
        @loading = false
        # @tables.trigger "change:versions"
        if renv is 'production'
          ga('send', 'pageview', "/designer/schema/#{id}")
        # @collaborators.fetch()
        # if @get("template")
        # @comments.fetch()
        @trigger("change:versions")
        defer.resolve()
      error: =>
        @loading = false
        app.router.navigate "/"
        app.logger.error "load error!"
        defer.reject()
    defer.always -> NProgress.done()
    defer

  loadSchema: (id) ->
    NProgress.start()
    @loading = true
    defer = new $.Deferred()
    @id = id
    @collaborators.reset()
    @comments.reset()
    app.logger.info "LoadSchema start"
    @fetch
      success: =>
        if @tables.every((t) -> t.get("left") is 100)
          if @tables.every((t) -> t.get("top") is 100)
            app.logger.info "Autosort"
            app.schemaView.sortPositions()
        @loading = false
        @tables.trigger "change"
        if renv is 'production'
          ga('send', 'pageview', "/designer/schema/#{id}")
        @collaborators.fetch()
        # if @get("template")
        @comments.fetch()
        defer.resolve()
      error: =>
        @loading = false
        app.router.navigate "/"
        app.logger.error "load error!"
        defer.reject()
    defer.always ->
      NProgress.done()
      _.delay ->
        app.logger.info "Deferred refresh"
        app.schemaView.canvasView.refresh()
      , 1000
    defer
