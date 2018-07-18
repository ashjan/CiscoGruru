// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery-1.11.0
//= require jquery-ui
//= require jquery.ui.touch-punch.min
//= require jquery.ui.also-drag
//= require jquery.hotkeys
//= require jquery.scrollview
//= require nprogress
//= require underscore
//= require backbone
//= require handlebars.runtime

//= require lib/logger
//= require lib/settings
//= require lib/utils
//= require lib/command
//= require lib/command_stack
//= require lib/browser
//= require lib/rect

//= require app
//= require datatypes
//= require_tree ./templates
//= require_tree ./locale

//= require commands/command_factory
//= require commands/note_create
//= require commands/note_content
//= require commands/note_move
//= require commands/note_resize
//= require commands/table_create
//= require commands/table_move
//= require commands/table_rename
//= require commands/table_change
//= require commands/table_sort
//= require commands/field_create
//= require commands/field_change
//= require commands/schema_sort
//= require commands/entity_move

//= require models/table
//= require models/note
//= require models/schema
//= require models/user
//= require models/comment
//= require models/collaborator

//= require views/lib/basemenuview
//= require views/lib/popupmenuview
//= require views/lib/container

//= require views/minimapview
//= require views/schemaview
//= require views/canvasview
//= require views/menuview
//= require views/trackable_view
//= require views/fieldview
//= require views/newfieldview
//= require views/foreignkeypanelview
//= require views/tableview
//= require views/noteview
//= require views/notificationview
//= require views/sidebarview
//= require views/commentview

//= require views/panels/base
//= require views/panels/comments
//= require views/panels/properties
//= require views/panels/collaboration
//= require views/panels/history

//= require views/dialogs/dialog_manager
//= require views/dialogs/basedialog
//= require views/dialogs/newschemadialog
//= require views/dialogs/loaddialog
//= require views/dialogs/templatesdialog
//= require views/dialogs/saveasdialog
//= require views/dialogs/propertiesdialog
//= require views/dialogs/importsqldialog
//= require views/dialogs/optionsdialog
//= require views/dialogs/sharedialog
//= require views/dialogs/exportsqldialog
//= require views/dialogs/exportimagedialog
//= require views/dialogs/helpdialog
//= require views/dialogs/changesdialog
//= require views/dialogs/shortcutshelpdialog
//= require views/dialogs/feedbackdialog
//= require views/dialogs/aboutdialog
//= require views/dialogs/logindialog
//= require views/dialogs/settingsdialog
//= require views/dialogs/dirtyschemaconfirmationdialog
//= require views/dialogs/tutorialdialog
