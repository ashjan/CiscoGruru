class dbdesigner.views.NoteView extends dbdesigner.views.TrackableView
  tagName: "div"
  className: "entity-note"

  events:
    "click":             "onClick"
    "dblclick":          "onDoubleClick"
    "keydown textarea":  "onKeyDown"
    "click span.save":   "onSaveEditClicked"
    "click span.cancel": "onCancelEditClicked"
    "click span.delete": "onDeleteNoteClicked"
    "contextmenu":       "onContextMenu"

  initialize: ->
    super()
    @template = HandlebarsTemplates['note']
    @listenTo(@model, "destroy", @onModelDestroy)
    @listenTo(@model, "change", @onModelChange)
    return

  onModelDestroy: ->  
    # inform trackable_view
    @_viewWillRemove()
    # remove calls stopListening
    @remove()
    return

  onModelChange: (model, options) ->
    @_setCoordsFromModel()
    @_position_changed(@model.get("left"), @model.get("top"))
    @_dimensions_changed(@model.get("width"), @model.get("height"))
    @$("span.content").text(@model.get("content"))
    return

  render: ->
    @_setCoordsFromModel()
    @_position_changed(@model.get("left"), @model.get("top"))
    @_dimensions_changed(@model.get("width"), @model.get("height"))
    @$el.html @template(@model.toJSON())
    @$el.css position: "absolute"
    @$el.draggable
      containment: "window"
      scroll: true
      stack: ".entity-note,.entity-table"
      opacity: 0.8
      drag: @onDrag
      start: @onDragStart
      stop: @onDragStop
      live: true
      alsoDrag: ".selected"
    @$el.resizable
      handles: "se"
      minWidth: 150
      minHeight: 100
      alsoResize: @$("textarea")
      stop: @onResizeableStop
    this

  onResizeableStop: (event, ui) =>
    width = @$el.width()
    height = @$el.height()
    app.addCommand(Command::NOTE_RESIZE, {
      idx: @model.get("idx")
      from_width: @model.get("width")
      from_height: @model.get("height")
      to_width: width
      to_height: height
    })
    @_resizeTextarea()
    true

  onSaveEditClicked: =>
    content = @$("textarea").val()
    app.addCommand(Command::NOTE_CONTENT, {
      idx: @model.get("idx")
      old_content: @model.get("content")
      new_content: content
    })
    @$("span.content").text(content)
    @_exitEditMode()
    return

  onCancelEditClicked: =>
    @_exitEditMode()
    return

  onDeleteNoteClicked: ->
    app.addCommand(Command::NOTE_DESTROY, @model.toJSON())
    return

  onClick: (event) =>
    onTheadClick: (event) =>
    if event.shiftKey
      app.schemaView.toggleSelectionOfView(this)
    return

  onDoubleClick: (e) =>
    app.schemaView.bringViewToTop this
    @$("textarea").val @model.get("content")
    @$("textarea").show()
    @$("span.content").hide()
    @_resizeTextarea()
    @$(".ops").show()
    @$("textarea").select()
    return

  onKeyDown: (e) =>
    if e.keyCode == 27
      @onCancelEditClicked()
    if e.keyCode == 13 and e.shiftKey
      @onSaveEditClicked()
      return false
    return true

  onContextMenu: (e) =>
    app
      .schemaView
      .notePopupMenu
      .setTargetIdx(@model.get_idx())
      .show(e.pageX, e.pageY)
    e.stopPropagation()
    e.preventDefault()
    return

  _exitEditMode: ->
    @$("textarea").hide()
    @$("span.content").show()
    @$(".ops").hide()
    return

  _setCoordsFromModel: ->
    @$el.css
      left: @model.get("left")
      top: @model.get("top")
      width: @model.get("width")
      height: @model.get("height")
    return

  _resizeTextarea: =>
    @$("textarea").css
      width: @$el.width() - 10
      height: @$el.height() - 20