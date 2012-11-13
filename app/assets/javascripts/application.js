// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs


(function(){
	// realy simple micro-template function that does super-basic
	// string replace using Object property names
	//
	// returns a jQuery object
	var cache = {};

	this.template = function(str, obj){
		var tmpl = cache[str] || document.getElementById(str).innerHTML;

		for (var i in obj)
			tmpl = tmpl.replace('__'+ i.toUpperCase(), obj[i]);

		return $(tmpl);
	};
}());

$(function(){
	if (location.pathname != '/')
		return;

	var top = $('#top');
	var win = $(window);

	var top_hgt = top.height();

	win.on('scroll resize', function(){
		if (this.scrollY > top_hgt){
			//top.attr('class', 'shrink');
		} else {
			//top.attr('class', null);
		}
	});

	win.trigger('scroll');
});
