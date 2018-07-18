# namespaces
@dbdesigner =
  models: {}
  views: {
    panels: {}
  }
  collections: {}
  routers: {}
  datatypes: {}

@I18n =
  bn: {}
  pt_br: {}
  ca: {}
  cs: {}
  da: {}
  de: {}
  en: {}
  es: {}
  fa: {}
  fr: {}
  fi: {}
  gr: {}
  id: {}
  in: {}
  it: {}
  ja: {}
  nl: {}
  nb_no: {}
  pl: {}
  ru: {}
  tr: {}
  vi: {}
  zh: {}

NProgress.configure
  showSpinner: false

# I18n helper for handlebar templates
Handlebars.registerHelper 't', (i18n_key) ->
  [module, key] = i18n_key.split('.')
  I18n[app.lang][module][key]

# convert epochs integer to local datetime
Handlebars.registerHelper 'epochsToLocalTime', (timestamp) ->
  d = new Date(0)
  d.setUTCSeconds(timestamp)
  try
    result = d.toLocaleString(navigator.language, {hour12: false})
  catch error
    result = d.toLocaleString()
  result

default_settings =
  lineColor: "#336699"
  lineType: "BEZIER"
  sidebarWidth: "240"
  panelPropertiesOpen: true
  panelHistoryOpen: true
  panelCommentsOpen: true
  language: 'en'
  show_fk_icon: false
  show_auto_increment: false
  show_not_null: false
  show_default_value: false
  invert_line_direction: false
  show_minimap: true
  show_grid: true

