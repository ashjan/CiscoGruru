class dbdesigner.views.ExportImageDialog extends dbdesigner.views.DialogView
  width: 640
  height: 480
  caption: "dialog.export_image"
  windowClass: 'export-image-dialog'
  hasBottomBar: true
  rightButtons: ->
    [
      caption: Handlebars.helpers.t('dialog.close')
      className: "close"
    ]
  leftButtons: ->
    [
      caption: Handlebars.helpers.t('dialog.export_image_zoomin')
      className: "zoom-in"
    ,
      caption: Handlebars.helpers.t('dialog.export_image_zoomout')
      className: 'zoom-out'
    ,
      caption: Handlebars.helpers.t('dialog.export_image_reset')
      className: 'zoom-reset'
    ,
      caption: Handlebars.helpers.t('dialog.export_image_open_in_new_tab')
      className: 'open-in-new-tab'
    ]

  dialog_events:
    "click button.close": "closeButtonClicked"
    "click button.zoom-out": "zoomOutClicked"
    "click button.zoom-in": "zoomInClicked"
    "click button.zoom-reset": "zoomResetClicked"
    "click button.open-in-new-tab": "openInNewTabClicked"

  initialize_dialog: ->
    $("span.cancel-edit-table").click()
    @contents = HandlebarsTemplates['dialogs/export_image_dialog']
    true

  afterRender: =>
    canvasEl = document.createElement("canvas")
    canvasMng = new dbdesigner.views.CanvasView(el: canvasEl, temporary: true)
    canvasMng.renderToImage()
    @$(".contents").html("""<img src="#{canvasEl.toDataURL("image/png")}" class="exp_image" />""")
    @original_width = null
    @$(".contents").scrollview
      grab: '/cursors/openhand.cur'
      grabbing: '/cursors/closedhand.cur'
    _.defer =>
      if renv is 'production'
        ga('send', 'event', 'schema', 'image', 'id', app.schema.id)
    this

  zoomInClicked: ->
    @original_width ||= @$("img.exp_image").width()
    @_width = @$("img.exp_image").width()
    @$("img.exp_image").css
      width: @_width * 1.1

  zoomOutClicked: ->
    @original_width ||= @$("img.exp_image").width()
    @_width = @$("img.exp_image").width()
    @$("img.exp_image").css
      width: @_width * 0.9

  zoomResetClicked: ->
    return unless @original_width
    @$("img.exp_image").css
      width: @original_width

  openInNewTabClicked: ->
    image = new Image()
    image.src = @$(".contents img").attr("src")
    w = window.open("")
    w.document.write(image.outerHTML)
    null

dbdesigner.DialogRegistry.registerDialog 'exportImage', dbdesigner.views.ExportImageDialog
