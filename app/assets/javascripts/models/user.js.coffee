class dbdesigner.models.User extends Backbone.Model
  urlRoot: "/user"

  defaults:
    email: "none"
    username: "Guest"
    login: false

  saveProfile: (opts) =>
    xhr = $.post '/users/update_profile',
      user: opts
    xhr.done (r) =>
      @set('username', r.username)
      @set('email', r.email)
      this

  logout: ->
    xhr = $.post '/logout'
    xhr.done (r) =>
      app.user.set
        login: false
      app.showNotification("You have logged out.")
    @set 'login', false