class dbdesigner.App
  constructor: ->
    @vent = _.clone(Backbone.Events)
    @browser = new Browser()
    @_setupMenuCallbacks()
    @logger = new Logger
    @settings = new Settings default_settings
    @lang = @settings.read("language") or 'en'
    if @lang == 'fa'
      @change_direction('rtl')
    @dialogManager = new dbdesigner.DialogManager
    @schema = new dbdesigner.models.Schema
    @user = new dbdesigner.models.User
    @commandFactory = new CommandFactory()
    @undoStack = new CommandStack()
    if @browser.support.cssFilter
      $(".app-container").addClass("css-filter-support")
    return

  change_direction: (direction) ->
    if direction == 'rtl'
      $("body").addClass('rtl')
    else
      $("body").removeClass('rtl')
    return

  start: ->
    @browser.setup()
    @user.set
      login: userinfo.login
      username: userinfo.username
      email: userinfo.email
      avatar: userinfo.avatar
      tmpid: userinfo.tmpid
    @setupViews()
    return if renv == 'test'
    @router = new dbdesigner.routers.AppRouter
    Backbone.history.start pushState: true, root: 'designer'
    _.defer -> $(".init-loading").hide()
    this

  updateDocumentTitle: ->
    title = "#{app.schema.get("title")} | DbDesigner.net"
    title = "* " + title if @undoStack.canUndo()
    document.title = title
    return

  updateMainMenu: ->
    $("#menu-item-schema-save").toggleClass("disabled", !@undoStack.canUndo())
    $("#menu-item-edit-undo").toggleClass("disabled", !@undoStack.canUndo())
    $("#menu-item-edit-redo").toggleClass("disabled", !@undoStack.canRedo())
    return

  addCommand: (type, data) ->
    cmd = @commandFactory.createCommand(type, data)
    @undoStack.add cmd
    cmd.apply_command()
    @updateDocumentTitle()
    @updateMainMenu()
    # @schema.saveToLocalStorage()
    cmd

  undo: =>
    @undoStack.undo()
    @updateDocumentTitle()
    @updateMainMenu()
    return

  redo: =>
    @undoStack.redo()
    @updateDocumentTitle()
    @updateMainMenu()
    return

  clearUndoStack: =>
    @undoStack.clear()
    @updateDocumentTitle()
    @updateMainMenu()
    return

  showTutorial: =>
    app.dialogManager.showDialog "tutorial"
    return

  setupViews: ->
    @menuView = new dbdesigner.views.MenuView(model: @user, el: $("div.toolbar"))
    #$("body").prepend(@menuView.render().el)
    @menuView.render()
    @menuView.fadeIn()
    @schemaView = new dbdesigner.views.SchemaView(model: @schema, el: $("body"))
    @schemaView.render()
    @minimapView = new dbdesigner.views.MinimapView(schemaView: @schemaView)
    $("div.canvas-container").append(@minimapView.render().el)
    @notificationView = new dbdesigner.views.NotificationView(el: $("div.toolbar div.notification"))
    @notificationView.render()
    @sidebarView = new dbdesigner.views.SidebarContainer(el: $("div.sidebar"))
    @sidebarView.render()
    # $("body").prepend(@notificationView.render().el)
    if @settings.read("show_minimap") == "false"
      @minimapView.hide()
    if @settings.read("show_grid") == "false"
      $("#graph").addClass("hide-grid")
    return

  _setupMenuCallbacks: ->
    @vent.on "menu-item-schema-new": =>
      continue_action = =>
        @schema.resetSchema()
        app.dialogManager.showDialog "new"
        return
      if !@undoStack.canUndo()
        continue_action()
      else
        app.dialogManager.showConfirmationDialog "dirty_schema_confirmation", [
          () => @schema.saveSchema().done(continue_action)
        ,
          continue_action
        ]
      return
    @vent.on "menu-item-schema-load": =>
      continue_action = =>
        app.dialogManager.showDialog "load"
      if !@undoStack.canUndo()
        continue_action()
      else
        app.dialogManager.showConfirmationDialog "dirty_schema_confirmation", [
          () => @schema.saveSchema().done(continue_action)
        ,
          continue_action
        ]
      return
    @vent.on "menu-item-schema-save": => @schema.saveSchema()
    @vent.on "menu-item-schema-save-as": =>
      if app.user.get("login")
        app.dialogManager.showDialog "saveas"
      else
        app.showAlert Handlebars.helpers.t('alerts.login_to_use_this_function')
    @vent.on "menu-item-schema-templates": =>
      continue_action = ->
        app.dialogManager.showDialog "templates"
      if !@undoStack.canUndo()
        continue_action()
      else
        app.dialogManager.showConfirmationDialog "dirty_schema_confirmation", [
          () => @schema.saveSchema().done(continue_action)
        ,
          continue_action
        ]
      return
    @vent.on "menu-item-schema-properties": => app.dialogManager.showDialog "properties"
    @vent.on "menu-item-schema-share": =>
      unless app.schema.is_owner()
        app.showAlert Handlebars.helpers.t('alerts.schema_owner_error')
      else
        app.dialogManager.showDialog "share"
    @vent.on "menu-item-schema-import": =>
      if app.user.get("login")
        app.dialogManager.showDialog "importSql"
      else
        app.showAlert Handlebars.helpers.t('alerts.login_to_use_this_function')
    @vent.on "menu-item-edit-undo": => app.undo()
    @vent.on "menu-item-edit-redo": => app.redo()
    @vent.on "menu-item-edit-select-all": => app.schemaView.selectAll()
    @vent.on "menu-item-edit-select-none": => app.schemaView.selectNone()
    @vent.on "menu-item-delete": => app.schemaView.deleteSelection()
    @vent.on "menu-item-insert-table": =>
      app.addCommand(Command::TABLE_CREATE, {
        top: $("div.canvas-container").scrollTop() + 10
        left: $("div.canvas-container").scrollLeft() + 10
      })
    @vent.on "menu-item-insert-note": =>
      app.addCommand(Command::NOTE_CREATE, {
        top: $("div.canvas-container").scrollTop() + 10
        left: $("div.canvas-container").scrollLeft() + 10
      })
      return
    @vent.on "menu-item-view-minimap": =>
      @minimapView.toggle()
      minimap_hidden = @minimapView.is_hidden()
      @settings.set "show_minimap", !minimap_hidden
      @menuView._updateMenuItemTexts()
      return
    @vent.on "menu-item-view-sidebar": => app.sidebarView.toggle()
    @vent.on "menu-item-view-grid": =>
      $("#graph").toggleClass("hide-grid")
      grid_hidden = $("#graph").hasClass("hide-grid")
      @settings.set "show_grid", !grid_hidden
      @menuView._updateMenuItemTexts()
      return
    @vent.on "menu-item-view-sort": => app.schemaView.sortPositions()
    @vent.on "menu-item-view-line-bezier": => app.schemaView.canvasView.setLineType "BEZIER"
    @vent.on "menu-item-view-line-cornered": => app.schemaView.canvasView.setLineType "CORNERED"
    @vent.on "menu-item-view-options": => app.dialogManager.showDialog "options"
    @vent.on "menu-item-export-sql": => app.dialogManager.showDialog "exportSql"
    @vent.on "menu-item-export-image": => app.dialogManager.showDialog "exportImage"
    @vent.on "menu-item-help-index": => app.dialogManager.showDialog "help"
    @vent.on "menu-item-help-changes": =>
      window.open("https://www.dbdesigner.net/changelog")
    @vent.on "menu-item-help-tutorial": => app.showTutorial()
    @vent.on "menu-item-help-shortcuts": => app.dialogManager.showDialog "shortcuts"
    @vent.on "menu-item-help-feedback": => app.dialogManager.showDialog "feedback"
    @vent.on "menu-item-help-about": => app.dialogManager.showDialog "about"
    @vent.on "menu-item-user-login": => app.dialogManager.showDialog "login"
    @vent.on "menu-item-user-logout": =>
      app.user.logout()
    @vent.on "menu-item-user-account-settings": =>
      window.open("https://www.dbdesigner.net/account")
    @vent.on "menu-item-delete-note": =>
      idx = app.schemaView.notePopupMenu.targetIdx
      note = @schema.notes.findWhere idx: idx
      app.addCommand(Command::NOTE_DESTROY, note.toJSON())
      return
    @vent.on "menu-item-delete-table": =>
      idx = app.schemaView.tableHeaderPopupMenu.targetIdx
      table = @schema.tables.findWhere idx: idx
      data = table.toJSON()
      data.fields = table.get("fields").toJSON()
      app.addCommand(Command::TABLE_DESTROY, data)
      return
    @vent.on "menu-item-duplicate-table": =>
      idx = app.schemaView.tableHeaderPopupMenu.targetIdx
      table = @schema.tables.findWhere idx: idx
      data = table.toJSON()
      delete data['idx']
      data.fields = _.map data.fields = table.get("fields").toJSON(), (f) ->
        delete f['idx']
        f
      data['left'] = data['left'] + 250
      data['name'] = data['name'] + ' copy'
      app.addCommand(Command::TABLE_CREATE, data)
      return
    @vent.on "change-table-color": (color) =>
      idx = app.schemaView.tableHeaderPopupMenu.targetIdx
      table = @schema.tables.findWhere idx: idx
      data =
        idx: table.get("idx")
        from_values:
          color: table.get("color")
        to_values:
          color: color
      app.addCommand(Command::TABLE_CHANGE, data)
      return
    return

  showNotification: (text) ->
    @notificationView.showText(text)
    return

  showAlert: (text) ->
    @notificationView.showText(text).$el.addClass('alert')
    return

class dbdesigner.routers.AppRouter extends Backbone.Router
  routes:
    "": "index"
    "schema/new": "newSchema"
    "schema/:id": "loadSchema"
    "schema/:id/version/:vid": "loadSchemaVersion"
  initialize: (options) -> this
  newSchema: -> app.vent.trigger("menu-item-schema-new")
  index: ->
    return
  loadSchemaVersion: (id, vid) ->
    d = app.schema.loadVersion(id, vid)
    d.done ->
      app.clearUndoStack()
      if app.schema.get("template")
        app.sidebarView.show()
      else
        app.sidebarView.refreshChrome()
      app.schemaView.canvasView.recalculateCanvasSize()
    return

  loadSchema: (id) ->
    d = app.schema.loadSchema(id)
    d.done ->
      app.clearUndoStack()
      if app.schema.get("template")
        app.sidebarView.show()
      else
        app.sidebarView.refreshChrome()
      app.schemaView.canvasView.recalculateCanvasSize()
      return

$ ->
  window.app = new dbdesigner.App
  window.app.start()
