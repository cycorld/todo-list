$(document).on('turbolinks:load', function() {
  $('.item').bind('dblclick', function() {
    $(this).attr('contentEditable', true)
      .keypress(function(e) {
        if (e.which == 13) {
          $.ajax({url: '/todos/' + $(this).data('id'),
                 type: 'patch',
                 data: {item: $(this).text()}});
          return false;
        }
      });
  }).blur(function() {
    $(this).attr('contentEditable', false);
  });
});
