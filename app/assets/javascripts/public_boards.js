//= require console-helper
//= require jquery
//= require jquery_ujs
//= require underscore/underscore
//= require bootstrap

//= require jquery-cookie/jquery.cookie.js
//= require gridster/dist/jquery.gridster.min.js
//= require jquery.transform.js
//= require bootbox.js/bootbox.js
//= require jquery.boxfit/src/jquery.boxfit
//= require handlebars.js
//= require websocket_rails/main
//= require ./integrations/widgets.js

$(function() {
	var publicId = $('meta[name="ts.board.publicId"]').attr('content');
	var boardId = $('meta[name="ts.board.id"]').attr('content');

	$('#main-container').on('widget.added', function(event, $li) {
		$('.widget-header .delete', $li).on('click', function(e) {
			e.preventDefault();
			bootbox.confirm("You are going to delete the widget. Are you sure?", function(result) {
				if(result) {
					$.ajax({
						type: 'DELETE',
						async: true,
						url: '/boards/' + boardId + '/jobs/' + $li.data('event-id') + '.json'
					}).done(function() {
						window.location.reload();
					});
				}
			});
		});

		$('.widget-header .copy', $li).on('click', function(e) {
			e.preventDefault();
			$.ajax({
				type: 'POST',
				async: true,
				url: '/boards/' + boardId + '/jobs/' + $li.data('event-id') + '/duplicate.json'
			}).done(function() {
				window.location.reload();
			});
		});
	});
});

