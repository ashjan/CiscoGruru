class dbdesigner.views.SaveAsDialog extends dbdesigner.views.DialogView
  width: 400
  height: 240
  caption: "dialog.saveas"

  dialog_events:
    "click button.close": "closeButtonClicked"
    "click button.save": "saveButtonClicked"

  initialize_dialog: ->
    @contents = HandlebarsTemplates['dialogs/saveas_dialog']
    @model = app.schema

  saveButtonClicked: =>
    app.schema.saveSchemaAs(@$("input.schema-title").val())
    @close()
    this

  title: ->
    app.schema.get 'title'

dbdesigner.DialogRegistry.registerDialog "saveas", dbdesigner.views.SaveAsDialog

