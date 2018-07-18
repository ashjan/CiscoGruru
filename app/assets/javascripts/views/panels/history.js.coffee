class dbdesigner.views.panels.History extends dbdesigner.views.panels.Base
  events:
    "click span.action": "onVersionClick"

  panelName: "History"

  initialize: (options) ->
    super()
    @events = _.extend({}, dbdesigner.views.panels.Base::events, @events)
    @template = HandlebarsTemplates['panels/history_panel']
    @listenTo(app.schema, "change:versions", @versionsChanged)
    this

  versionsChanged: =>
    @render()

  versions: ->
    app.schema.get("versions")

  onVersionClick: (e) ->
    d = app.schema.loadVersion(app.schema.id, $(e.currentTarget).data("version-id"))
    d.done ->
      app.showNotification "Schema loaded"
      app.clearUndoStack()
      if app.schema.get("template")
        app.sidebarView.show()
      else
        app.sidebarView.refreshChrome()
      app.schemaView.canvasView.recalculateCanvasSize()
    return
