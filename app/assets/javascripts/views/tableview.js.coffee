class dbdesigner.views.TableView extends dbdesigner.views.TrackableView
  tagName: 'table'
  className: 'entity-table'
  attributes: -> "data-table-name": @model.get "name"

  events:
    "click img.edit-table":          "onEditTable"
    "click thead":                   "onTheadClick"
    "contextmenu thead":             "onTHeadContextMenu"
    "click span.cancel-edit-table":  "onCancelEditTable"
    "click span.delete-table":       "onDeleteTable"
    "click span.insert-field":       "onSpanAddField"
    "keydown input":                 "onInputKeydown"
    "click input.save-edit-table":   "onSaveEditTable"
    "click span.cancel-insert":      "onCancelInsert"
    "keydown span.action":           "onActionSpanKeydown"
    "focus span.dummy":              "onDummyFocus"

  initialize: (options) ->
    super()
    @template = HandlebarsTemplates['table']
    @listenTo(@model, 'change:top', @onModelPositionChange)
    @listenTo(@model, 'change:left', @onModelPositionChange)
    @listenTo(@model, 'change:name', @onModelNameChange)
    @listenTo(@model, 'change:comment', @onModelCommentChange)
    @listenTo @model, 'change:color', (m, value) =>
      @$("thead>tr.caption").toggleClass("colored", typeof(value) isnt 'undefined')
      value ||= "#dadada"
      @$("thead>tr.caption").css(backgroundColor: value)
      @trigger("change")
      return
    @listenTo(@model, 'sort', @onModelSort)
    @listenTo(@model, 'destroy', @onModelDestroy)
    @listenTo(@model.get("fields"), 'add', @onNewField)
    @listenTo(@model.get("fields"), 'remove', @onFieldRemoved)
    @_dimensions_changed(200, 100)
    @field_views = []
    return

  onTheadClick: (event) =>
    if event.shiftKey
      app.schemaView.toggleSelectionOfView(this)
    return

  onTHeadContextMenu: (e) =>
    app
      .schemaView
      .tableHeaderPopupMenu
      .setTargetIdx(@model.get_idx())
      .setActiveColor(@model.get("color"))
      .show(e.pageX, e.pageY)
    e.stopPropagation()
    e.preventDefault()
    return

  onModelSort: =>
    @model.get("fields").each (field, idx) =>
      field = _(@field_views).findWhere model: field
      if field
        @$("tbody>tr:eq(#{field.$el.index()})").insertBefore @$("tbody>tr:eq(#{idx})")
    return

  onModelDestroy: ->
    @newFieldView.remove()
    # removing the field models will call,
    # on_model_destroy and will remove the views
    #_.invoke(@field_views, "remove")
    @_viewWillRemove()
    # remove will call stopListening
    # @stopListening(@model)
    @remove()
    app.schemaView.canvasView.refresh()
    return

  onModelNameChange: ->
    @$("th.table-name").text(@model.get "name")

  onModelCommentChange: ->
    @$("tr.comment textarea").val(@model.get "comment")
    @_renderTableComment()
    return

  onModelPositionChange: ->
    @$el.css
      left: @model.get "left"
      top: @model.get "top"
    @_position_changed(@model.get("left"), @model.get("top"))

  onDummyFocus: (e) =>
    if $(e.currentTarget).hasClass("dummy-up")
      @$("input.table-name").focus()
    else
      @$("span.delete-table").focus()
    return

  onEditTable: =>
    @$("tr.caption").hide()
    @$("tr.comment").hide()
    @$("tr.edit-table").show()
    @$("input.table-name").val(@model.get("name")).focus().select()
    app.schemaView.canvasView.refresh()
    this

  onInputKeydown: (e) =>
    if e.keyCode == 13
      @onSaveEditTable()
      false
    else if e.keyCode == 27
      @onCancelEditTable()
      false
    else
      true

  onActionSpanKeydown: (e) =>
    if e.keyCode == 13 || e.keyCode == 32
      $(e.currentTarget).trigger("click")
      false
    else if e.keyCode == 27
      @onCancelEditTable()
      false
    else
      true

  onSaveEditTable: =>
    app.addCommand Command::TABLE_RENAME,
      idx: @model.get("idx")
      old_name: @model.get("name")
      old_comment: @model.get("comment")
      new_name: @$("input.table-name").val()
      new_comment: @$("textarea.table-comment").val()
    @$("tr.caption").show()
    @$("tr.comment").show()
    @$("tr.edit-table").hide()
    @trigger "change"
    app.schemaView.canvasView.refresh()
    this

  onCancelEditTable: =>
    if @$("tr.caption").is(":visible")
      return this
    @$("tr.caption").show()
    @$("tr.comment").show()
    @$("tr.edit-table").hide()
    app.schemaView.canvasView.refresh()
    this

  onDeleteTable: =>
    data = @model.toJSON()
    data.fields = @model.get("fields").toJSON()
    app.addCommand(Command::TABLE_DESTROY, data)
    return

  onNewField: (field, args...) =>
    fv = new dbdesigner.views.FieldView(model: field, tableView: this)
    @field_views.push(fv)
    @_dimensions_changed(200, (@model.get("fields").length + 2) * 18)
    @$('tbody').append fv.render().el
    _.defer => app.schemaView.canvasView.refresh()

  onFieldRemoved: (field) =>
    @field_views = _(@field_views).reject (v) -> v.model == field
    return

  render: ->
    @$el.html @template(this)
    @newFieldView = new dbdesigner.views.NewFieldView(model: @model, tableView: this)
    @$("tfoot>tr>td").append @newFieldView.render().el
    @model.get('fields').each (field) =>
      fv = new dbdesigner.views.FieldView(model: field, tableView: this)
      @$('tbody').append fv.render().el
      @field_views.push(fv)
    @_dimensions_changed(200, (@model.get("fields").length + 2) * 18)
    @$el.css
      position: "absolute"
      left: @model.get("left")
      top: @model.get("top")
    @_position_changed(@model.get("left"), @model.get("top"))
    @$el.draggable
      # containment: 'window'
      handle: 'tr.caption'
      scroll: true
      stack: 'table.entity-table,div.entity-note'
      opacity: 0.8
      start: @onDragStart
      stop: @onDragStop
      drag: @onDrag
      alsoDrag: ".selected"
    @$("tbody").sortable
      axis: 'y'
      handle: '.mover'
      forceHelperSize: true
      forcePlaceholderSize: true
      helper: @onSortableHelper
      start: @onSortableStart
      update: @onSortableUpdate
    @_setTableColor()
    @_renderTableComment()
    this

  _renderTableComment: ->
    ta = @$("tr.comment textarea")
    @$("tr.comment").toggleClass("hidden", !@has_table_comment())
    mn = (a, b) -> if a < b then a else b
    if ta.get(0)
      _.defer => ta.height(mn(ta.get(0).scrollHeight, 150))
    return

  _setTableColor: ->
    $caption = @$("thead>tr.caption")
    table_color = @model.get("color")
    if table_color
      $caption.css(backgroundColor: table_color)
    $caption.toggleClass("colored", typeof(table_color) isnt 'undefined')
    return

  onDragStart: (event, ui) =>
    super(event, ui)
    return

  onSortableHelper: (event, ui) =>
    originals = ui.children()
    elem = ui.clone()
    elem.css
      width: ui.parents("table").outerWidth()
      position: "absolute"
    elem.children().each (idx) ->
      $(@).width originals.eq(idx).width()
      return
    elem

  onSortableStart: =>
    # app.vent.trigger 'fieldWillMove'

  onSortableUpdate: (event, ui) =>
    app.addCommand Command::TABLE_SORT,
      idx: @model.get("idx")
      old_sort_order: @model.get("fields").map (f, i) -> idx: f.get("idx"), order: f.get("order") or i
      new_sort_order: _.map @field_views, (item) -> idx: item.model.get('idx'), order: item.$el.index()
    this

  onSpanAddField: =>
    app.schemaView.bringViewToTop(this)
    @$('div.operations').hide()
    @$('div.insert-panel').show()
    if @_hasPkField()
      @newFieldView.$el.find("input.field-pk").attr("checked", false)
      @newFieldView.$el.find("input.field-null").attr("disabled", false)
      @newFieldView.$el.find("input.field-unique").attr("disabled", false)
    @newFieldView.$el.find("input.field-name").focus().select()

  # called by new field view after inserting new field
  #   or called when cancel is clicked
  onCancelInsert: =>
    @$('div.operations').show()
    @$('div.insert-panel').hide()

  #onDropSort: (e, model, position) =>
    #app.log "onDropSort"

  _hasPkField: =>
    _(@field_views).some (v) -> v.is_pk()

  foreignKeyFields: =>
    _(@field_views).filter (v) -> v.is_fk()

  table_name: ->
    @model.get("name")

  table_comment: ->
    @model.get("comment")

  has_table_comment: ->
    @model.has("comment") && (@model.get("comment").length > 0)

  table_edit_image: ->
    image_path('table-edit.png')

  table_new_row_image: ->
    image_path('table-row-add.png')
