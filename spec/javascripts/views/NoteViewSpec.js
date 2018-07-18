describe("NoteView", function() {
  var noteView, note;

  // window.app = {};
  // window.app.schemaView = jasmine.createSpyObj('schemaView', [
  //   'findHighestZIndex',
  //   'bringViewToTop'
  // ]);

  beforeEach(function() {
    note = new dbdesigner.models.Note({
      content: 'a note'
    });
    spyOn(dbdesigner.views.NoteView.prototype, 'onModelDestroy').and.callThrough();
    spyOn(dbdesigner.views.SchemaView.prototype, 'bringViewToTop').and.callThrough();
    noteView = new dbdesigner.views.NoteView({model: note});
    setFixtures('<div class="test"></div>');
  });

  afterEach(function() {
    $(".test").empty();
  });

  it("should be valid", function() {
    expect(noteView).toBeDefined();
  });

  it("should initially show the contents", function() {
    $(".test").append(noteView.render().el);
    expect($(".test").find('span.content')).toBeVisible();
  });

  // css file is required
  //it("should initially hide the textarea", function() {
  //  $(".test").append(noteView.render().el);
  //  expect($(".test").find('textarea')).toBeHidden();
  //});

  it("should test for double click event", function() {
    expect(noteView.events['dblclick']).toBeDefined();
  });

  it("should hide the contents after double click", function() {
    $(".test").append(noteView.render().el);
    expect($(".test").find('span.content')).toBeVisible();
    $(".test").find("span.content").dblclick();
    expect($(".test").find('span.content')).toBeHidden();
  });

  it("should move to top after double click", function() {
    $(".test").append(noteView.render().el);
    $(".test").find("span.content").dblclick();
    expect(window.app.schemaView.bringViewToTop).toHaveBeenCalled();
  });

  it("should have a class of 'entity-note'", function() {
    expect(noteView.$el).toHaveClass('entity-note');
  });

  it('should render and return the view object', function() {
    expect(noteView.render()).toEqual(noteView);
  });

  it('has the correct contents', function() {
    $(".test").append(noteView.render().el);
    expect($(".test").find('span.content')).toHaveText('a note');
  });

  it("should test for reactions to Model-level events", function() {
    $(".test").append(noteView.render().el);
    expect($(".test").find('span.content')).toHaveText('a note');
    note.set('content', 'some different content');
    expect($(".test").find('span.content')).toHaveText('some different content');
  });

  it("should be destroyed when the model is destroyed", function() {
    note.destroy();
    expect(noteView.onModelDestroy).toHaveBeenCalled();
  });
});