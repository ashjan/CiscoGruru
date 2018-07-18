class dbdesigner.views.ShareDialog extends dbdesigner.views.DialogView
  width: 580
  height: 430
  caption: "dialog.share"
  windowClass: "share"

  dialog_events:
    "click button.invite": "inviteButtonClicked"
    "click i.delete-collaborator": "deleteCollaboratorClicked"
    "click button.close": "closeButtonClicked"

  initialize_dialog: ->
    @contents = HandlebarsTemplates['dialogs/share_dialog']
    @model = app.schema

  inviteButtonClicked: ->
    #xhr = $.post "/api/v1/schemas/#{app.schema.id}/collaborators", {
    #  email: @$("#share-email").val()
    #}
    #xhr.done (r) =>
    #  @render()
    app.schema.collaborators.create({
      email: @$("#share-email").val()
      send_invitation_mail: @$("#send-invitation-email").is(":checked")
      access_mode: @$("#share-options").val()
      }, {
        wait: true
        success: =>
          @render()
          # @showNotice "Added collaborator"
        error: (model, response, options) =>
          @showAlert response.responseJSON.message
        })

  deleteCollaboratorClicked: (e) =>
    c = app.schema.collaborators.findWhere(email: $(e.target).data("email"))
    c.destroy
      success: =>
        @render()
      error: ->
        app.showAlert Handlebars.helpers.t('alerts.server_error')
    # app.schema.collaborators.remove c
    return

  collaborators: ->
    app.schema.collaborators.map (c) ->
      avatar: c.get("avatar")
      email: c.get("email")
      access_str: c.access_str()

dbdesigner.DialogRegistry.registerDialog "share", dbdesigner.views.ShareDialog
