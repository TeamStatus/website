widgets['line-chart'] = {
    onData: function(el, data) {
      var graph;
      if ($(".chart", el).hasClass('rickshaw_graph')) {
        $(".chart", el).empty();
      }

      var palette = new Rickshaw.Color.Palette();
      for (var i = 0; i < data.series.length; i++) {
        data.series[i].color = palette.color();
      }

      var graph = new Rickshaw.Graph({
        element: $(".chart", el)[0],
        renderer: data.chartType || 'line',
        height: $(el).closest('li').height() - 50,
        stroke: true,
        series: data.series
      });

      if (data.xAxis){
        var xAxis = new Rickshaw.Graph.Axis.Time({
            graph: graph
        });

        xAxis.render();
      }

      if (data.yAxis){
        var yAxis = new Rickshaw.Graph.Axis.Y({
            graph: graph
        });

        yAxis.render();
      }

      graph.render();
    }
};