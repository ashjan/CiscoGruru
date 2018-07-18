class @Rect
  constructor: (@left, @top, @width, @height) ->
    return

  normalize: ->
    if @width < 0
      @left += @width
      @width *= -1
    if @height < 0
      @top += @height
      @height *= -1
    return this

  pack: ->
    left: @left
    top: @top
    width: @width
    height: @height

  doesInclude: (r) ->
    @left < r.left and @top < r.top and @bottom() > r.bottom() and @right() > r.right()

  bottom: ->
    @top + @height

  right: ->
    @left + @width