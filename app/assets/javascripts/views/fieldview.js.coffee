class dbdesigner.views.FieldView extends Backbone.View
  tagName: 'tr'
  className: 'tr'
  attributes: -> "data-field-name": @model.get "name"
  events:
    "click img.edit-field":    "onEditField"
    "dblclick":                "onEditField"
    "keydown input":           "onInputKeydown"
    "keydown span.action":     "onActionSpanKeydown"
    "click .save-button":      "onSaveClick"
    "click .cancel-save":      "onCancelClick"
    "click span.delete-field": "onDeleteField"
    "click .field-pk":         "onPrimaryKeyClick"
    "click .field-fk":         "onForeignKeyClick"
    #"dbdesigner:drop": "on_drop"
    "focus span.dummy":        "onDummyFocus"

  initialize: (options) ->
    @showTemplate = HandlebarsTemplates['field']
    @editTemplate = HandlebarsTemplates['field_edit']
    @listenTo(@model, "change", @render)
    @listenTo(@model, "destroy", @onModelDestroy)
    @mode = "show"
    @foreignPanelView = null
    @tableView = options.tableView

  onModelDestroy: =>
    # remove will call stopListening
    # @stopListening(@model)
    @tableView = null
    @remove()

  remove: ->
    # app.logger.debug "Remove called for view"
    if @foreignPanelView
      @foreignPanelView.remove()
    super()

  render: =>
    if @mode == "show"
      #if @foreignPanelView isnt null
      #
      @$el.html @showTemplate(this)
      @$el.find("td:first")
        .toggleClass("pk-field", @is_pk() is true)
        .toggleClass("fk-field", @is_fk() is true)
        .toggleClass("auto-increment", @model.get("auto_increment") is true)
        .toggleClass("not-null", @model.get("allow_null") is false)
    else
      @$el.html @editTemplate(this)
      if @foreignPanelView is null
        @foreignPanelView = new dbdesigner.views.ForeignKeyPanelView(model: @model, el: @$("div.refs"))
      else
        @foreignPanelView.setElement(@$("div.refs"))
        # app.logger.debug "FKP was not null: #{@foreignPanelView}"
      @foreignPanelView.render()
      @$("input.field-name").focus().select()
    #@$el.data "model", @model
    this

  onDummyFocus: (e) =>
    if $(e.currentTarget).hasClass("dummy-up")
      @$("input.field-name").focus()
    else
      $("span.delete-field").focus()
    return

  onEditField: =>
    return if @mode is "edit"
    @mode = "edit"
    @render()
    app.schemaView.canvasView.refresh()
    @$(".field-type").val @model.get("type")
    if @model.get("auto_increment") == true
      @$(".field-ai").attr("checked", true)
    if @model.get("allow_null") == true
      @$(".field-null").attr("checked", true)
    if @model.get("unique") == true
      @$(".field-unique").attr("checked", true)
    if @is_pk()
      @$(".field-pk").attr("checked", true)
      @$("input.field-null").attr("disabled", true)
      @$("input.field-unique").attr("disabled", true)
    else
      @$(".field-pk").attr("checked", false)
    @$(".field-fk").attr("checked", @is_fk())
    if @is_fk()
      @foreignPanelView.show()
    app.schemaView.bringViewToTop(@tableView)
    true

  onPrimaryKeyClick: (e) =>
    if @$("input.field-pk").is(":checked")
      @$("input.field-null").attr("disabled", true)
      @$("input.field-unique").attr("disabled", true)
    else
      @$("input.field-null").attr("disabled", false)
      @$("input.field-unique").attr("disabled", false)
    true

  onForeignKeyClick: (e) =>
    if @$("input.field-fk").is(":checked")
      @foreignPanelView.show()
    else
      @foreignPanelView.hide()
    true

  onInputKeydown: (e) =>
    if e.keyCode == 13
      @onSaveClick()
      false
    else if e.keyCode == 27
      @onCancelClick()
      false
    else
      true

  onActionSpanKeydown: (e) =>
    if e.keyCode == 13 || e.keyCode == 32
      $(e.currentTarget).trigger("click")
      false
    else if e.keyCode == 27
      @onCancelClick()
      false
    else
      true

  onSaveClick: =>
    @mode = "show"
    data =
      idx: @model.get("idx")
      table_name: @tableView.model.get("name")
      old_state: @model.toJSON()
      new_state:
        name: @$(".field-name").val()
        type: @$(".field-type").val()
        size: @$(".field-size").val()
        default_value: @$(".field-default").val()
        auto_increment: @$("input.field-ai").is(":checked")
        allow_null: @$("input.field-null").is(":checked")
        unique: @$("input.field-unique").is(":checked")
        pk: @$("input.field-pk").is(":checked")
        fk: @$("input.field-fk").is(":checked")
    if @$("input.field-fk").is(":checked")
      data.new_state.fk_table = @$(".field-ref-table").val()
      data.new_state.fk_field = @$(".field-ref-fields").val()
    app.addCommand(Command::FIELD_CHANGE, data)
    @render()
    app.schemaView.canvasView.refresh()
    true

  onCancelClick: =>
    @mode = "show"
    @render()
    app.schemaView.canvasView.refresh()
    return

  onDeleteField: (e) =>
    if !e.shiftKey
      if !confirm(Handlebars.helpers.t('designer.field_delete_alert'))
        return
    data = @model.toJSON()
    data.table_idx = @tableView.model.get("idx")
    app.addCommand(Command::FIELD_DESTROY, data)
    true

  #on_drop: (e, idx) =>
    #app.log "on drop"
    #@$el.trigger('dbdesigner:update-sort', [@model, idx])
    #this

  # {{{ methods used by the template:

  name: ->
    @model.get "name"

  default: ->
    if app.settings.read("show_default_value") == "true"
      if @model.get "default_value"
        "default(#{@model.get "default_value"})"
      else
        ""
    else
      ""

  type: ->
    #@model.get "typeString"
    type = @model.get "type"
    size = @model.get "size"
    if size
      "#{type}(#{size})"
    else
      type

  size: ->
    @model.get "size"

  default_value: ->
    @model.get "default_value"

  is_pk: ->
    @model.get "pk"

  is_fk: ->
    @model.get "fk"

  key_field: ->
    result = ""
    if @is_pk()
      if @model.get("auto_increment") and (app.settings.read("show_auto_increment") == "true")
        result += """<img src="#{image_path('key_ai.png')}" />"""
      else
        result += """<img src="#{image_path('key.png')}" />"""
    else if (app.settings.read("show_not_null") == "true") and !@model.get("allow_null")
      result += """<img src="#{image_path('notnull.png')}" />"""

    if !@is_pk() and (app.settings.read("show_auto_increment") == "true") and @model.get("auto_increment")
      result += """<img src="#{image_path('ai.png')}" />"""
    if (app.settings.read("show_fk_icon") == "true") and @is_fk()
      result += """<img src="#{image_path('table_relationship.png')}" />"""
    result

  datatypes: ->
    app.schema.datatypes.sort().map (dt) ->
      name: dt

  edit_image: ->
    image_path('edit.png')

  updown_image: ->
    image_path('updownp.png')
  # }}}
