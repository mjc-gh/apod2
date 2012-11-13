(function(){
  var win = $(window);
  var doc = $(document);

  var pictures = $('#pictures');
  var loading = $('#loading');

  var has_no_more = false;
  var is_loading = false;

  function load(pics){
    is_loading = false;
    loading.fadeOut();

    if (pics.length === 0){
      has_no_more = true;
      return;
    }

    for (var i = 0, pic; pic = pics[i]; i++){
      var href = '/pictures/'+ pic.apid;
      var tmpl = template('picture-tmpl', {
        href: href, media: pic.media || 'No Image'
      });

      pictures.append(tmpl);
    }
  }

  win.on('scroll', function(ev){
    if (has_no_more || is_loading) return;

    if (win.scrollTop() + 1 >= doc.height() - win.height()) {
      is_loading = true;

      var last = pictures.children().last().find('a');
      var apid = last.attr('href').split('/').pop();

      loading.fadeIn();

      $.get('/pictures', { last: apid }, load, 'json');
    }
  });
}());
