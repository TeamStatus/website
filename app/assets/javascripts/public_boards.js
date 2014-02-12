//= require console-helper
//= require jquery
//= require jquery_ujs
//= require underscore/underscore
//= require bootstrap

//= require gridster/dist/jquery.gridster.min.js
//= require jquery.transform.js
//= require bootbox.js/bootbox.js
//= require jquery.boxfit/src/jquery.boxfit
//= require handlebars.js
$(function() {
  var basePath = $('meta[name="ts.board.basePath"]').attr('content');
  var boardsUrl = $('meta[name="ts.board.boardsUrl"]').attr('content');
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
            url: basePath + '/boards/' + boardId + '/jobs/' + $li.data('event-id') + '.json'
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
        url: basePath + '/boards/' + boardId + '/jobs/' + $li.data('event-id') + '/duplicate.json'
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

  var mainContainer = $("#main-container");
  var basePath = $('meta[name="ts.board.basePath"]').attr('content');
  var publicId = $('meta[name="ts.board.publicId"]').attr('content');
  var boardsHost = $('meta[name="ts.board.host"]').attr('content');
  var boardsPort = $('meta[name="ts.board.port"]').attr('content');
  var boardId = $('meta[name="ts.board.id"]').attr('content');
  var gridsterContainer = $(".gridster ul");

  if (window.mixpanel !== undefined) {
    mixpanel.track('Board Viewed', {'Board Id' : publicId});

    $(document).on('click', 'a', function(event) {
      mixpanel.track('Board clicked', {
        'Board Id': publicId,
        'Destination': $(event.target).attr('href')
      });
    });
  }

  buildUI(mainContainer, gridsterContainer, mainContainer.data('widgets'));

  var socketPath = '/socket.io';
  while(socketPath.indexOf('/') === 0) {
    socketPath = socketPath.substring(1);
  }

  var socketOptions = {
    'reconnect': true,
    'reconnection delay': 5000,
    'reopen delay': 3000,
    'max reconnection attempts': 100,
    'resource': socketPath,
    'host': boardsHost,
    'port': boardsPort
  };

  //----------------------
  // widget socket
  //----------------------
  var socket_w = io.connect('/sockets-board', socketOptions);
  var serverInfo;
  socket_w.on("connect", function() {
    console.log('connected');
    disconnected(false);

    socket_w.emit("subscribe", {boardId: boardId});

    bindSocket(socket_w, gridsterContainer);

    socket_w.on("disconnect", function() {
      disconnected(true);
      console.log('disconnected');
    });

    // reconnect
    socket_w.on('reconnecting', function () {
      console.log('reconnecting...');
    });

    socket_w.on('reconnect_failed', function () {
      console.log('reconnected FAILED');
    });

    socket_w.on("serverinfo", function(newServerInfo) {
      console.log("Received server info", newServerInfo);
      if (!serverInfo) {
        serverInfo = newServerInfo;
      } else if (newServerInfo.startTime > serverInfo.startTime) {
        window.location.reload();
      }
    });
  });

  //----------------------
  // log socket
  //----------------------
  var socket_log = io.connect('/sockets-log', socketOptions);
  socket_log.on("connect", function() {
    console.log('log socket connected');
  });

  function bindSocket (io, gridsterContainer) {
    gridsterContainer.children("li").each(function(index, li) {
      bindWidget(io, li);
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
      if (widget.widget == "bamboo-builds" || widget.widget == "static-html") {
        widget.widgetSettings.width = widget.widgetSettings.height = 2;
      } else if (widget.widget == "jira-issue-list" || widget.widget == "crucible-reviews" || widget.widget == "display-table") {
        widget.widgetSettings.width = 2;
        widget.widgetSettings.height = 1;
      }

      var $li = gridster.add_widget(widgetTemplate({
        widget: widget,
        settings: widget.widgetSettings
      }), widget.widgetSettings.width || 1, widget.widgetSettings.height || 1);

      $li.data('widgetSettings', widget.widgetSettings);

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
      socket_log.emit('log', {widgetId : this.eventId, data : data}); // emit to logger
    }
  };

  var globalHandlers = { // global pre-post event handlers
    onPreError : function (el, eventId, data) {
      $(".error", el).show();
      $('.spinner', el).hide();

      console.error("Error loading widget for:", eventId, data);
      socket_log.emit('log', _.extend(data, {eventId : eventId})); // emit to logger
    },

    onPreData : function (el, data) {
      $(".error", el).hide();
      $('.spinner', el).hide();
    }
  };

  function bindWidget(io, li) {
    var $li = $(li);
    var widgetId = encodeURIComponent($li.data("widget-id"));
    var eventId = $li.data("event-id");

    $('.error', $li).hide();
    var $widgetContainer = $('.widget-container', $li);

    // fetch widget html and css
    $.get(basePath + "/widgets/" + widgetId, function(html) {
      $widgetContainer.html(html);

      // fetch widget js
      $.get(basePath + '/widgets/' + widgetId + '/js', function(js) {
        var widget_js = {};
        try {
          eval('widget_js[eventId] = ' + js);
          widget_js[eventId].eventId = eventId;
          widget_js[eventId] = $.extend({}, defaultHandlers, widget_js[eventId]);
          widget_js[eventId] = $.extend({}, widgetMethods, widget_js[eventId]);
          widget_js[eventId].onInit($widgetContainer[0], $li.data('widgetSettings'));
        } catch (e) {
          globalHandlers.onPreError($li, eventId, {error: e});
        }

        io.on(eventId, function (data) { //bind socket.io event listener
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

        io.emit("resend", {boardId: boardId, widgetId: eventId});
        console.log("Sending resend for " + eventId);
      }).fail(function() {
        globalHandlers.onPreError($li, eventId, {error: "Failed to load widget"});
      });
    }).fail(function() {
      globalHandlers.onPreError($li, eventId, {error: "Failed to load widget"});
    });
  }

});