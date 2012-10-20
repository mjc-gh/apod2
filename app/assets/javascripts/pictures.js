$(function(){
	var win = $(window);
	var body = document.body;

	var pictures = $('#pictures');
	var nomore = false;

	function load(pics){
		if (pics.length === 0)
			nomore = true;

		for (var i = 0, pic; pic = pics[i]; i++){
			var href = '/pictures/'+ pic.apid;
			var tmpl = template('picture-tmpl', {
				href: href, media: pic.media || 'No Image'
			});

			pictures.append(tmpl);
		}
	}

	$(window).on('scroll', function(ev){
		if (body.scrollHeight - win.scrollTop() > win.height()) return;
		if (nomore) return;

		var last = pictures.children().last().find('a');
		var apid = last.attr('href').split('/').pop();

		$.get('/pictures', { last: apid }, load, 'json');
	});
});
