class dbdesigner.models.Collaborator extends Backbone.Model
  defaults:
    email: "none"
    username: "Guest"
  access_str: ->
    switch parseInt(@get("access_mode"), 10)
      when 0 then Handlebars.helpers.t("dialog.share_read_only")
      when 1 then Handlebars.helpers.t("dialog.share_read_write")

class dbdesigner.collections.Collaborators extends Backbone.Collection
  url: ->
    this.schema.url() + "/collaborators"
  model: dbdesigner.models.Collaborator
  initialize: (options) ->
    @schema = options.schema
    return
