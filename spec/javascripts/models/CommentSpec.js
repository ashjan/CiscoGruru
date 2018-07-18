describe("Comment", function() {
  var comment;

  beforeEach(function () {
    comment = new dbdesigner.models.Comment();
  });

  it("should have default properties", function() {
    expect(comment.defaults).toBeDefined();
    expect(comment.get("own_comment")).toBe(false);
  });
});
