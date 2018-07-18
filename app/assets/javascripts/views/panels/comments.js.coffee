class dbdesigner.views.panels.Comments extends dbdesigner.views.panels.Base
  events:
    "click button.refresh": "onRefreshClicked"
    "click button.send-comment": "onSendClicked"

  panelName: "Comments"

  initialize: (options) ->
    super()
    @events = _.extend({}, dbdesigner.views.panels.Base::events, @events)
    @template = HandlebarsTemplates['panels/comments_panel']
    @listenTo(app.schema.comments, "add", @onNewComment)
    @listenTo(app.schema.comments, "reset", @onCommentsReset)
    this

  onNewComment: (model) =>
    cv = new dbdesigner.views.CommentView
      model: model
    @$("div.comment-list").prepend(cv.render().el)

  onCommentsReset: =>
    @$("div.comment-list").empty()

  onRefreshClicked: =>
    return unless app.schema.id
    @$(".icon-spin3").toggleClass("animate-spin")
    app.schema.comments.fetch
      success: =>
        @$(".icon-spin3").removeClass("animate-spin")
      error: =>
        @$(".icon-spin3").removeClass("animate-spin")
    return

  onSendClicked: =>
    unless app.user.get("login")
      alert "You must first login"
      return
    contents = @$("textarea.new-comment-content").val()
    app.schema.comments.create({
      commenter: app.user.get("username")
      contents: contents
      }, {
        wait: true
        error: ->
          app.showAlert Handlebars.helpers.t('alerts.server_error')
        })
    @$("textarea.new-comment-content").val('')
