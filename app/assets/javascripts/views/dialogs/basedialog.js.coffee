class dbdesigner.views.DialogView extends Backbone.View
  tagName: "div"
  className: "dialog"

  caption: "Dialog"
  leftButtons: -> []
  rightButtons: -> []

  contents: HandlebarsTemplates['shared/loading']
  hasBottomBar: false

  events:
    "click span.maximize": "maximizeClicked"
    "click span.close": "closeClicked"
    "click div.alert": "hideAlert"
    "click div.notice": "hideNotice"
    "keydown input": "onInputKeydown"

  initialize: ->
    @base_template = HandlebarsTemplates['dialogs/base_dialog']
    @_maximize_mode = "NORMAL"
    @initial_window_size =
      width: @width
      height: @height
    @initialize_dialog()
    # merge dialog events from child dialog with base events
    @events = _.extend({}, @events, @dialog_events)
    app.dialogManager.createDialog this

  initialize_dialog: ->
    this

  render: ->
    content_template = @contents
    @beforeRender()
    @$el.addClass @windowClass if @windowClass?
    @$el.html @base_template
      caption: if typeof @caption == "function" then @caption() else Handlebars.helpers.t(@caption)
      contents: content_template(this)
      leftButtons: @leftButtons()
      rightButtons: @rightButtons()
    @$el.find("div.contents").addClass @contentClass if @contentClass?
    @$el.css
      top: ($(window).height() - @height) / 2
      left: ($(window).width() - @width) / 2
      width: @width
      height: @height
    @repositionChrome()
    @afterRender()
    _.delay => @$("input[autofocus]").focus()
    this

  beforeRender: =>
  afterRender: =>


  showAlert: (alert_text) ->
    @$("div.alert")
      .text(alert_text)
      .show()
    @repositionChrome()
    this

  hideAlert: ->
    @$("div.alert").hide()
    @repositionChrome()
    this

  showNotice: (notice_text) ->
    @$("div.notice")
      .text(notice_text)
      .show()
    @repositionChrome()
    this

  hideNotice: ->
    @$("div.notice").hide()
    @repositionChrome()

  repositionChrome: ->
    height = @height
    if @hasBottomBar
      @$("div.bottombar").css "width", @width
      height -= 60
    else
      height -= 20
    $alert = @$('div.alert')
    if $alert.is(":visible")
      height -= $alert.outerHeight()
    $notice = @$('div.notice')
    if $notice.is(":visible")
      height -= $notice.outerHeight()
    @$("div.contents").css
      height: height
    this

  center: =>
    _.defer =>
      if @_maximize_mode == "MAXIMIZE"
        maxSize = @getMaxSize()
        @height = maxSize.height
        @width = maxSize.width
        @$el.css
          height: @height
          width: @width
      else
        @$el.css
          top: Math.floor(($(window).height() - @height) / 2)
          left: Math.floor(($(window).width() - @width) / 2)
      @repositionChrome()
    return

  close: ->
    app.dialogManager.removeDialog this
    @remove()
    @unbind()
    Backbone.View::remove.call this
    true

  cancel: ->
    app.logger.info "cancel"
    @close()

  getMaxSize: ->
    height: $(window).innerHeight() - 100
    width: $('body').innerWidth()

  _maximizeDialog: ->
    maxSize = @getMaxSize()
    @height = maxSize.height
    @width = maxSize.width
    @$el.css
      height: @height
      width: @width
    @repositionChrome()
    $('body, html').css('overflow', 'hidden')
    @$el.css
      top: 0 #Math.floor(($('body').innerHeight() - @height) / 2)
      left: 0 #Math.floor(($('body').innerWidth() - @width) / 2)
    @_maximize_mode = "MAXIMIZE"

  _restoreDialog: ->
    @_maximize_mode = "NORMAL"
    @width = @initial_window_size.width
    @height = @initial_window_size.height
    @$el.css
      height: @height
      width: @width
    @center()
    $('body, html').css('overflow', 'visible')
    @$el.css
      top: Math.floor(($(window).height() - @height) / 2)
      left: Math.floor(($(window).width() - @width) / 2)
    @repositionChrome()

  maximizeClicked: =>
    if @_maximize_mode == "NORMAL"
      @_maximizeDialog()
    else
      @_restoreDialog()
    return

  closeClicked: =>
    @close()

  closeButtonClicked: =>
    @close()
    return

  onInputKeydown: (e) =>
    if e.keyCode == 13
      @$("button[default-button]").click()
