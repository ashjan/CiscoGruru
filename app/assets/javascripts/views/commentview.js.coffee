class dbdesigner.views.CommentView extends Backbone.View
  events:
    "click .delete-comment": "onDeleteClicked"
  initialize: ->
    @template = HandlebarsTemplates['comment']

  render: ->
    @$el.html @template(this)
    this

  onDeleteClicked: =>
    return unless confirm "Do you want to delete this comment?"
    @model.destroy
      success: =>
        @$el.remove()
        return
      error: =>
        app.showAlert Handlebars.helpers.t('alerts.server_error')
    return

  commenter: ->
    @model.get("commenter")

  avatar: ->
    @model.get("avatar")

  contents: ->
    @model.get("contents")

  own_comment: ->
    @model.get("own_comment")