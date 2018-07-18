class dbdesigner.views.NewFieldView extends Backbone.View
  tagName: 'div'
  className: 'insert-panel'
  events:
    "click input.save-button": "onSaveClick"
    "click .field-pk":         "onPrimaryKeyClick"
    "click .field-fk":         "onForeignKeyClick"
    "keydown input":           "onInputKeydown"
    "focus span.dummy":        "onDummyFocus"
    "keydown span.action":     "onActionSpanKeydown"

  initialize: (options) ->
    @template = HandlebarsTemplates['insert_panel']
    @tableView = options.tableView
    @foreignPanelView = null
    true

  remove: =>
    if @foreignPanelView
      @foreignPanelView.remove()
    super()

  render: =>
    @$el.html @template(this)
    if @foreignPanelView is null
      @foreignPanelView = new dbdesigner.views.ForeignKeyPanelView(el: @$("div.refs"))
    else
      @foreignPanelView.setElement(@$("div.refs"))
    @foreignPanelView.render()
    @$("div.refs").hide()
    this

  onInputKeydown: (e) =>
    if e.keyCode == 13
      @_add_field()
      if !(e.metaKey || e.ctrlKey)
        @tableView.onCancelInsert()
      else
        @_clearForm()
        @$(".field-name").focus()
      false
    else if e.keyCode == 27
      @$("span.cancel-insert").trigger("click")
    else
      true

  onDummyFocus: (e) =>
    if $(e.currentTarget).hasClass("dummy-up")
      @$("input.field-name").focus()
    else
      @$("span.cancel-insert").focus()
    return

  onActionSpanKeydown: (e) =>
    if e.keyCode == 13 || e.keyCode == 32
      $(e.currentTarget).trigger("click")
      false
    else if e.keyCode == 27
      @$("span.cancel-insert").trigger("click")
      false
    else
      true

  onPrimaryKeyClick: (e) =>
    if @$("input.field-pk").is(":checked")
      @$("input.field-null").attr("disabled", true)
      @$("input.field-unique").attr("disabled", true)
      @$("input.field-ai").prop("checked", true)
    else
      @$("input.field-null").attr("disabled", false)
      @$("input.field-unique").attr("disabled", false)
    true

  onForeignKeyClick: (e) =>
    if @$("input.field-fk").is(":checked")
      @$("div.refs").show()
      if @foreignPanelView
        @foreignPanelView.onTablesChange()
    else
      @$("div.refs").hide()

  onSaveClick: =>
    @_add_field()
    @tableView.onCancelInsert()
    true

  _add_field: =>
    _field = @_getFieldFromForm()
    _field.table_idx = @model.get("idx")
    _field.order = 1
    max_field = null
    max_order = -1
    for field in @model.get("fields").models
      if field.get("order") > max_order
        max_field = field
        max_order = field.get("order")
    _field.order = 1 + max_field?.get("order")
    app.addCommand(Command::FIELD_CREATE, _field)
    return

  _getFieldFromForm: =>
    field =
      name: @$(".field-name").val()
      type: @$(".field-type").val()
      size: @$(".field-size").val()
      default_value: @$(".field-default").val()
      allow_null: @$("input.field-null").is(":checked")
      unique: @$("input.field-unique").is(":checked")
      auto_increment: @$("input.field-ai").is(":checked")
      pk: @$("input.field-pk").is(":checked")
    if @$("input.field-fk").is(":checked")
      field.fk = true
      field.fk_table = @$(".field-ref-table").val()
      field.fk_field = @$(".field-ref-fields").val()
    field

  _clearForm: ->
    @$(".field-name").val('')
    @$(".field-type").val('string')
    @$(".field-size").val('')
    @$(".field-default").val('')
    this

  datatypes: ->
    app.schema.datatypes.sort().map (dt) ->
      name: dt
