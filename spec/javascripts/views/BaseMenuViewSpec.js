describe("BaseMenuView", function() {
  var baseMenuView;

  beforeEach(function() {
    baseMenuView = new dbdesigner.views.BaseMenuView();
    setFixtures('<div id="page"></div>');
  });

  afterEach(function() {
    $("#page").empty();
  });

  it("should be valid", function() {
    expect(baseMenuView).toBeDefined();
  });

  it("should setup events", function() {
    expect(baseMenuView.events['mouseover ul.menu>li']).toBeDefined();
    expect(baseMenuView.events['click ul.menu>li']).toBeDefined();
    expect(baseMenuView.events['click ul.submenu>li']).toBeDefined();
    expect(baseMenuView.events['mouseover ul.menu>li>ul>li.has-submenu']).toBeDefined();
    expect(baseMenuView.events['mouseout ul.menu>li>ul>li.has-submenu']).toBeDefined();
  });

  it("should render", function() {
    $("#page").append(baseMenuView.render().el);
    expect($("#page").find('div.toolbar')).toBeVisible();
  });

  it("should hide menus when page is clicked", function() {
    $("#page").append(baseMenuView.render().el);
    spyOn(dbdesigner.views.BaseMenuView.prototype, 'hideMenus').and.callThrough();
    $("#page").mousedown();
    expect(baseMenuView.hideMenus).toHaveBeenCalled();
  });
});