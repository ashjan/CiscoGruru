//= require jquery
//= require bootstrap-sprockets
//= require jquery.fancybox.pack

function fix_footer() {
  $('body').css('margin-bottom', $('.footer').height());
}

$(window).resize(function() {
  fix_footer();
});

$(function() {
  $(".fancybox")
      .attr('rel', 'gallery')
      .fancybox({padding: 0});

  $("span.edit-account").on("click", function() {
    $("div.account-fields-edit").show();
    $("div.account-fields-show").hide();
    $("span.edit-account").hide();
    $("button.save-account").show();
    $("span.cancel-edit-account").show();
  });
  $("span.cancel-edit-account").on("click", function() {
    $("div.account-fields-edit").hide();
    $("div.account-fields-show").show();
    $("span.edit-account").show();
    $("button.save-account").hide();
    $("span.cancel-edit-account").hide();
  });

  fix_footer();
});
