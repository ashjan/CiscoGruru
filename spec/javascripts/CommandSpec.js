describe("Command", function() {
  var command;

  beforeEach(function() {
    command = new Command(Command.prototype.NOTE_CREATE, {foo: 'bar'});
  });

  it("should have default properties", function() {
    expect(command.created_at).toBeDefined();
  });

  it("should serialize into JSON", function() {
    expect(command.toJSON()).toEqual({
      type: Command.prototype.NOTE_CREATE,
      data: {
        foo: 'bar',
        scrollTop: null,
        scrollLeft: null
      }
    })
  });

  it("should have apply and take back methods", function() {
    expect(command.apply_command).toBeDefined();
    expect(command.take_back_command).toBeDefined();
  });
});
