class dbdesigner.views.AboutDialog extends dbdesigner.views.DialogView
  width: 440
  height: 300
  caption: "dialog.about"
  contentClass: "vertical-scroll"
  windowClass: "about-dialog"
  rightButtons: ->
    [
      caption: Handlebars.helpers.t('dialog.close')
      className: "close"
    ]
  hasBottomBar: true

  dialog_events:
    "click button.close": "closeButtonClicked"

  initialize_dialog: ->
    @contents = HandlebarsTemplates['dialogs/about_dialog']

dbdesigner.DialogRegistry.registerDialog "about", dbdesigner.views.AboutDialog
