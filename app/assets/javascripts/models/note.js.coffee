class dbdesigner.models.Note extends Backbone.Model
  defaults:
    left: 10
    top: 38
    width: 180
    height: 130
    content: "Double click to edit this note. Shift + Enter to save your changes.\r\n\r\nYou can drag it to move around. Hold down shift for snap to grid."
    #content: Handlebars.helpers.t("designer.default_note_content")

  get_idx: -> @get("idx")

class dbdesigner.collections.Notes extends Backbone.Collection
  model: dbdesigner.models.Note