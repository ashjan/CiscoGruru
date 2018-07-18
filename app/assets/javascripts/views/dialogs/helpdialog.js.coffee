class dbdesigner.views.HelpDialog extends dbdesigner.views.DialogView
  width: 500
  height: 320
  caption: "dialog.help"
  contentClass: "vertical-scroll"

  dialog_events:
    "click button.close": "closeButtonClicked"

  initialize_dialog: ->
    @contents = HandlebarsTemplates['dialogs/help_dialog']

dbdesigner.DialogRegistry.registerDialog "help", dbdesigner.views.HelpDialog
