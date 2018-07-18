class Backbone.Container extends Backbone.View
  _views = []

  initialize: (options) ->
    initializeContainer(options)
    return

  render: ->
    @beforeRender()
    @afterRender()
    this

  beforeRender: ->
  afterRender: ->