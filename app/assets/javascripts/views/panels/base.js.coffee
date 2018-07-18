class dbdesigner.views.panels.Base extends Backbone.View
  events:
    "click span.panel-caption": "onCaptionClicked"
    "click i": "onCaptionClicked"

  initialize: ->
    @open = true

  onCaptionClicked: ->
    if @open
      app.settings.set "panel#{@panelName}Open", false
      @_hideBody()
      @open = false
    else
      app.settings.set "panel#{@panelName}Open", true
      @_showBody()
      @open = true
    return

  _hideBody: ->
    # @$(".panel-body").stop(true, true).slideUp ->
    @$(".panel-body").hide()
    if $("body").hasClass("rtl")
      arrow_class = "icon-left-open"
    else
      arrow_class = "icon-right-open"
    @$(".panel-header>i")
      .removeClass("icon-down-open")
      .addClass(arrow_class)
    app.sidebarView.refreshChrome()
    return

  _showBody: ->
    # @$(".panel-body").stop(true, true).slideDown ->
    @$(".panel-body").show()
    @$(".panel-header>i")
      .removeClass("icon-right-open")
      .removeClass("icon-left-open")
      .addClass("icon-down-open")
    app.sidebarView.refreshChrome()
    return

  render: ->
    @$el.html @template(this)
    if app.settings.read("panel#{@panelName}Open") == "false"
      @open = false
      @_hideBody()
    this
