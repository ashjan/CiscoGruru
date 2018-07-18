describe("ForeignKeyPanelView", function() {
  var foreignKeyPanelView;

  beforeEach(function() {
    foreignKeyPanelView = new dbdesigner.views.ForeignKeyPanelView();
    setFixtures('<div class="test"></div>');
  });

  afterEach(function() {
    $(".test").empty();
  });

  it("should be valid", function() {
    expect(foreignKeyPanelView).toBeDefined();
  });

  it("should be visible when rendered", function() {
    $(".test").append(foreignKeyPanelView.render().el);
    expect($(".test").find('div.refs')).toBeVisible();
  });

  it("should add new tables to combobox", function() {
    $(".test").append(foreignKeyPanelView.render().el);
    app.schema.addTable({
      left: 100,
      top: 100,
      name: 'foo',
      idx: 20001,
      fields: []
    });
    expect($(".test").find(".field-ref-table option[value='foo']").length).toBe(1);
  });

  it("should remove the deleted tables from the combobox", function() {
    $(".test").append(foreignKeyPanelView.render().el);
    expect($(".test").find(".field-ref-table option[value='foo']").length).toBe(1);
    app.schema.tables.findWhere({idx: 20001}).destroy()
    expect($(".test").find(".field-ref-table option[value='foo']").length).toBe(0);
  });
});

