describe("Settings", function() {
  var settings;

  it("expects default values", function() {
    expect(function() {
      var settings = new Settings();
    }).toThrow();
  });

  it("should read the set values", function() {
    var settings = new Settings({});

    settings.set("foo", "bar");
    expect(settings.read("foo")).toBe("bar");
  });

  it("should return default values for missing keys", function() {
    var settings = new Settings({
      foo: "bar"
    });
    expect(settings.read("foo")).toBe("bar");
  });
});