class dbdesigner.views.ShortcutsHelpDialog extends dbdesigner.views.DialogView
  width: 500
  height: 320
  caption: "dialog.shortcuts"
  windowClass: "shortcuts"
  contentClass: "vertical-scroll"

  dialog_events:
    "click button.close": "closeButtonClicked"

  initialize_dialog: ->
    @contents = HandlebarsTemplates['dialogs/shortcuts_dialog']
    # ⌘

  meta_icon: ->
    if app.browser.os is "macos"
      "⌘"
    else
      "Ctrl"

dbdesigner.DialogRegistry.registerDialog "shortcuts", dbdesigner.views.ShortcutsHelpDialog
