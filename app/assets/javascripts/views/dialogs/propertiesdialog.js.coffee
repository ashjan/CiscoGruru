class dbdesigner.views.PropertiesDialog extends dbdesigner.views.DialogView
  width: 500
  height: 320
  caption: "dialog.properties"
  windowClass: "properties"

  dialog_events:
    "click button.close": "closeButtonClicked"
    "click button.save": "saveButtonClicked"
    "click button.delete": "deleteButtonClicked"

  initialize_dialog: ->
    @contents = HandlebarsTemplates['dialogs/properties_dialog']
    @model = app.schema

  saveButtonClicked: =>
    app.schema.set("title", @$("input.schema-title").val())
    app.schema.set("template", @$("input#save-as-template").is(":checked"))
    app.schema.saveSchema()
    @close()
    this

  deleteButtonClicked: =>
    return unless confirm Handlebars.helpers.t('alerts.delete_schema')
    app.schema.destroy
      success: (model, response) =>
        app.sidebarView.hide()
        app.schema.resetSchema()
        app.showNotification "Schema deleted"
        @close()
      error: (model, response) =>
        app.showAlert Handlebars.helpers.t('alerts.server_error')
        @close()
    this

  title: ->
    app.schema.get 'title'

  isTemplate: ->
    if app.schema.get 'template'
      "checked"
    else
      ""

dbdesigner.DialogRegistry.registerDialog "properties", dbdesigner.views.PropertiesDialog

