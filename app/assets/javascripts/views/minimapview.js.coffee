class dbdesigner.views.MinimapView extends Backbone.View
  tagName: "div"
  className: "minimap"

  events:
    "mousedown":   "onMouseDown"
    "contextmenu": "onContextMenu"

  dynamic_sizing: true

  onContextMenu: (e) ->
    # @dynamic_sizing = !@dynamic_sizing
    e.preventDefault()

  initialize: (options) ->
    @template = HandlebarsTemplates['minimap']
    @minimap_scale = 25
    @canvas_width = 3840
    @canvas_height = 2400
    @schemaView = options.schemaView
    $(window).resize @resize_viewport
    $("div.canvas-container").scroll =>
      @reposition_viewport()
    $("body").on "designer:canvas_size_changed", @onCanvasSizeChanged

    # give viewport an initial size,
    # delay is needed because @el is undefined
    _.delay(@resize_viewport, 300)

    @listenTo(@schemaView, 'newnote', @onNewIcon)
    @listenTo(@schemaView, 'newtable', @onNewIcon)
    return

  onNewIcon: (view) =>
    v = new dbdesigner.views.MinimapIconView view: view, scale: @minimap_scale
    @$el.append v.render().el

  render: ->
    @$el.html @template()
    @$el.css('width', @canvas_width / @minimap_scale)
    @$el.css('height', @canvas_height / @minimap_scale)
    this

  onMouseDown: (e) ->
    if e.which isnt 1
      return
    offset = @$el.offset()
    x = e.pageX - offset.left - Math.round(@$(".minimap__viewport").width() / 2)
    y = e.pageY - offset.top - Math.round(@$(".minimap__viewport").height() / 2)
    $("div.canvas-container").animate
      scrollLeft: x * @minimap_scale
      scrollTop: y * @minimap_scale

  onCanvasSizeChanged: (e, size) =>
    @canvas_width = size.width
    @canvas_height = size.height
    @resize_viewport()
    return

  reposition_viewport: =>
    @$('.minimap__viewport').css
      top: Math.round($("div.canvas-container").scrollTop() / @minimap_scale) - 1 + "px"
      left: Math.round($("div.canvas-container").scrollLeft() / @minimap_scale) - 1 + "px"

  resize_viewport: =>
    if @dynamic_sizing
      @minimap_scale = (@canvas_width + @canvas_height) / (($("div.canvas-container").width() + $("div.canvas-container").height()) / 7)
      @$el.css('width', Math.round(@canvas_width / @minimap_scale))
      @$el.css('height', Math.round(@canvas_height / @minimap_scale))
      @$el.find('.minimap__icon').trigger("designer:change_scale", [@minimap_scale])
    @reposition_viewport()
    @$(".minimap__viewport").css
      width: Math.round($("div.canvas-container").width() / @minimap_scale) + "px"
      height: Math.round($("div.canvas-container").height() / @minimap_scale) + "px"
    return

  toggle: =>
    @$el.toggle()

  hide: =>
    @$el.hide()

  show: =>
    @$el.show()

  is_hidden: =>
    @$el.is(":hidden")

  change_scale: (scale) ->
    @minimap_scale = scale
    @$el.css('width', @canvas_width / @minimap_scale)
    @$el.css('height', @canvas_height / @minimap_scale)
    # @resize_viewport()

    # broadcast scale change to minimap icon views
    @$el.find('.minimap__icon').trigger("designer:change_scale", [scale])
    return

class dbdesigner.views.MinimapIconView extends Backbone.View
  tagName: "div"
  className: "minimap__icon"

  events:
    "designer:change_scale": "onScaleChange"

  initialize: (options) ->
    @view = options.view
    @scale = options.scale
    @listenTo(@view, "change", @render)
    @listenTo(@view, "remove", => @remove())

  render: =>
    @$el.css
      left: @_scaledPixel(@view.left)
      top: @_scaledPixel(@view.top)
      width: @_scaledPixel(@view.width)
      height: @_scaledPixel(@view.height)
    if @view.className is "entity-note"
      @$el.addClass "minimap__icon_type_note"
    else
      @$el.addClass "minimap__icon_type_table"
      @$el.attr "title", @view.table_name()
      @_setBackgroundColor()
    this

  onScaleChange: (event, scale) =>
    @scale = scale
    @render()

  _setBackgroundColor: ->
    if @view.model.has "color"
      @$el.css backgroundColor: @view.model.get("color")
    else
      @$el.css backgroundColor: '#ffffff'
    return

  _scaledPixel: (val) ->
    "#{Math.round(val / @scale)}px"
