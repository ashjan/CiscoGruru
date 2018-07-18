class dbdesigner.views.OptionsDialog extends dbdesigner.views.DialogView
  width: 480
  height: 230
  caption: "dialog.options"

  dialog_events:
    "click button.close": "closeButtonClicked"
    "click button.save": "saveButtonClicked"

  initialize_dialog: ->
    @contents = HandlebarsTemplates['dialogs/options_dialog']

  afterRender: ->
    @$("select#language").val(app.settings.read("language"))
    colorPicker = new jscolor.color(@$("input.color").get(0), {})
    this

  saveButtonClicked: =>
    selected_color = "##{$("input.color").val()}"
    app.settings.set("lineColor", selected_color)
    app.settings.set("show_auto_increment", @$("#show-ai-icon").is(":checked"))
    app.settings.set("show_fk_icon", @$("#show-fk-icon").is(":checked"))
    app.settings.set("show_not_null", @$("#show-not-nulls").is(":checked"))
    app.settings.set("show_default_value", @$("#show-default-values").is(":checked"))
    app.settings.set("invert_line_direction", @$("#invert-line-direction").is(":checked"))
    app.lang = @$("select#language").val()
    if renv is 'production' and app.lang isnt 'en'
      ga('send', 'event', 'app', 'lang', app.lang)
    app.settings.set("language", @$("select#language").val())
    if I18n.settings[app.lang]?.direction == 'rtl'
      app.change_direction('rtl')
    else
      app.change_direction('ltr')
    app.menuView.renderMainMenu().renderUserMenu()
    app.schemaView.renderPopupMenus()
    $("[data-lang-text]").each (index, elem) ->
      $(elem).text(Handlebars.helpers.t($(elem).data("lang-text")))
    $("[data-lang-value]").each (index, elem) ->
      $(elem).val(Handlebars.helpers.t($(elem).data("lang-value")))
    _(app.schemaView.table_views).each (tv) ->
      _(tv.field_views).each (fv) ->
        fv.render()
    app.schemaView.canvasView.setLineColor selected_color
    app.settings.saveToServer()
    @close()
    this

  lineColor: ->
    app.settings.read("lineColor")

  showDefaultValue: ->
    if app.settings.read('show_default_value') == "true"
      "checked"
    else
      ""

  showAiIcon: ->
    if app.settings.read('show_auto_increment') == "true"
      "checked"
    else
      ""

  showFkIcon: ->
    if app.settings.read('show_fk_icon') == "true"
      "checked"
    else
      ""

  showNotNull: ->
    if app.settings.read('show_not_null') == "true"
      "checked"
    else
      ""

  invertLineDirection: ->
    if app.settings.read("invert_line_direction") == "true"
      "checked"
    else
      ""

  languages: ->
    _(_.keys(I18n.settings)).map (key) ->
      return {
        code: I18n.settings[key].code
        name: I18n.settings[key].name
      }

dbdesigner.DialogRegistry.registerDialog "options", dbdesigner.views.OptionsDialog
