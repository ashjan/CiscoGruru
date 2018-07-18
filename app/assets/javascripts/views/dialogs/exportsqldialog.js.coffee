class dbdesigner.views.ExportSqlDialog extends dbdesigner.views.DialogView
  width: 660
  height: 460
  caption: "dialog.export_sql"

  dialog_events:
    "click button.close":             "closeButtonClicked"
    "click button.generate":          "onGenerateButtonClicked"
    "click a.download-sql":           "onDownloadButtonClicked"
    "click button.copy-to-clipboard": "onCopyToClipboard"
    "click .back-button":             "onBackButtonClicked"
    "click pre.sql":                  "onSqlClicked"
    "change #export-sql-database":    "onDatabaseChanged"

  initialize_dialog: ->
    @contents = HandlebarsTemplates['dialogs/export_sql_dialog']

  afterRender: =>
    unless app.browser.support.download
      @$("a.download-sql").hide()
    if app.schema.get("db") != "generic"
      @$("#export-sql-database>option").not("[value=#{app.schema.get("db")}]").remove()
    @onDatabaseChanged()
    return

  onDatabaseChanged: ->
    db = @$("#export-sql-database").val()
    @$(".script-types-field").toggle(db in ["mysql", "postgres", "sqlite", "mssql"])
    return

  onGenerateButtonClicked: ->
    @db = @$("#export-sql-database").val()
    @script_type = if @db in ["mysql", "postgres", "sqlite", "mssql"]
      @$("input[name=script-type]:checked").val()
    else
      "create"
    $generate_button = @$("button.generate")
    $generate_button.prop('disabled', true)
    xhr = $.post "/api/v1/schemas/#{app.schema.id}/generate_sql.json", {
      schema: {
        schema_data: JSON.stringify(app.schema.serializeForDb(@db))
        script_type: @script_type
      }
    }
    xhr.always ->
      $generate_button.prop('disabled', false)
      return
    xhr.done (r) =>
      $("pre.sql").html(r.sql)
      @_showSqlOutput()
      if renv is 'production'
        ga('send', 'event', 'schema', 'generate', 'id', app.schema.id)
    return

  onSqlClicked: ->
    selectElementText(@$("pre.sql").get(0))
    return

  onBackButtonClicked: ->
    @$(".sql-config").show()
    @$(".sql-output").hide()
    return

  onDownloadButtonClicked: ->
    _URL = window.URL
    file = new Blob([$("pre.sql").text()], {type: 'text/plain'})
    $(".download-sql").get(0).href = _URL.createObjectURL(file)
    $(".download-sql").get(0).download = "#{app.schema.get('title')}_#{@db}_#{@script_type}.sql"
    return

  onCopyToClipboard: ->
    copyEvent = new ClipboardEvent 'copy',
      dataType: 'text/plain'
      data: $("pre.sql").text()
    document.dispatchEvent copyEvent
    return

  _showSqlOutput: ->
    @$(".sql-config").hide()
    @$(".sql-output").show()
    return

dbdesigner.DialogRegistry.registerDialog 'exportSql', dbdesigner.views.ExportSqlDialog
