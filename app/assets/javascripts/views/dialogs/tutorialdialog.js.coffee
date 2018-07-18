class dbdesigner.views.TutorialDialog extends dbdesigner.views.DialogView
  width: 520
  height: 320
  caption: ->
    "DB Designer Tutorial (#{@currentStep + 1}/#{dbdesigner.views.TutorialDialog.prototype.TUTORIAL_CONTENT.length})"
  hasBottomBar: true
  leftButtons: ->
    [
      caption: "Back"
      className: "back-button"
    ]
  rightButtons: ->
    [
      caption: "Next"
      className: "next-button"
    ,
      caption: "Close Tutorial"
      className: "close-tutorial-button"
    ]

  @::TUTORIAL_CONTENT = [
    step: 1
    caption: 'DB Designer Tutorial'
    contents: 'Welcome to the DB Designer tutorial. You can open this tutorial anytime from the Help menu.'
  ,
    step: 2
    caption: 'Insert Tables and Notes'
    contents: 'To insert a new table to your schema, select "Table" from the "Insert" menu.<br> You can also right click on an empty space in the canvas, and click "Table".<br> You can add notes to your schema similarly.'
  ,
    step: 3
    caption: 'Adding Fields'
    contents: 'Click "Add Field" at the bottom of the table to add a new field.<br>The new field will be added as the last field to the table. If you want to change the order of the fields, you can reorder the fields by dragging the small up-down icon.'
  ,
    step: 4
    caption: 'Editing Fields'
    contents: 'To edit a field, you can click on the pencil icon or double click the field.<br>When you are finished, click on the "Update" button.'
  ,
    step: 5
    caption: 'Adding Relationships'
    contents: 'To create a relation between two tables, you need to add a "Foreign Key" to a table. When adding a new field click on "Foreign Key" and select the "Referenced Table" and "Referenced Field"'
  ,
    step: 6
    caption: 'Generate SQL'
    contents: 'To generate SQL from your schema, click "SQL" from the "Export" menu. The export dialog that pops up will let you customize the SQL output.'
  ,
    step: 7
    caption: 'Share'
    contents: 'To share your database schema with other people, select "Share" from the "Schema" menu.'
  ,
    step: 8
    caption: 'End of tutorial'
    contents: 'That\'s all you need to know to start using DB Designer. If you have any questions, please contact us at info@dbdesigner.net'
  ]

  dialog_events:
    "click button.close": "closeButtonClicked"
    "click button.back-button": "backButtonClicked"
    "click button.next-button": "nextButtonClicked"
    "click button.close-tutorial-button": "closeTutorialButtonClicked"

  initialize_dialog: ->
    @contents = HandlebarsTemplates['dialogs/tutorial_dialog']
    @currentStep = 0
    @render()

  backButtonClicked: ->
    @currentStep -= 1
    @render()
    return

  nextButtonClicked: ->
    @currentStep += 1
    @render()
    return

  closeTutorialButtonClicked: ->
    @close()
    return

  afterRender: ->
    if @currentStep == 0
      @$el.find("button.back-button").hide()
    else
      @$el.find("button.back-button").show()
    if @currentStep == dbdesigner.views.TutorialDialog.prototype.TUTORIAL_CONTENT.length - 1
      @$el.find("button.next-button").hide()
      @$el.find("button.close-tutorial-button").show()
    else
      @$el.find("button.next-button").show()
      @$el.find("button.close-tutorial-button").hide()
    return

  stepCaption: =>
    dbdesigner.views.TutorialDialog.prototype.TUTORIAL_CONTENT[@currentStep].caption

  stepContents: =>
    dbdesigner.views.TutorialDialog.prototype.TUTORIAL_CONTENT[@currentStep].contents

dbdesigner.DialogRegistry.registerDialog "tutorial", dbdesigner.views.TutorialDialog
