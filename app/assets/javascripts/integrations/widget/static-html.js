widgets['static-html'] = {
	onInit: function (el, settings) {
		var settings = settings || { html: "" };
		$(el).parent().children(".error").hide();
		$(el).parent().children('.spinner').hide();
		$('.content', el).html(settings.html);
	}
};