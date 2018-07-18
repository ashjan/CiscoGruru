class dbdesigner.views.panels.Collaboration extends Backbone.View
  events:
    "click .enable-collaboration": "enableCollaborationClicked"
  initialize: (options) ->
    @template = HandlebarsTemplates['panels/collaboration_panel']
    this

  render: ->
    @$el.html @template.render(this)
    this

  enableCollaborationClicked: =>
    if app.collaboration
      app.disableCollaboration()
    else
      app.enableCollaboration()

  lightOn: =>
    @$("i.connection-light").addClass("active")
    @$("button.enable-collaboration>span").text("Disable Collaboration")
    return

  lightOff: =>
    @$("i.connection-light").removeClass("active")
    @$("button.enable-collaboration>span").text("Enable Collaboration")
    return