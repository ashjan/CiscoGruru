class dbdesigner.views.TrackableView extends Backbone.View
  initialize: ->
    @left = 0
    @top = 0
    @width = 0
    @height = 0

  _position_changed: (@left, @top) ->
    @trigger "change"
    $("body").trigger("designer:recalculate_canvas_size")
    return

  _dimensions_changed: (@width, @height) ->
    @trigger "change"
    $("body").trigger("designer:recalculate_canvas_size")
    return

  _viewWillRemove: ->
    @trigger "remove"
    $("body").trigger("designer:recalculate_canvas_size")
    return

  onDragStart: (event, ui) =>
    app.vent.trigger('fieldWillMove')
    app.schemaView.viewDragging this
    true

  onDragStop: (event, ui) =>
    if ui.position.top < 36
      ui.position.top = 36
    app.schemaView.moveView this, ui.position.left - @model.get("left"), ui.position.top - @model.get("top")
    app.vent.trigger 'fieldMoved'
    true

  onDrag: (event, ui) =>
    if event.shiftKey
      ui.position =
        top: Math.round(ui.position.top / 10) * 10
        left: Math.round(ui.position.left / 10) * 10
    return

  move: (@left, @top) ->
    @$el.css
      left: @left + "px"
      top: @top + "px"
    @trigger "change"
    return
