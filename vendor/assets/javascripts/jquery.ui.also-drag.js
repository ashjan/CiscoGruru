(function($) {

  $.ui.plugin.add("draggable", "alsoDrag", {
    start: function() {
      var options = $(this).data("ui-draggable").options,
          alsoDragElements = options.alsoDrag;

      if (typeof(alsoDragElements) === "object" && !alsoDragElements.parentNode) {
        if (alsoDragElements.length) {
          alsoDragElements = alsoDragElements[0];
          storePositions(alsoDragElements);
        } else {
          $.each(alsoDragElements, function (exp) {
            storePositions(exp);
          });
        }
      } else {
        storePositions(alsoDragElements);
      }
    },
    drag: function () {
      var $el = $(this).data("ui-draggable"),
          alsoDragElements = $el.options.alsoDrag,
          delta = {
            top: ($el.position.top - $el.originalPosition.top) || 0, 
            left: ($el.position.left - $el.originalPosition.left) || 0
          };

      if (typeof(alsoDragElements) === "object" && !alsoDragElements.nodeType) {
        $.each(alsoDragElements, function (exp) {
          applyPositions(exp, delta);
        });
      } else {
        applyPositions(alsoDragElements, delta);
      }
    },
    stop: function() {
      $(this).removeData("draggable-also-drag");
    }
  });

  function storePositions(exp) {
    $(exp).each(function() {
      var el = $(this);

      el.data("ui-draggable-also-drag", {
        top: parseInt(el.css("top"), 10),
        left: parseInt(el.css("left"), 10)
      });
    });    
  }

  function applyPositions(exp, delta) {
    $(exp).each(function() {
      var start = $(this).data("ui-draggable-also-drag");

      $(this).css({
        top: (start["top"] || 0) + (delta["top"] || 0) || null,
        left: (start["left"] || 0) + (delta["left"] || 0) || null,
      });
    });
  }

})(jQuery);
