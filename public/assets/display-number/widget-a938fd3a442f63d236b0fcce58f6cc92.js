widget={onError:function(t){$(t).find(".counter").html("N/A")},onData:function(t,n){n.count==n.maxResults?"+":"";n.url?$(t).find(".counter").html($("<a/>").attr("href",n.url).text(n.count)):$(t).find(".counter").html(n.count),n.label?$(t).find(".label").html(n.label).show():$(t).find(".label").hide(),$(".content > .counter",t).boxfit()}};