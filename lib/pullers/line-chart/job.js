module.exports = function(config, dependencies, job_callback) {
    function getRndInt (min, max) {
      return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    function generateRandomSerie(n){
      var data = [];
      for (var i = 0; i < n; i++) {
        data.push({ x: i, y: getRndInt(config.minValue || 40, 100)});
      };
      return data;
    }

    var series = [];
    for (var i = config.numberSeries - 1; i >= 0; i--) {
      series.push({data: generateRandomSerie(config.items || 100)});
    };

    job_callback(null, {
      series: series,
      chartType: config.chartType || 'line',

      xAxis: config.xAxis,
      yAxis: config.yAxis
    });
};
