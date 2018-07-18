describe("TableCreateSpec", function() {
  var schema,
      factory;

  beforeEach(function() {
    schema = {
      addTable: function() {
        return 42;
      }
    };
    factory = new CommandFactory();
    factory.schema = schema;
  });

  it("should create a new table on the schema", function() {
    var command = factory.createCommand(Command.prototype.TABLE_CREATE, {});

    spyOn(schema, 'addTable');
    command.apply_command();
    expect(schema.addTable).toHaveBeenCalled();
  });

  it("should destroy a table when executed backwards", function() {
    var command = factory.createCommand(Command.prototype.TABLE_CREATE, {idx: 1});
    var table = {
      idx: 1,
      destroy: function() {}
    };
    schema.tables = _([table]);
    spyOn(table, 'destroy');
    command.take_back_command();
    expect(table.destroy).toHaveBeenCalled();
  });

  it("should assign an idx to data params after creating the table", function() {
    var data = {};

    var command = factory.createCommand(Command.prototype.TABLE_CREATE, data);
    command.apply_command();
    expect(data.idx).toBe(42);
  });
});
