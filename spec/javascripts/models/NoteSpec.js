describe("Note", function() {
  var note;

  beforeEach(function () {
    note = new dbdesigner.models.Note();
  });

  it("should have default properties", function() {
    expect(note.defaults).toBeDefined();
    expect(note.get('left')).toBeDefined();
    expect(note.get('top')).toBeDefined();
    expect(note.get('width')).toBeDefined();
    expect(note.get('height')).toBeDefined();
    expect(note.get('content')).toBeDefined();
  });
});
