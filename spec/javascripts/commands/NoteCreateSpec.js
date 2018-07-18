describe("NoteCreateSpec", function() {
  var schema,
      factory;

  beforeEach(function() {
    schema = {
      addNote: function() {}
    };
    factory = new CommandFactory();
    factory.schema = schema;
  });

  it("should create a new note on the schema", function() {
    var command = factory.createCommand(Command.prototype.NOTE_CREATE, {});

    spyOn(schema, 'addNote');
    command.apply_command();
    expect(schema.addNote).toHaveBeenCalled();
  });

  it("should destroy a note when executed backwards", function() {
    var command = factory.createCommand(Command.prototype.NOTE_CREATE, {idx: 1});
    var note = {
      idx: 1,
      destroy: function() {}
    };
    schema.notes = _([note]);
    spyOn(note, 'destroy');
    command.take_back_command();
    expect(note.destroy).toHaveBeenCalled();
  });
});
