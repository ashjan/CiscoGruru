class dbdesigner.DialogRegistry
  @_dialogs: []

  @registerDialog: (name, klass) ->
    @_dialogs.push(name: name, klass: klass)
    return

  @getDialog: (dialogName) ->
    dialog = _(@_dialogs).find (e) -> e.name == dialogName
    if dialog
      return new dialog.klass
    else
      app.logger.warn "Can not load dialog #{dialogName}"
      return

class dbdesigner.DialogManager
  _activeDialogs: []

  constructor: ->
    @_exposeLayer = new dbdesigner.views.ExposeLayer
    $("body").append(@_exposeLayer.render().el)
    $(document).bind "keydown", "esc", (e) =>
      if @_activeDialogs.length > 0
        @closeModalDialogs()
      return
    $(window).resize @onWindowResize
    $(document).on "designer:expose_clicked", @closeModalDialogs
    @_showingDialog = false
    return

  onWindowResize: =>
    @centerDialogs()

  createDialog: (dialog) ->
    @_activeDialogs.push dialog

  removeDialog: (dialog) ->
    if @_showingDialog is false
      app.dialogManager.hideExpose()
    @_activeDialogs = _(@_activeDialogs).without dialog
    this

  showConfirmationDialog: (dialogName, callbacks) ->
    dialog = @showDialog(dialogName)
    dialog.setCallbacks callbacks
    dialog

  showDialog: (dialogName) =>
    app.logger.info "showDialog"
    @_showingDialog = true
    @closeModalDialogs()
    new_dialog = dbdesigner.DialogRegistry.getDialog(dialogName)
    return unless new_dialog
    $("body").append new_dialog.render().el
    @showExpose()
    @_showingDialog = false
    return new_dialog

  showExpose: ->
    if @_exposeLayer.$el.stop(true, true).is(":hidden")
      # $('body, html').css('overflow', 'hidden')
      @_exposeLayer.onWindowResize()
      @_exposeLayer.show()
    return

  hideExpose: ->
    # $('body, html').css('overflow', 'visible')
    @_exposeLayer.hide()

  closeModalDialogs: =>
    app.logger.info "closeModalDialogs"
    dialog.cancel() for dialog in @_activeDialogs
    return

  centerDialogs: ->
    dialog.center() for dialog in @_activeDialogs
    return

class dbdesigner.views.ExposeLayer extends Backbone.View
  tagName: "div"
  className: "bg"

  events:
    "click": "onClick"

  initialize: ->
    $(window).resize @onWindowResize

  onWindowResize: =>
    @$el.css
      width: $(window).width()
      height: $(window).height()

  onClick: =>
    $(document).trigger("designer:expose_clicked")
    return

  show: =>
    @$el.css opacity: 0
    @$el.show()
    $("div.app-container").addClass("blur")
    @$el.animate opacity: 0.6

  hide: =>
    $("div.app-container").removeClass("blur")
    @$el.fadeOut()

