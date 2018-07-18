class dbdesigner.views.SchemaView extends Backbone.View

  events:
    "contextmenu .canvas-container": "onContextMenu"
    "mousedown .canvas-container": "onMouseDown"
    "mousemove .canvas-container": "onMouseMove"
    "mouseup .canvas-container": "onMouseUp"

  initialize: (options) ->
    @listenTo(@model.notes, "add", @newNote)
    @listenTo(@model.notes, "remove", @noteRemoved)
    @listenTo(@model.tables, "add", @newTable)
    @listenTo(@model.tables, "remove", @tableRemoved)
    @table_views = []
    @note_views = []
    @tableHeaderPopupMenu = new dbdesigner.views.PopupMenuView template_name: "table_popup"
    @notePopupMenu = new dbdesigner.views.PopupMenuView template_name: "note_popup"
    @canvasPopupMenu = new dbdesigner.views.PopupMenuView template_name: "canvas_popup"
    $("div.canvas-container")
      .append(@tableHeaderPopupMenu.render().el)
      .append(@notePopupMenu.render().el)
      .append(@canvasPopupMenu.render().el)
    $("body").on "designer:recalculate_canvas_size", =>
      @canvasView.recalculateCanvasSize()
    # $(document).bind "keydown", "tab", @onTabPressed
    # $(document).bind "keydown", "shift+tab", @onShiftTabPressed

    @dragging = false

    @selecting = false
    @selected_entities = []

    @selectionStart = {left: 0, top: 0}
    @selectionSize = {width: 0, height: 0}

    # @active_entity = null;
    return

  onTabPressed: (e) =>
    if @getActiveEntity() == null
      @setActiveEntity(@_find_view_with_idx(0))
    else
      @setActiveEntity(@_find_next_entity(@getActiveEntity()))
    e.preventDefault()
    e.stopPropagation()
    return

  onShiftTabPressed: (e) =>
    if @getActiveEntity() == null
      @setActiveEntity(@_find_view_with_idx(0))
    else
      @setActiveEntity(@_find_prev_entity(@getActiveEntity()))
    e.preventDefault()
    e.stopPropagation()
    return

  getActiveEntity: ->
    if @selected_entities.length > 0
      @selected_entities[0]
    else
      null

  setActiveEntity: (view) =>
    return if view is null
    @_clearSelectedList()
    @selected_entities = [view]
    # @active_entity?.$el.removeClass("active")
    # @active_entity = view
    view.$el.addClass("selected")
    return

  onContextMenu: (e) =>
    unless e.target is $("canvas#graph").get(0)
      return
    if @selecting
      e.stopPropagation()
      e.preventDefault()
      return
    @canvasPopupMenu.show(e.pageX, e.pageY)
    e.stopPropagation()
    e.preventDefault()
    return

  onMouseDown: (e) ->
    return if e.button isnt 0
    return unless $(e.target).hasClass("canvas")

    parentPos = $(".canvas-container").get(0).getBoundingClientRect()
    if e.shiftKey
      @selecting = true
      if !e.ctrlKey
        @_clearSelectedList()
      @selectionStart =
        left: e.pageX - parentPos.left + $(".canvas-container").scrollLeft()
        top: e.pageY - parentPos.top + $(".canvas-container").scrollTop()
    else
      @dragging = true
      @dragStart =
        left: e.pageX
        top: e.pageY

    e.stopPropagation()
    e.preventDefault()
    return

  onMouseMove: (e) ->
    return true if !@selecting and !@dragging
    parentPos = $(".canvas-container").get(0).getBoundingClientRect()
    if @selecting
      @selectionSize =
        width: e.pageX - @selectionStart.left - parentPos.left + $(".canvas-container").scrollLeft()
        height: e.pageY - @selectionStart.top - parentPos.top + $(".canvas-container").scrollTop()
      r = new Rect(@selectionStart.left, @selectionStart.top, @selectionSize.width, @selectionSize.height).normalize()
      _(@table_views).each (view, index) =>
        r2 = new Rect(view.model.get("left"), view.model.get("top"), view.$el.width(), view.$el.height()).normalize()
        if r.doesInclude r2
          view.$el.addClass("selected")
          @selected_entities.push(view)
        else
          @selected_entities = _(@selected_entities).reject (v) -> v.model == view.model
          view.$el.removeClass("selected")
      _(@note_views).each (view, index) =>
        r2 = new Rect(view.model.get("left"), view.model.get("top"), view.$el.width(), view.$el.height()).normalize()
        if r.doesInclude r2
          view.$el.addClass("selected")
          @selected_entities.push(view)
        else
          @selected_entities = _(@selected_entities).reject (v) -> v.model == view.model
          view.$el.removeClass("selected")
      @_renderSelection()
    else
      $elem = $(".canvas-container")
      sl = $elem.scrollLeft()
      st = $elem.scrollTop()
      #$elem.css 'visibility', 'hidden'
      $elem
        .scrollLeft(sl + @dragStart.left - e.pageX)
        .scrollTop(st + @dragStart.top - e.pageY)
      #$elem.css 'visibility', 'visible'
      @dragStart =
        left: e.pageX
        top: e.pageY
    return false

  onMouseUp: (e) ->
    return if !@selecting and !@dragging
    if @dragging
      @dragging = false
    else
      r = new Rect(@selectionStart.left, @selectionStart.top, @selectionSize.width, @selectionSize.height).normalize()
      _(@table_views).each (view, index) =>
        r2 = new Rect(view.model.get("left"), view.model.get("top"), view.$el.width(), view.$el.height()).normalize()
        if r.doesInclude r2
          view.$el.addClass("selected")
          @selected_entities.push(view)
      _(@note_views).each (view, index) =>
        r2 = new Rect(view.model.get("left"), view.model.get("top"), view.$el.width(), view.$el.height()).normalize()
        if r.doesInclude r2
          view.$el.addClass("selected")
          @selected_entities.push(view)
      @selecting = false
      @selectionStart = {left: 0, top: 0}
      @selectionSize = {width: 0, height: 0}
      @_renderSelection()
      e.stopPropagation()
      e.preventDefault()
    return

  selectAll: ->
    @_clearSelectedList()
    _(@table_views).each (view, index) =>
      view.$el.addClass("selected")
      @selected_entities.push(view)
    _(@note_views).each (view, index) =>
      view.$el.addClass("selected")
      @selected_entities.push(view)
    @selecting = false
    @selectionStart = {left: 0, top: 0}
    @selectionSize = {width: 0, height: 0}
    @_renderSelection()
    return

  selectNone: ->
    @_clearSelectedList()
    return

  deleteSelection: ->
    _(@selected_entities).each (v) ->
      if v.tagName is "table"
        v.onDeleteTable()
      else
        v.onDeleteNoteClicked()
    @_clearSelectedList()
    return

  # toggles the selected property of `view`
  toggleSelectionOfView: (view) ->
    if _.contains(@selected_entities, view)
      view.$el.removeClass("selected")
      @selected_entities = _(@selected_entities).reject (v) -> v.model == view.model
    else
      view.$el.addClass("selected")
      @selected_entities.push(view)
    return

  _clearSelectedList: ->
    @selected_entities = []
    $(".entity-table,.entity-note").removeClass("selected")
    return

  _renderSelection: ->
    r = new Rect(@selectionStart.left, @selectionStart.top, @selectionSize.width, @selectionSize.height)
    $(".selection").css r.normalize().pack()
    return

  renderPopupMenus: ->
    @tableHeaderPopupMenu.render()
    @notePopupMenu.render()
    @canvasPopupMenu.render()
    return

  newNote: (note, notes) =>
    noteView = new dbdesigner.views.NoteView model: note
    @trigger("newnote", noteView)
    $("div.canvas-container").append noteView.render().el
    @bringViewToTop(noteView)
    @note_views.push(noteView)
    this

  noteRemoved: (model) =>
    @selected_entities = _(@selected_entities).reject (v) -> v.model == model
    @note_views = _(@note_views).reject (v) -> v.model == model
    # if @active_entity?.model == model
    #   app.logger.info "active_entity is removed"
    #   @active_entity = null
    return

  newTable: (table, tables) =>
    tableView = new dbdesigner.views.TableView(model: table)
    @trigger("newtable", tableView)
    $("div.canvas-container").append tableView.render().el
    @bringViewToTop(tableView)
    @table_views.push(tableView)
    #app.log("table added: #{table.get("name")}")
    unless app.schema.loading == true
      @canvasView.refresh()
    return

  tableRemoved: (model) ->
    #view = _(@table_views).find (v) -> v.model == table
    @selected_entities = _(@selected_entities).reject (v) -> v.model == model
    @table_views = _(@table_views).reject (v) -> v.model == model
    #app.log("table removed: #{table.get("name")}")
    #app.log("table_views: #{@table_views}")
    # if @active_entity?.model == model
    #   app.logger.info "active_entity is removed"
    #   @active_entity = null
    return

  viewDragging: (view) ->
    unless _(@selected_entities).contains view
      @_clearSelectedList()
    return

  moveView: (view, x, y) ->
    idx_list = _(@selected_entities).map (e) -> e.model.get("idx")
    idx_list.push(view.model.get("idx"))
    idx_list = _.uniq(idx_list)
    app.addCommand Command::ENTITY_MOVE,
      idx_list: idx_list
      x: x
      y: y
    return true

  bringViewToTop: (view) ->
    view.$el.css('z-index', @findHighestZIndex())
    this

  _find_prev_entity: (view) ->
    idx = @_find_entity_index(view)
    app.logger.info "_find_prev_entity: #{idx}"
    if idx == -1
      view
    else
      idx = idx - 1
      if idx == -1
        idx = @_entity_count() - 1
      @_find_view_with_idx idx

  _find_next_entity: (view) ->
    idx = @_find_entity_index(view)
    if idx == -1
      view
    else
      idx = (idx + 1) % @_entity_count()
      @_find_view_with_idx idx

  _find_view_with_idx: (idx) ->
    if @_entity_count() == 0
      null
    else if idx < @table_views.length
      @table_views[idx]
    else
      @note_views[idx - @table_views.length]

  _find_entity_index: (view) ->
    match = (v) -> v == view
    idx = @table_views.findIndex match
    if idx isnt -1
      return idx
    idx = @note_views.findIndex match
    if idx isnt -1
      return idx + @table_views.length
    return -1

  _entity_count: ->
    @table_views.length + @note_views.length

  findHighestZIndex: ->
    zmax = 0
    $(".entity-table,.entity-note").each (idx, t) ->
      cur = parseInt($(t).css('z-index'))
      zmax = if cur > zmax then cur else zmax
    zmax + 1

  render: ->
    if renv == 'test'
      $el = $("<canvas />")
    else
      $el = $("canvas")
    @canvasView = new dbdesigner.views.CanvasView(model: @model, el: $el)
    @canvasView.render()
    #@$el.append(@canvasView.render().el)
    this

  sortPositions: =>
    positions = []
    _top = 50
    _left = 50
    _space = 40
    _maxHeight = 0
    _vertical_limit = $(window).width()
    _pack_tables = false
    _row_index = 0
    _row_count = 0
    sort_element = (view, index) =>
      if _left + view.$el.width() > _vertical_limit
        _left = 50
        _top += _maxHeight + _space
        _maxHeight = view.$el.height()
        _row_index = 0
        _row_count += 1
      if view.$el.height() > _maxHeight
        _maxHeight = view.$el.height()
      #view.move(_left, _top)
      m = view.model
      if _row_index < index
        # __top = positions[(positions.length - _row_index) / _row_count ]
        __top = _top
      else
        __top = _top
      positions.push({
        idx: m.get("idx")
        is_table: view.tagName is "table"
        from_left: m.get("left")
        from_top: m.get("top")
        to_left: _left
        to_top: __top
        })
      _left += view.$el.width() + _space
      _row_index += 1
    if @table_views.length > 20
      _vertical_limit = 1920 * 2
      _pack_tables = true
      # _space = 20
    _(@table_views).chain().sortBy (t) ->
        t.$el.height()
      .each sort_element
    _(@note_views).each sort_element
    app.addCommand Command::SCHEMA_SORT, positions: positions
    return
