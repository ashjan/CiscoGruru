class dbdesigner.views.ImportSqlDialog extends dbdesigner.views.DialogView
  width: 500
  height: 380
  caption: "dialog.import"

  dialog_events:
    "click button.close": "closeButtonClicked"
    "click button.import": "importButtonClicked"

  initialize_dialog: ->
    @contents = HandlebarsTemplates['dialogs/import_sql_dialog']

  # afterRender: =>
  #   @$("textarea.sql").linedtextarea()

  importButtonClicked: ->
    xhr = $.post "/api/v1/schemas/import_sql.json", {
      db: @$("#export-sql-database").val()
      sql: @$("textarea.sql").val()
    }
    xhr.fail (r) =>
      @showAlert "Server Error"
    xhr.done (r) =>
      @showAlert r.message
      # console.log @$("textarea.sql")
      unless r.status == "invalid_schema"
        @close()
        app.router.navigate("schema/#{r.id}", trigger: true)
        if renv is 'production'
          ga('send', 'event', 'schema', 'import', 'id', r.id)
      else
        @$("textarea.sql").blur()
        _.delay =>
          @$("textarea.sql").blur().get(0).setSelectionRange(r.index, r.index)
          @$("textarea.sql").focus()
        , 200
        # console.log r.message, r.index
        # alert r.message
        # alert "#{r.message} line: #{r.line}, column: #{r.column}"
      return
    return

dbdesigner.DialogRegistry.registerDialog 'importSql', dbdesigner.views.ImportSqlDialog
