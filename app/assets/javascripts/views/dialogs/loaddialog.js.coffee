class dbdesigner.views.LoadDialog extends dbdesigner.views.DialogView
  width: 550
  height: 400
  caption: "dialog.load_schema"
  contentClass: "vertical-scroll"

  dialog_events:
    "click button.close": "closeButtonClicked"
    "click a": "onSchemaClick"

  initialize_dialog: ->
    @contents = HandlebarsTemplates['shared/loading']
    $.get("/api/v1/schemas").done (response) =>
      @contents = HandlebarsTemplates['dialogs/load_dialog']
      @model = response
      @render()

  onSchemaClick: (e) =>
    app.router.navigate($(e.currentTarget).attr('href'), {trigger: true})
    @close()
    false

  schemas: ->
    _(@model.own_schemas).map (schema) ->
      title = schema.title || 'untitled'
      return {
        id: schema.id
        title: title
        updated_at: schema.updated_at
        database: schema.db
      }

  shared_schemas: ->
    _(@model.shared_schemas).map (schema) ->
      title = schema.title || 'untitled'
      return {
        id: schema.id
        title: title
        owner: schema.owner
        updated_at: schema.updated_at
      }

dbdesigner.DialogRegistry.registerDialog "load", dbdesigner.views.LoadDialog
