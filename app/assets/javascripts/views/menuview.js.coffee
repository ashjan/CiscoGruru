class dbdesigner.views.MenuView extends dbdesigner.views.BaseMenuView
  events: {}

  initialize: ->
    super()
    @events = _.extend({}, dbdesigner.views.BaseMenuView::events, @events)
    @listenTo @model, "change", @renderUserMenu

  render: =>
    # @$el.empty()
    @$el.prepend HandlebarsTemplates['menus/main_menu']()
    # @$el.append $("<div class=notification></div>")
    @_updateMenuItemTexts()
    @onModelChange()
    this

  _updateMenuItemTexts: ->
    text = if app.settings.read("show_grid") == "false"
      Handlebars.helpers.t("menu.show_grid")
    else
      Handlebars.helpers.t("menu.hide_grid")
    @$("#menu-item-view-grid").text(text)
    text = if app.settings.read("show_minimap") == "false"
      Handlebars.helpers.t("menu.show_minimap")
    else
      Handlebars.helpers.t("menu.hide_minimap")
    @$("#menu-item-view-minimap").text(text)
    return

  renderMainMenu: =>
    $("#mainmenu").remove()
    @$el.prepend HandlebarsTemplates['menus/main_menu']()
    @_updateMenuItemTexts()
    this
  
  renderUserMenu: =>
    $("#usermenu").remove()
    if app.user.get('login')
      @$el.append HandlebarsTemplates['menus/user_menu'](@model.toJSON())
    else
      @$el.append HandlebarsTemplates['menus/guest_menu'](@model.toJSON())
    this

  fadeIn: ->
    @$el.animate
      "height": "toggle"
      "opacity": "toggle"
      , 1000
    this

  onModelChange: =>
    $("#usermenu").remove()
    if app.user.get('login')
      @$el.append HandlebarsTemplates['menus/user_menu'](@model.toJSON())
    else
      @$el.append HandlebarsTemplates['menus/guest_menu'](@model.toJSON())
    return
