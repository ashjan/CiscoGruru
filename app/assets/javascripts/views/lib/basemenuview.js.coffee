class dbdesigner.views.BaseMenuView extends Backbone.View
  tagName: "div"
  className: "toolbar"

  events:
    "mouseover ul.menu>li":                   "onTopMenuMouseOver"
    "click ul.menu>li":                       "onTopMenuClick"
    "click ul.submenu>li":                    "onMenuItemClick"
    "mouseover ul.menu>li>ul>li.has-submenu": "onSubMenuMouseOver"
    "mouseout ul.menu>li>ul>li.has-submenu":  "onSubMenuMouseOut"

  initialize: ->
    @showMenus = false
    $("html").on("mousedown", @onBackgroundClicked)
    $("html").on("mouseup", @onBackgroundClicked)
    $(window).resize @onWindowResize
    _.defer => @setupShortcuts()

  setupShortcuts: =>
    $(document).bind "keydown", "backspace", (e) =>
      false
    $(document).bind "keydown", "esc", (e) =>
      @hideMenus()
      return
    $(document).bind "keydown", "alt+ctrl+m", (e) =>
      if not @$el.hasClass("fadeOutUp")
        @$el.removeClass("animated fadeInDown").addClass("animated fadeOutUp")
      else
        @$el.removeClass("animated fadeOutUp").addClass("animated fadeInDown")
    @$("span.shortcut").each ->
      accel = $(this).data('accel')
      $(document).bind "keydown", accel, (e) =>
        app.logger.info "Shortcut fired for #{accel}"
        topMenuItem = $(this).parents('ul.menu>li')
        topMenuItem.addClass("flash")
        _.delay ->
          topMenuItem.removeClass("flash")
        , 100
        app.vent.trigger $(this).parents('li').attr('id')
        if e.cancelBubble
          e.cancelBubble = true
        e.stopPropagation?()
        e.preventDefault?()
        #if $.browser.msie
        #	e.returnValue = false
        false

  onBackgroundClicked: (e) =>
    if e.button == 2
      return false
    if $("ul.menu").has(e.target).length is 0
      @hideMenus()
    true
  
  onWindowResize: (e) =>
    @repositionMenus()

  repositionMenus: =>
    $toolbar = $("div.toolbar")
    $("ul.submenu:visible").each ->
      submenu = $(this)
      # submenu.css 'left', 0
      #submenu.show()
      if !$("body").hasClass("rtl")
        return unless submenu.position().left is 0
      # submenu.find("li:first").text(submenu.position().left)
      submenuRect = $(submenu).get(0).getBoundingClientRect()
      if !$("body").hasClass("rtl")
        if submenuRect.right > $toolbar.width() - 10
          submenu.css 'left', (submenuRect.right - $("div.canvas-container").width() + 10) * -1
      #if $("body").hasClass("rtl")
      if submenuRect.left < 0
        submenu.css 'left', 0
      if submenu.hasClass("second-lvl-menu") && $("body").hasClass("rtl")
        submenu.css 'left', -1 * (submenuRect.right - submenuRect.left)
    return

  showSubmenu: (submenu) ->
    submenu.show()
    @repositionMenus()

  hideMenus: ->
    $("ul.menu>li").removeClass("open-top-menu")
    $("ul.context-menu").hide()
    $("ul.submenu").hide()
    @showMenus = false

  onTopMenuMouseOver: (e) ->
    if @showMenus
      @$("ul.menu>li").not(e.currentTarget).removeClass "open-top-menu"
      $(e.currentTarget).addClass "open-top-menu"
      $("ul.menu>li>ul.submenu").hide()
      @showSubmenu $("ul.submenu:first", $(e.currentTarget))

  onTopMenuClick: (e) ->
    if not @showMenus
      @showSubmenu $("ul.submenu:first", $(e.currentTarget))
      @showMenus = true
      false
    else
      @hideMenus()

  onMenuItemClick: (e) ->
    app.logger.info "onMenuItemClick"
    if $(e.currentTarget).hasClass "menu-separator"
      return false
    if $(e.currentTarget).hasClass "disabled"
      return false
    app.vent.trigger $(e.currentTarget).attr "id"
    if not $(e.currentTarget).hasClass("has-submenu")
      @hideMenus()
    false

  onSubMenuMouseOver: (e) ->
    $("ul.submenu", $(e.currentTarget)).show()

  onSubMenuMouseOut: (e) ->
    $("ul.submenu", $(e.currentTarget)).hide()

