//= require d3
//= require epoch
//= require ng-epoch
//= require angular-websocket

var barChartData = [
  // First bar series
  {
    label: 'Series 1',
    values: [
    { x: 'A', y: 30 },
    { x: 'B', y: 10 },
    { x: 'C', y: 12 }
    ]
},

  // Second series
  {
    label: 'Series 2',
    values: [
    { x: 'A', y: 20 },
    { x: 'B', y: 39 },
    { x: 'C', y: 8 }
    ]
}];

$('#barChart').epoch({
    type: 'bar',
    data: barChartData
});
