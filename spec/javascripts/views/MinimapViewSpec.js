describe("MinimapView", function() {
  var minimapView;

  beforeEach(function() {
    minimapView = new dbdesigner.views.MinimapView({
      schemaView: new Backbone.View
    });
    spyOn(dbdesigner.views.MinimapView.prototype, 'onMouseDown').and.callThrough();
    setFixtures('<div class="test"></div>');
  });

  afterEach(function() {
    $(".test").empty();
  });

  it("should be valid", function() {
    expect(minimapView).toBeDefined();
  });

  it("should initially be visible", function() {
    $(".test").append(minimapView.render().el);
    expect($(".test").find('div.minimap')).toBeVisible();
  });

  it("should handle mousedown events", function() {
    $(".test").append(minimapView.render().el);

    expect(minimapView.events['mousedown']).toBeDefined();
    expect($('.test div.minimap').length).toBe(1);
    // $('.test div.minimap').mousedown();
    // expect(minimapView.mousedown).toHaveBeenCalled();
  });

  it("should be hidden after toggling", function() {
    $(".test").append(minimapView.render().el);
    expect($(".test").find('div.minimap')).toBeVisible();
    expect(minimapView.is_hidden()).toBe(false);
    minimapView.toggle();
    expect($(".test").find('div.minimap')).not.toBeVisible();
    expect(minimapView.is_hidden()).toBe(true);
  });
});