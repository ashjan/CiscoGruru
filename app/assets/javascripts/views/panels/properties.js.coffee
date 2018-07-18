class dbdesigner.views.panels.Properties extends dbdesigner.views.panels.Base
  events: {}

  panelName: "Properties"

  initialize: (options) ->
    super()
    @events = _.extend({}, dbdesigner.views.panels.Base::events, @events)
    @template = HandlebarsTemplates['panels/properties_panel']
    @listenTo(app.schema, "change:title", @schemaChanged)
    @listenTo(app.schema, "change:db", @schemaChanged)
    this

  schemaChanged: =>
    @$("span.schema-title").text(app.schema.get("title"))
    @$("span.db-type").text(app.schema.get("db"))

  schema_title: ->
    app.schema.get("title")

  db_type: ->
    app.schema.get("db")
