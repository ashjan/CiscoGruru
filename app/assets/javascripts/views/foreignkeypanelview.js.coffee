class dbdesigner.views.ForeignKeyPanelView extends Backbone.View
  tagName: 'div'
  className: 'refs'
  events:
    "change .field-ref-table": "onRefTableChange"

  remove: =>
    # app.logger.info "FKP FIELD REMOVE"
    super()

  initialize: ->
    @_template = HandlebarsTemplates['foreign_key_panel']
    @listenTo(app.schema.tables, "add", @onTablesChange)
    @listenTo(app.schema.tables, "remove", @onTablesChange)
    @listenTo(app.schema.tables, "change", @onTablesChange)

  onTablesChange: =>
    return if app.schema.loading == true
    return if app.schema.sorting == true
    return unless @$el.is(":visible")
    selected_table = @$(".field-ref-table").val()
    selected_field = @$(".field-ref-fields").val()
    @$(".field-ref-table").empty()
    @$(".field-ref-fields").empty()
    _(app.schema.tables.pluck("name").sort()).each (t) =>
      @$(".field-ref-table").append($("<option />").val(t).text(t))
    if selected_table
      @$(".field-ref-table").val(selected_table)

      table = app.schema.tables.where({name: selected_table})[0]
      return unless table
      @_populateTableFields(table)
      if selected_field
        @$(".field-ref-fields").val(selected_field)
    true

  render: =>
    @$el.html @_template(this)
    _(app.schema.tables.pluck("name").sort()).each (t) =>
      @$(".field-ref-table").append($("<option />").val(t).text(t))
    if @model and @model.get("fk")
      #table = app.schema.tables.first()
      fk_table_name = @model.get("fk_table")
      @$(".field-ref-table").val fk_table_name
      table = app.schema.tables.findWhere({name: fk_table_name})
      unless table
        # app.logger.warn "CANT FIND TABLE: #{fk_table_name}"
        return this
      table.get("fields").each (f) =>
        @$(".field-ref-fields").append($("<option />").val(f.get("name")).text(f.get("name")))
      @$(".field-ref-fields").val(@model.get("fk_field"))
    else
      # app.logger.debug "no model"
      table_name = @$(".field-ref-table").val()
      table = app.schema.tables.findWhere({name: table_name})
      unless table
        # app.logger.warn "CANT FIND TABLE: #{fk_table_name}"
        return this
      table.get("fields").each (f) =>
        @$(".field-ref-fields").append($("<option />").val(f.get("name")).text(f.get("name")))
    this

  show: =>
    @onTablesChange()
    @$el.show()

  hide: =>
    @$el.hide()

  onRefTableChange: (e) =>
    table = app.schema.tables.where({name: $(e.target).val()})[0]
    return unless table
    @_populateTableFields(table)
    this

  _populateTableFields: (table) ->
    # TODO: table not found err
    @$(".field-ref-fields").empty()
    if table && table.get("fields")
      table.get("fields").each (f) =>
        @$(".field-ref-fields").append($("<option />").val(f.get("name")).text(f.get "name"))
    this
