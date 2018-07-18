class dbdesigner.models.Comment extends Backbone.Model
  defaults:
    contents: "comment"
    own_comment: false

class dbdesigner.collections.Comments extends Backbone.Collection
  url: ->
    this.schema.url() + "/schema_comments"
  model: dbdesigner.models.Comment
  initialize: (options) ->
    @schema = options.schema
    return
