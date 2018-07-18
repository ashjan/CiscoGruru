class dbdesigner.views.SettingsDialog extends dbdesigner.views.DialogView
  width: 400
  height: 220
  caption: "dialog.user_settings"

  dialog_events:
    "click button.save": "saveButtonClicked"
    "click button.close": "closeButtonClicked"

  initialize_dialog: ->
    @contents = HandlebarsTemplates['dialogs/settings_dialog']

  saveButtonClicked: =>
    # app.schema.set("title", @$("input.schema-title").val())
    # app.user.set("username", )
    app.user.saveProfile
      username: @$("input.username").val()
      email: @$("input.email").val()
      password: @$("input.password").val()
      password_confirmation: @$("input.password_confirmation").val()
    @close()
    this

  username: ->
    app.user.get 'username'

  email: ->
    app.user.get 'email'

dbdesigner.DialogRegistry.registerDialog "settings", dbdesigner.views.SettingsDialog
