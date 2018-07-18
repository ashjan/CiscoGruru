describe("CommandStack", function() {
  var command_stack, cmd_mock;

  beforeEach(function () {
    command_stack = new CommandStack();
    cmd_mock = jasmine.createSpyObj('Command', [
          'apply_command',
          'take_back_command'
          ]);
  });

  it("should add commands to the queue", function() {
    command_stack.add(cmd_mock);
    expect(command_stack.size()).toBe(1);
  });

  it("should clear commands", function() {
    command_stack.add(cmd_mock);
    command_stack.clear();
    expect(command_stack.size()).toBe(0);
  });

  it("should not initially be undoable", function() {
    expect(command_stack.canUndo()).toBe(false);
  });

  it("should be undoable after a command is added", function() {
    command_stack.add(cmd_mock);
    expect(command_stack.canUndo()).toBe(true);
  });

  it("should not be undoable after all commands are undoed", function() {
    command_stack.add(cmd_mock);
    command_stack.undo();
    expect(command_stack.canUndo()).toBe(false);
    command_stack.undo();
    command_stack.undo();
    expect(command_stack.canUndo()).toBe(false);
    expect(command_stack.size()).toBe(1);
  });

  it("should keep the size after undo", function() {
    command_stack.add(cmd_mock);
    expect(command_stack.size()).toBe(1);
    command_stack.undo();
    expect(command_stack.size()).toBe(1);
  });

  it("should take_command_back when undo is called", function() {
    command_stack.add(cmd_mock);
    command_stack.undo();
    expect(cmd_mock.take_back_command).toHaveBeenCalled();
  });

  it("should apply command when redo is called", function() {
    command_stack.add(cmd_mock);
    command_stack.undo();
    command_stack.redo();
    expect(cmd_mock.apply_command).toHaveBeenCalled();
  });

  it("should remove unreachable commands", function() {
    for (var i = 0, len = 5; i < len; i++) {
      command_stack.add(cmd_mock);
    }
    expect(command_stack.size()).toBe(5);
    command_stack.undo();
    command_stack.undo();
    command_stack.undo();
    expect(command_stack.size()).toBe(5);
    command_stack.add(cmd_mock);
    expect(command_stack.size()).toBe(3);
  });
});

