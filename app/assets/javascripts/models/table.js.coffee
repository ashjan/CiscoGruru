class dbdesigner.models.Table extends Backbone.Model
  defaults:
    left: 100
    top: 100
    name: "Untitled"
    comment: ""

  initialize: ->
    @set 'fields', new dbdesigner.collections.Fields
    @listenTo @, "destroy", =>
      _fields = @get "fields"
      while field = _fields.pop()
        field.destroy()
      _fields.reset()
      _fields = null
      @set 'fields', null
      @stopListening()

  addFields: (fields) ->
    _fields = @get "fields"
    for field in fields
      if !field.idx
        field.idx = app.schema._get_entity_idx()
      else if field.idx < 10000
        field.idx = app.schema._get_entity_idx()
      _fields.add field
    @set "fields", _fields

  addField: (field) ->
    _fields = @get "fields"
    if !field.idx
      field.idx = app.schema._get_entity_idx()
    else if field.idx < 10000
      field.idx = app.schema._get_entity_idx()
    _fields.add field
    @set "fields", _fields
    field.idx

  get_idx: -> @get("idx")

class dbdesigner.collections.Tables extends Backbone.Collection
  model: dbdesigner.models.Table

class dbdesigner.models.Field extends Backbone.Model
  defaults:
    allow_null: true
    order: 0

class dbdesigner.collections.Fields extends Backbone.Collection
  model: dbdesigner.models.Field
  comparator: (field) ->
    field.get "order"
