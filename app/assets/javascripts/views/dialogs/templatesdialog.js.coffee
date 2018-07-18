class dbdesigner.views.TemplatesDialog extends dbdesigner.views.DialogView
  width: 520
  height: 320
  caption: "dialog.templates"
  contentClass: "vertical-scroll"

  dialog_events:
    "click button.close": "closeButtonClicked"
    "click a": "onSchemaClick"

  initialize_dialog: ->
    @contents = HandlebarsTemplates['shared/loading']
    $.get("/api/v1/schemas/templates").done (r) =>
      @contents = HandlebarsTemplates['dialogs/template_dialog']
      @model = r
      @render()

  onSchemaClick: (e) =>
    app.router.navigate($(e.currentTarget).attr('href'), {trigger: true})
    @close()
    false

  schemas: ->
    _(@model).map (schema) ->
      title = schema.title || 'untitled'
      updated_at = new Date(schema.updated_at).toGMTString()
      return {
        id: schema.id
        title: title
        updated_at: updated_at
        description: schema.description
        database: schema.db
      }

dbdesigner.DialogRegistry.registerDialog "templates", dbdesigner.views.TemplatesDialog
