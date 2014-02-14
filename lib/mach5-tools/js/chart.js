var page   = require('webpage').create(),
    system = require('system'),
    fs     = require('fs');

var runs_total_time = function(data) {
  var table = new Array();
  table[0] = new Array();
  table[1] = new Array();
  for (var i = 0; i < data.length; i++) {
    table[0][i] = data[i].index;
    table[1][i] = data[i].runs_total_time;
  }
  return table;
}

page.open('chart.html', function() {
  var descriptor = eval(system.args[1])[0];

  for (var i = 0; i < descriptor.series.length; i++) {
    var file = fs.open(descriptor.series[i].file, 'r');
    descriptor.series[i].data = eval(file.read());
  }

  page.evaluate(function(process_data, descriptor) {
    $(function () {
      var series = new Array();
      for (var i = 0; i < descriptor.series.length; i++) {
        series[i] = {
          name: descriptor.series[i].label,
          data: process_data(descriptor.series[i].data)[1],
          animation: false
        };
      }

      $('#container').highcharts({
        chart: {
          type: 'line',
          animation: false
        },
        title: {
          text: descriptor.title
        },
        xAxis: {
          categories: []
        },
        yAxis: {
          title: {
            text: 'Fruit eaten'
          }
        },
        series: series
      });
    });
  }, runs_total_time, descriptor);

  page.render('example.png');
  phantom.exit();
});