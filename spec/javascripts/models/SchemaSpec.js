describe("Schema", function() {
  var schema;

  beforeEach(function() {
    schema = new dbdesigner.models.Schema;
  });

  it("should have default values", function() {
    expect(schema.get('title')).toBe('Untitled');
    expect(schema.get('db')).toBe('generic');
    expect(schema.get('template')).toBe(false);
  });

  it("should serialize itself", function() {
    expect(schema.serialize()).toEqual({
      title: 'Untitled',
      notes: [],
      tables: [],
      db: 'generic'
    });
  });

  it("should serialize itself for db type", function() {
    expect(schema.serializeForDb('mysql')).toEqual({
      title: 'Untitled',
      notes: [],
      tables: [],
      db: 'mysql'
    });
  });


  it("should have notes", function() {
    expect(schema.notes).toBeDefined();
    expect(schema.addNote).toBeDefined();
    expect(schema.removeNote).toBeDefined();
  });

  it("should add notes", function() {
    schema.addNote(new dbdesigner.models.Note);
    expect(schema.notes.length).toBe(1);
  });

  it("should remove notes", function() {
    var note = new dbdesigner.models.Note;
    schema.addNote(note);

    expect(schema.notes.length).toBe(1);
    schema.removeNote(note);
    expect(schema.notes.length).toBe(0);
  });

  it("should have tables", function() {
    expect(schema.tables).toBeDefined();
  });

  it("should have collaborators", function() {
    expect(schema.collaborators).toBeDefined();
  });

  it("should have comments", function() {
    expect(schema.comments).toBeDefined();
  });
});
