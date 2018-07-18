class @CommandStack
  constructor: ->
    @_commands = []
    @_idx = 0
    return

  add: (cmd) ->
    if @_idx < @_commands.length
      @_commands.splice(@_idx, @_commands.length - @_idx)
    @_commands[@_idx] = cmd
    @_idx += 1
    return

  size: ->
    @_commands.length

  clear: ->
    @_idx = 0
    @_commands = []
    return

  undo: ->
    if @canUndo()
      @_idx -= 1
      @_commands[@_idx].take_back_command()
    return

  redo: ->
    if @_idx < @_commands.length
      @_commands[@_idx].apply_command()
      @_idx += 1
    return

  canUndo: ->
    @_idx > 0

  canRedo: ->
    @_idx < @_commands.length
