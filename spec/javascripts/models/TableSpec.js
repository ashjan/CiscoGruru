describe("Table", function() {
  var table;

  beforeEach(function () {
    table = new dbdesigner.models.Table();
  });

  it("should have default properties", function() {
    expect(table.defaults).toBeDefined();
  });

  it("should have fields", function() {
  	expect(table.get("fields")).toBeDefined();
  });

  it("should have and empty fields collection", function() {
  	expect(table.get("fields").length).toBe(0);
  });

  it("should have an add fields method", function() {
  	expect(table.addFields).toBeDefined();
  });

  //it("should add fields", function() {
    // var new_field =
    //    title: 'test'
    // table.addFields([new_field]);
    // expect(table.get("fields").length).toBe(1);
  //});
});
