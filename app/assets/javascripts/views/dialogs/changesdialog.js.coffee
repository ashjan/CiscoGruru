class dbdesigner.views.ChangesDialog extends dbdesigner.views.DialogView
  width: 500
  height: 320
  caption: "dialog.help_changelog"
  contentClass: "vertical-scroll"

  dialog_events:
    "click button.close": "closeButtonClicked"

  initialize_dialog: ->
    @contents = HandlebarsTemplates['dialogs/changes_dialog']

dbdesigner.DialogRegistry.registerDialog "changes", dbdesigner.views.ChangesDialog

