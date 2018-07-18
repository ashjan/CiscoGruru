class dbdesigner.views.NotificationView extends Backbone.View
  @::NOTIFICATION_TIMEOUT = 5000

  tagName: 'div'
  className: 'notification'

  events:
    "click span.close": "onCloseClicked"

  initialize: (options) ->
    @template = HandlebarsTemplates['notification']
    @text = "..."
    @hideTimer = 0
    this

  onCloseClicked: =>
    @$el.slideUp()

  render: ->
    @$el.html @template(this)
    this

  showText: (text) ->
    @$el.removeClass('alert')
    @text = text
    @render()
    @show()
    this

  show: ->
    clearTimeout(@hideTimer)
    @$el.slideDown()
    @hideTimer = setTimeout =>
      @hide()
    , dbdesigner.views.NotificationView.prototype.NOTIFICATION_TIMEOUT
    this

  hide: ->
    @$el.slideUp()
    this

  text: ->
    @text