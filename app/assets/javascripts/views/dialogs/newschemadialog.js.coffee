class dbdesigner.views.NewSchemaDialog extends dbdesigner.views.DialogView
  width: 550
  height: 400
  caption: "dialog.new_schema"
  # contentClass: "vertical-scroll"

  dialog_events:
    "click button.close": "closeButtonClicked"
    "click button.create-schema": "createSchemaButtonClicked"

  initialize_dialog: ->
    @contents = HandlebarsTemplates['dialogs/new_schema_dialog']

  createSchemaButtonClicked: ->
    # app.schema.resetSchema(@$("input.schema-title").val(), "generic")
    app.schema.resetSchema(@$("input.schema-title").val(), @$(".new-schema-database").val())
    @close()
    return

dbdesigner.DialogRegistry.registerDialog "new", dbdesigner.views.NewSchemaDialog
