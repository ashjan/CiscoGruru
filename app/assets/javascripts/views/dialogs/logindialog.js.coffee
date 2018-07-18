class dbdesigner.views.LoginDialog extends dbdesigner.views.DialogView
  width: 400
  height: 220
  caption: "dialog.login"

  dialog_events:
    "click button.close": "closeButtonClicked"
    "click button.login-button": "onLoginClick"

  initialize_dialog: ->
    @contents = HandlebarsTemplates['dialogs/login_dialog']

  onLoginClick: =>
    #@$('div.contents').html templates.loading.render()
    # @$('button.login-button').prop "disabled", true
    @hideAlert()
    $login_button = @$("button.login-button")
    $login_button.prop('disabled', true)
    xhr = $.post '/sessions.json',
      email: @$("#email").val()
      password: @$("#password").val()
    xhr.always =>
      $login_button.prop('disabled', false)
    xhr.done (r) =>
      if r.status is "success"
        app.user.set
          login: true
          username: r.user.username
          email: r.user.email
        @close()
      else
        # console.log "LOGIN FAILED"
        @showAlert("Wrong username or password")
      return
    xhr.fail =>
      console.log "XHR FAILED"
    return

dbdesigner.DialogRegistry.registerDialog "login", dbdesigner.views.LoginDialog
