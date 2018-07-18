# Sidebar Container
# Includes views:
# - Properties
# - Comments
# - Collaboration
class dbdesigner.views.SidebarContainer extends Backbone.View
  initialize: (options) ->
    @_resizer_width = 1
    $(window).resize @refreshChrome
    @template = HandlebarsTemplates['sidebar']
    this

  refreshChrome: =>
    if @$el.is(":visible")
      $("div.canvas-container").css({
        width: "#{$(window).width() - this.$el.width() - @_resizer_width - 1}px",
        height: "#{$(window).height() - 29}px",
      })
      $("div.resizer").show().css
        right: @$el.width()
        height: "#{$(window).height()}px",
      $("div.toolbar").css('width', "#{$(window).width() - this.$el.width() - @_resizer_width}px")
      $("div.minimap").css('right', "#{this.$el.width() + 20}px")
      _.defer =>
        @$el.height($(window.height) - 29)
        properties_height = $("div.schema-properties").outerHeight()
        collaboration_height = 0 # $("div.collaboration").outerHeight()
        history_height = $("div.history").outerHeight()
        $("div.comment-list").height($(window).height() - properties_height - collaboration_height - history_height- $("div.new-comment").outerHeight() - 100)
        app.minimapView.resize_viewport()
      #@$("div.comment-list").css({height: "#{$(window.height) - 500}px"}) #28 - @$("div.schema-properties").height())
    else
      $("div.resizer").hide()
      $("div.canvas-container").css({
        width: "#{$(window).width()}px",
        height: "#{$(window).height() - 29}px",
      })
      $("div.toolbar").css('width', "100%")
      $("div.minimap").css('right', "20px")
      app.minimapView.resize_viewport()

  render: ->
    _.defer @refreshChrome
    @$el.html @template(this)
    @commentsView = new dbdesigner.views.panels.Comments(el: @$("div.comments")).render()
    @propertiesView = new dbdesigner.views.panels.Properties(el: @$("div.schema-properties")).render()
    # @collaborationView = new dbdesigner.views.panels.Collaboration(el: @$("div.collaboration")).render()
    @historyView = new dbdesigner.views.panels.History(el: @$("div.history")).render()
    @$el.css
      width: "#{app.settings.read("sidebarWidth")}px"
    $("div.resizer").draggable
      axis: 'x'
      helper: 'clone'
      stop: (e, ui) =>
        @$el.width($(window).width() - ui.position.left - @_resizer_width)
        app.settings.set "sidebarWidth", "#{$(window).width() - ui.position.left - @_resizer_width}"
        @refreshChrome()
    this

  toggle: ->
    if @$el.stop(true, true).is(":visible")
      @hide()
    else
      @show()

  show: ->
    @$el.show()
    @refreshChrome()
    $("#menu-item-view-sidebar>span.menu-caption").text(Handlebars.helpers.t("menu.hide_sidebar"))
    this

  hide: ->
    @$el.hide()
    @refreshChrome()
    $("#menu-item-view-sidebar>span.menu-caption").text(Handlebars.helpers.t("menu.show_sidebar"))
    this