$(function() {
	if (!$("#widgets-container").length) {
		console.log("No widgets container found!");
		return;
	}

	$("#logo").fadeOut(1000);
	$('#menu a').popover({
		animation: true,
		placement: 'bottom',
		html: true,
		content: function() {
			return $('#menu-template').html();
		}
	});

	// disable caching for now as chrome somehow screws things up sometimes
	$.ajaxSetup({
		cache: false,
		xhrFields: {
			'withCredentials': true
		},
		beforeSend: function(xhr, settings) {
			xhr.setRequestHeader('X-XSRF-TOKEN', $.cookie('XSRF-TOKEN'));
		}
	});

	// handling view/edit modes switching
	function isEditing() {
		return window.location.hash == '#edit';
	}

	$(window).on('hashchange', function() {
		if (isEditing()) {
			$('.editing').show();
			$('.looking').hide();
		} else {
			$('.editing').hide();
			$('.looking').show();
		}
	});
	$(window).trigger('hashchange');

	var navigatingAway = false;
	var mainContainer = $("#main-container");
	var publicId = $('meta[name="ts.board.publicId"]').attr('content');
	var boardsHost = $('meta[name="ts.board.host"]').attr('content');
	var boardsPort = $('meta[name="ts.board.port"]').attr('content');
	var boardId = $('meta[name="ts.board.id"]').attr('content');
	var gridsterContainer = $(".gridster ul");

	// not showing disconnected when unloading the page
	$(window).on('beforeunload unload', function() {
		navigatingAway = true;
	});

	$(document).on('click', "a[href^='http']", function(event) {
		navigatingAway = true;
		if (mixpanel) {
			mixpanel.track('Board clicked', {
				'Board Id': publicId,
				'Destination': $(event.target).attr('href')
			});
		}
	});

	if (mixpanel) {
		mixpanel.track('Board Viewed', {'Board Id' : publicId});
	}

	buildUI(mainContainer, gridsterContainer, mainContainer.data('widgets'));

	//----------------------
	// widget socket
	//----------------------
	var socket_w = new WebSocketRails('lvh.me:3001/websocket');
	var serverInfo;
	socket_w.on_open = function(data) {
		console.log('connected');
		disconnected(false);

		bindSocket(socket_w.subscribe(boardId), gridsterContainer);

		socket_w.bind("disconnect", function() {
			if (!navigatingAway) {
				disconnected(true);
			}
			console.log('disconnected');
		});

		// reconnect
		socket_w.bind('reconnecting', function () {
			console.log('reconnecting...');
		});

		socket_w.bind('reconnect_failed', function () {
			console.log('reconnected FAILED');
		});

		socket_w.bind("serverinfo", function(newServerInfo) {
			console.log("Received server info", newServerInfo);
			if (!serverInfo) {
				serverInfo = newServerInfo;
			} else if (newServerInfo.startTime > serverInfo.startTime) {
				window.location.reload();
			}
		});
	};

	function bindSocket (channel, gridsterContainer) {
		gridsterContainer.children("li").each(function(index, li) {
			bindWidget(channel, li);
		});
	}

	function disconnected(dis) {
		if (dis) {
			$('#main-container').addClass("disconnected");
			$('#disconnected').show();
		} else {
			$('#main-container').removeClass("disconnected");
			$('#disconnected').fadeOut();
		}
	}

	function buildUI(mainContainer, gridsterContainer, configuration) {
		var gutter = parseInt(mainContainer.css("paddingTop"), 10) * 2;
		var gridsterGutter = gutter/2;
		var height = 1080 - mainContainer.offset().top - gridsterGutter;
		var width = mainContainer.width();
		var vertical_cells = 4, horizontal_cells = 6;
		var widgetSize = {
			w: (width - horizontal_cells * gutter) / horizontal_cells,
			h: (height - vertical_cells * gutter) / vertical_cells
		};

		var gridster = gridsterContainer.gridster({
			widget_margins: [gridsterGutter, gridsterGutter],
			widget_base_dimensions: [widgetSize.w, widgetSize.h],
			avoid_overlapped_widgets: true
			// min_cols: 6
		}).data("gridster");

		// Handle browser resize
		var initialWidth = mainContainer.outerWidth();
		var initialHeight = mainContainer.outerHeight();

		$(window).resize(function() {
			var scaleFactorWidth = $(window).width() / initialWidth;
			var scaleFactorHeight = $(window).height() / initialHeight;
			mainContainer.css("transform", "scale(" + Math.min(scaleFactorWidth, scaleFactorHeight) + ")");
		}).resize();

		var widgetTemplate = Handlebars.compile($("#widget-template").html());
		_.each(configuration, function(widget) {
			var width = 1, height = 1;
			if (widget.widgetSettings && widget.widgetSettings.size && widget.widgetSettings.size.length == 2) {
				width = widget.widgetSettings.size[0];
				height = widget.widgetSettings.size[1];
			} else if (widget.jobId == "bamboo-builds" || widget.jobId == "static-html") {
				width = height = 2;
			} else if (widget.jobId == "jira-issue-list" || widget.jobId == "crucible-reviews" || widget.jobId == "display-table"
				|| widget.jobId == "postgresql-list") {
				width = 2;
				height = 1;
			}

			var $li = gridster.add_widget(widgetTemplate({
				widget: widget,
				settings: widget.widgetSettings
			}), width || 1, height || 1);

			$li.data('widgetSettings', widget.widgetSettings);
			$li.find('.editing').toggle(isEditing());

			mainContainer.trigger('widget.added', [$li]);
		});
	}

	var defaultHandlers = { // they can be overwritten by widget´s custom implementation
		onError : function (el, data) {
			console.error(data);
		},
		onInit : function (el, settings) {
			$(el).parent().children(".spinner").show();
		}
	};

	var widgetMethods = { // common methods that all widgets implement
		log : function (data){
			socket_w.trigger('log', {widgetId : this.eventId, data : data}); // emit to logger
		}
	};

	var globalHandlers = { // global pre-post event handlers
		onPreError : function (el, eventId, data) {
			$(".error", el).show();
			$('.spinner', el).hide();

			console.error("Error loading widget for:", eventId, data);
			socket_w.trigger('log', _.extend(data, {eventId : eventId})); // emit to logger
		},

		onPreData : function (el, data) {
			$(".error", el).hide();
			$('.spinner', el).hide();
		}
	};

	function bindWidget(channel, li) {
		var $li = $(li);
		var widgetId = encodeURIComponent($li.data("widget-id"));
		var eventId = $li.data("event-id");

		$('.error', $li).hide();
		var $widgetContainer = $('.widget-container', $li);

		// fetch widget html and css
		$.get("/integrations/" + widgetId + "/html", function(html) {
			$widgetContainer.html(html);

			// fetch widget js
			var widget_js = {};
			try {
				widget_js[eventId] = _.clone(widgets[widgetId]);
				widget_js[eventId].eventId = eventId;
				widget_js[eventId] = $.extend({}, defaultHandlers, widget_js[eventId]);
				widget_js[eventId] = $.extend({}, widgetMethods, widget_js[eventId]);
				widget_js[eventId].onInit($widgetContainer[0], $li.data('widgetSettings'));
			} catch (e) {
				globalHandlers.onPreError($li, eventId, {error: e});
			}

			channel.bind(eventId, function (data) { //bind socket.io event listener
				console.log("Received data for " + eventId, data);
				if (data.error) {
					globalHandlers.onPreError($li, eventId, data);
				} else {
					globalHandlers.onPreData($li, eventId, data);
				}

				var handler = data.error ? widget_js[eventId].onError : widget_js[eventId].onData;
				try {
					handler.apply(widget_js[eventId], [$widgetContainer[0], data]);
				} catch (e) {
					globalHandlers.onPreError($li, eventId, {error: e});
				}

				// save timestamp
				$li.attr("last-update", +new Date());
			});

			socket_w.trigger("resend", eventId);
			console.log("Sending resend for " + eventId);
		}).fail(function() {
			globalHandlers.onPreError($li, eventId, {error: "Failed to load widget"});
		});
	}

});