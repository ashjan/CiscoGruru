class dbdesigner.views.PopupMenuView extends Backbone.View
  tagName: "ul"
  className: "context-menu"
  events:
    "click li": "onMenuItemClick"
    "click span.table-color": "onTableColorClicked"

  initialize: (options) ->
    @template = HandlebarsTemplates["menus/#{options.template_name}"]
    return

  show: (left, top) ->
    $("ul.context-menu").hide()
    @$el.css
      left: left + @$el.parent().scrollLeft()
      top: top + @$el.parent().scrollTop() - @$el.parent().position().top
    @$el.show()

  setTargetIdx: (idx) ->
    @targetIdx = idx
    this

  setActiveColor: (color) ->
    @$(".table-color").removeClass("selected")
    @$(".table-color[data-color='#{color}']").addClass("selected")
    this

  onMenuItemClick: (e) =>
    if $(e.currentTarget).hasClass "menu-separator"
      return false
    app.vent.trigger $(e.currentTarget).attr("id")
    @$el.hide()
    false

  onTableColorClicked: (e) =>
    color = $(e.currentTarget).data("color")
    app.vent.trigger "change-table-color", color
    @$el.hide()
    false

  render: ->
    @$el.html @template()
    @$el.addClass("menu")
    this
