class dbdesigner.views.CanvasView extends Backbone.View
  initialize: (options) ->
    @lineType = app.settings.read("lineType")
    unless options.temporary
      app.vent.on 'fieldWillMove', @clearLines
      app.vent.on 'fieldMoved', @drawLines
      @isTemporary = false
    else
      @isTemporary = true
      app.logger.info "Creating temporary canvas"
    @lineColor = app.settings.read("lineColor")
    @canvas_scroll_top = $("div.canvas-container").scrollTop()
    @canvas_scroll_left = $("div.canvas-container").scrollLeft()
    return

  setLineType: (@lineType) ->
    app.settings.set("lineType", @lineType)
    @refresh()

  setLineColor: (@lineColor) ->
    @refresh()

  refresh: ->
    unless app.schema.loading == true
      @clearLines()
      # @_cache = new CoordinateCache()
      @drawLines()
      # console.log @_cache.stats()
      # @_cache = null;
      app.logger.info "Canvas refreshed"
    this

  drawLines: =>
    @renderConnections()

  clearLines: =>
    @context.clearRect 0, 0, 10000, 10000

  relativeOffset: (element) ->
    offset = $(element).offset()
    if @isTemporary
      return offset
    return {
      top: offset.top + @canvas_scroll_top - 28,
      left: offset.left + @canvas_scroll_left
    }

  drawLine: (p1, p2, p3, p4, p5, p6) ->
    if @lineType is 'BEZIER'
      @context.bezierCurveTo p1, p2, p3, p4, p5, p6
    else
      @context.lineTo p1, p2
      @context.lineTo p3, p4
      @context.lineTo p5, p6

  connectFields: (f1, f2, lineColor, cc) ->
    o1 = @relativeOffset(f1)
    o2 = @relativeOffset(f2)
    field_middle = (o1.left + o2.left + $(f2).width()) / 2
    f1_top = o1.top + $(f1).height() / 2
    f2_top = o2.top + $(f2).height() / 2
    f1_width = $(f1).width()
    f2_width = $(f2).width()
    lineOffset = 10
    @context.save()
    @context.fillStyle = lineColor
    @context.strokeStyle = lineColor
    @context.beginPath()
    if o1.left > o2.left + f2_width + 80
      @context.moveTo o1.left - lineOffset, f1_top
      @drawLine field_middle, f1_top, field_middle, f2_top, o2.left + f2_width + lineOffset, f2_top
      @context.stroke()
      @context.beginPath()
      @context.moveTo o2.left + f2_width + 15, f2_top - 5
      @context.lineTo o2.left + f2_width + 15, f2_top + 5
      @context.lineTo o2.left + f2_width + 5, f2_top
      @context.lineTo o2.left + f2_width + 15, f2_top - 5
      @context.fill()
    else if o2.left > o1.left + f1_width + 80
      @context.moveTo o2.left - lineOffset, f2_top
      @drawLine field_middle, f2_top, field_middle, f1_top, o1.left + f1_width + lineOffset, f1_top
      @context.stroke()
      @context.beginPath()
      @context.moveTo o2.left - 15, f2_top - 5
      @context.lineTo o2.left - 15, f2_top + 5
      @context.lineTo o2.left - 5, f2_top
      @context.lineTo o2.left - 15, f2_top - 5
      @context.fill()
    else
      @context.moveTo o1.left - lineOffset, f1_top
      @drawLine Math.min(o1.left-40, o2.left-40), f1_top, Math.min(o1.left-40, o2.left-40), f2_top, o2.left-lineOffset, f2_top
      @context.stroke()
      @context.beginPath()
      @context.moveTo o2.left - 15, f2_top - 5
      @context.lineTo o2.left - 15, f2_top + 5
      @context.lineTo o2.left - 5, f2_top
      @context.lineTo o2.left - 15, f2_top - 5
      @context.fill()
    @context.restore()

  _draw_rect: (x, y, w, h) ->
    @context.lineWidth = 1
    @context.strokeStyle = "#000000"
    @context.moveTo x, y
    @context.lineTo x + w, y
    @context.stroke()
    @context.moveTo x + w, y
    @context.lineTo x + w, y + h
    @context.stroke()
    @context.moveTo x + w, y + h
    @context.lineTo x, y + h
    @context.stroke()
    @context.moveTo x, y + h
    @context.lineTo x, y
    @context.stroke()

  drawDomElement: (el) ->
    if $(el).is("textarea") and !$(el).hasClass("table-comment-box")
      return
    return if $(el).is ":hidden"
    ro = @relativeOffset(el)
    ow = $(el).outerWidth()
    oh = $(el).outerHeight()
    @context.save()
    if not $(el).is "td"
      # first draw shadow if it is a table or note
      if $(el).is("table") or $(el).is("div.entity-note")
        @context.shadowBlur = 5
        @context.shadowOffsetX = 2
        @context.shadowOffsetY = 2
        @context.shadowColor = 'rgb(136, 136, 136)'
    @context.fillStyle = $(el).css("backgroundColor")
    @context.strokeStyle = "#000000"
    if $(el).is "table"
      @context.fillRect ro.left + 0.5, ro.top + 0.5, ow, oh - $("tfoot", el).outerHeight()
    else
      @context.fillRect ro.left + 0.5, ro.top + 0.5, ow, oh
    if $(el).is("table") or $(el).is("div.entity-note")
      ## @context.strokeRect @relativeOffset(el).top.left + 0.5, @relativeOffset(el).top.top + 0.5, $(el).outerWidth(), $(el).outerHeight()
      @context.restore()
    if $(el).is("tr") or $(el).is("div.entity-note")
      if !$(el).is("tfoot>tr") and !$(el).is("thead")
        @context.lineWidth = 1
        @context.strokeStyle = "#313131"
        #@context.strokeRect @relativeOffset(el).top.left + 0.5, @relativeOffset(el).top.top + 0.5, $(el).outerWidth(), $(el).outerHeight()
        @context.strokeRect ro.left + 0.5, ro.top + 0.5, ow, oh
    # @_draw_rect $(el).offset().left, $(el).offset().top, $(el).width(), $(el).height()
    if $(el).is("tfoot")
      #	@context.strokeStyle = "#000000"
      #	@context.strokeRect $(el).offset().left, $(el).offset().top, $(el).outerWidth(), $(el).outerHeight()
      @context.restore()
      return
    if $(el).hasClass("table-comment-box") or $(el).hasClass("pk-field") or $(el).hasClass("fk-field") or $(el).hasClass("not-null") or ($(el).text() and ($(el).is("td") or $(el).is("th") or $(el).is("span")))
      @context.fillStyle = $(el).css("color")
      if $(el).is("th")
        @context.font = "bold 13px Arial, sans-serif"
      else if $(el).hasClass("table-comment-box")
        @context.font = "400 12px source_sans_proregular, sans-serif"
      else
        @context.font = "400 12px Arial, sans-serif"
      if $(el).is("span")
        @drawText el
      else if $(el).hasClass("table-comment-box")
        @drawText el
      else
        # if $(el).is "td"
        #   $(el).hide()
        x = ro.left + 3
        y = ro.top
        if $(el).hasClass('pk-field')
          if $(el).hasClass('auto-increment') and (app.settings.read("show_auto_increment") == "true")
            @context.drawImage $("#cache-image-key-ai").get(0), x, y + 3
          else
            @context.drawImage $("#cache-image-key").get(0), x, y + 3
          x += 20
        if $(el).hasClass('fk-field') && app.settings.read("show_fk_icon") == "true"
          @context.drawImage $("#cache-image-fk").get(0), x, y + 3
          x += 20
        if $(el).hasClass('not-null') && app.settings.read("show_not_null") == "true"
          @context.drawImage $("#cache-image-nn").get(0), x, y + 3
          x += 20
        if !$(el).hasClass('pk-field') && $(el).hasClass('auto-increment') && app.settings.read("show_auto_increment") == "true"
          @context.drawImage $("#cache-image-ai").get(0), x, y + 3
          x += 20
        if $(el).hasClass 'field_type'
          x += 5
        if !$(el).hasClass("table-comment")
          @context.fillText $(el).text(), x, y + $(el).height() - 3
      @context.restore()
    $(el).children().each (idx, c) =>
      @drawDomElement c

  drawText: (el) ->
    x_start = $(el).offset().left + 3
    y_start = $(el).offset().top
    if $(el).hasClass("table-comment-box")
      box_height = $(el).height()
    else
      box_height = $(el).parents("div.entity-note").height()
    box_height = box_height - 6
    # if $.browser.msie
    #   lineHeight = "13px"
    # else
    #   # fucking ie returns 1
    #   lineHeight = parseInt($(el).css("lineHeight"))
    lineHeight = parseInt($(el).css("lineHeight"), 10) + 3
    if $(el).hasClass("table-comment-box")
      lineHeight = 13
    x = x_start
    y = y_start + lineHeight
    if $(el).hasClass("table-comment-box")
      text = $(el).val()
    else
      text = $(el).text()

    tokens = text.split ' '
    idx = 0
    len = tokens.length
    while idx < len
      ch = tokens[idx]
      #for ch, idx in $(el).text().split ' '
      had_new_line = false
      if ch.indexOf("\n") != -1
        lines = ch.split("\n")
        ch = lines.shift()
        tokens[idx] = lines.join "\n"
        had_new_line = true
      w = @context.measureText(ch).width
      if x - x_start + w > $(el).width()
        x = x_start
        y += lineHeight
      if y - y_start - lineHeight >= box_height
        return
      @context.fillText ch, x, y
      x += w + 5
      if had_new_line
        x = x_start
        y += lineHeight
      else
        idx += 1

  renderConnections: ->
    @canvas_scroll_top = $("div.canvas-container").scrollTop()
    @canvas_scroll_left = $("div.canvas-container").scrollLeft()
    invert_line_direction = app.settings.read("invert_line_direction")
    cc = $("div.canvas-container").offset()
    @context.lineWidth = 1
    @context.strokeStyle = @lineColor #app.settings.get('lineColor')
    _(app.schemaView.table_views).each (view) =>
      _(view.foreignKeyFields()).each (field) =>
        $fromCell = field.$el
        target_table_name = field.model.get("fk_table")
        target_field_name = field.model.get("fk_field")
        toTable = _(app.schemaView.table_views).detect (v) -> v.model.get("name") is target_table_name
        unless toTable
          # app.logger.warn "can't find #{target_table_name}"
          return
        toCell = _(toTable.field_views).detect (v) -> v.model.get("name") is target_field_name
        unless toCell
          # app.logger.warn "can't find #{target_field_name}"
          return
        if toTable.model.has "color"
          lineColor = toTable.model.get "color"
        else
          lineColor = @lineColor
        $toCell = toCell.$el
        if invert_line_direction == "true"
          @connectFields($toCell, $fromCell, lineColor, cc)
        else
          @connectFields($fromCell, $toCell, lineColor, cc)
        # app.logger.info "FIELD: #{field.model.get("fk_table")}:#{field.model.get("fk_field")}"
      #console.log("view #{v} fk list: #{v.foreignKeyFields().length}")
    #@model.connections.each (c) =>
    #	$fromTable = $("table[data-table-name=#{c.get("fromTable")}]")
    #	$fromCell = $("tr[data-field-name=#{c.get("fromField")}]", $fromTable)
    #	$toTable = $("table[data-table-name=#{c.get("toTable")}]")
    #	$toCell = $("tr[data-field-name=#{c.get("toField")}]", $toTable)
    #	@connectFields($fromCell, $toCell)

  renderToImage: ->
    findOffset = (e) =>
      o = @relativeOffset(e)
      return {
        top: o.top
        left: o.left
        right: o.left + $(e).width()
        bottom: o.top + $(e).height()
      }
    $("div.canvas-container").scrollTop(0)
    $("div.canvas-container").scrollLeft(0)
    @canvas_scroll_top = $("div.canvas-container").scrollTop()
    @canvas_scroll_left = $("div.canvas-container").scrollLeft()
    $(".cancel-save").click()
    maxRight = 200
    maxBottom = 200
    findMax = (elements) ->
      for element in elements
        offset = findOffset $(element).get(0)
        maxRight = offset.right if offset.right > maxRight
        maxBottom = offset.bottom if offset.bottom > maxBottom
    findMax $("table.entity-table")
    findMax $("div.entity-note")
    maxRight += 50
    maxBottom += 50
    @calcWidth = maxRight
    @calcHeight = maxBottom
    $(@el).attr "width", maxRight
    $(@el).attr "height", maxBottom
    @context = @el.getContext "2d"
    @context.fillStyle = "#ffffff"
    @context.fillRect 0, 0, maxRight, maxBottom
    unless $("#graph").hasClass "hide-grid"
      for i in [0..maxRight/80]
        for j in [0..maxBottom/80]
          @context.drawImage $("#cache-image-bg").get(0), i*80, j*80
    @renderConnections()
    elements = $("table.entity-table,div.entity-note").toArray()
    elements.sort (a, b) ->
      Number(a.style.zIndex) - Number(b.style.zIndex)
    @drawDomElement elem for elem in elements
    @context.font = "400 16px Arial, sans-serif"
    @context.fillStyle = "#888888"
    @context.drawImage $("#cache-image-bw-logo").get(0), 10, 10
    @context.fillText 'dbdesigner.net', 49, 31
    return

  recalculateCanvasSize: ->
    if app.schema.loading == true
      return
    @canvas_scroll_top = $("div.canvas-container").scrollTop()
    @canvas_scroll_left = $("div.canvas-container").scrollLeft()
    findOffset = (e) =>
      o = @relativeOffset(e)
      return {
        top: o.top
        left: o.left
        right: o.left + $(e).width()
        bottom: o.top + $(e).height()
      }
    maxRight = 3740
    maxBottom = 2300
    findMax = (elements) ->
      for element in elements
        offset = findOffset $(element).get(0)
        maxRight = offset.right if offset.right > maxRight
        maxBottom = offset.bottom if offset.bottom > maxBottom
    findMax $("table.entity-table")
    findMax $("div.entity-note")
    maxRight += 100
    maxBottom += 100
    if (parseInt($("canvas#graph").attr("width"), 10) isnt maxRight) or (parseInt($("canvas#graph").attr("height"), 10) isnt maxBottom)
      $("canvas#graph").attr("width", maxRight)
      $("canvas#graph").attr("height", maxBottom)
      $("body").trigger("designer:canvas_size_changed", {width: maxRight, height: maxBottom})
      _.defer =>
        @clearLines()
        @renderConnections()
    return

  render: =>
    if @$el.get(0).getContext == undefined
      @context = G_vmlCanvasManager?.initElement(@$el.get(0)).getContext "2d"
    else
      @context = @$el.get(0).getContext "2d"
    @context.lineWidth = 1
    #@context.strokeStyle = app.settings.get('lineColor')
    @context.strokeStyle = @lineColor
    _.defer =>
      @clearLines()
      @renderConnections()
    this
