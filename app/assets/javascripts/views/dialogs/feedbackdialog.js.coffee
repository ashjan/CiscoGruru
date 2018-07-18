class dbdesigner.views.FeedbackDialog extends dbdesigner.views.DialogView
  width: 400
  height: 250
  caption: "dialog.feedback"

  dialog_events:
    "click button.close": "closeButtonClicked"
    "click button.send": "sendClicked"

  initialize_dialog: ->
    @contents = HandlebarsTemplates['dialogs/feedback_dialog']

  sendClicked: =>
    $button = @$("button.send-feedback")
    $button.prop('disabled', true)

    client_info =
      wwidth: $(window).width()
      wheight: $(window).height()
      swidth: screen.width
      sheight: screen.height
    for k,v of window.navigator
      client_info[k] = v
    delete client_info.geolocation
    delete client_info.mimeTypes
    delete client_info.plugins
    xhr = $.post '/feedbacks',
      subject: @$('#subject').val()
      message: @$('#message').val()
      client_info: JSON.stringify(client_info)
    xhr.done =>
      @$('#message').val('')
      @showNotice("Your message has been saved")
    xhr.always =>
      $button.prop('disabled', false)

dbdesigner.DialogRegistry.registerDialog 'feedback', dbdesigner.views.FeedbackDialog
