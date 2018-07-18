class dbdesigner.views.ConfirmationDialog extends dbdesigner.views.DialogView
  width: 450
  height: 160
  caption: "dialog.dirty_schema_confirmation"
  contentClass: "vertical-scroll"
  windowClass: "about-dialog"
  leftButtons: ->
    [
      caption: Handlebars.helpers.t("dialog.dirty_schema_confirmation_save_changes_button")
      className: "save-changes"
    ,
      caption: Handlebars.helpers.t("dialog.dirty_schema_confirmation_discard_changes_and_continue_button")
      className: "discard-changes"
    ]
  rightButtons: ->
    [
      caption: Handlebars.helpers.t('dialog.close')
      className: "close"
    ]
  hasBottomBar: true

  dialog_events:
    "click button.save-changes": "saveButtonClicked"
    "click button.discard-changes": "discardButtonClicked"
    "click button.close": "closeButtonClicked"

  initialize_dialog: ->
    @contents = HandlebarsTemplates['dialogs/dirty_schema_confirmation_dialog']

  saveButtonClicked: ->
    @close()
    @callbacks[0].call()
    return

  discardButtonClicked: ->
    @close()
    @callbacks[1].call()
    return

  setCallbacks: (callbacks) ->
    @callbacks = callbacks
    return

dbdesigner.DialogRegistry.registerDialog "dirty_schema_confirmation", dbdesigner.views.ConfirmationDialog
