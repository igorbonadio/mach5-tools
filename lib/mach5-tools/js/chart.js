var page   = require('webpage').create(),
    system = require('system'),
    fs     = require('fs');

page.viewportSize = { width: 960, height: 540 };

var process_data = function(data, type) {
  var table = new Array();
  table[0] = new Array();
  table[1] = new Array();
  for (var i = 0; i < data.length; i++) {
    table[0][i] = data[i].index;
    table[1][i] = data[i][type];
  }
  return table;
}

var descriptor = eval(system.args[2])[0],
    current_path = system.args[1],
    output_image = system.args[3];

if (typeof descriptor.size !== "undefined")
  page.viewportSize = descriptor.size;

page.open(current_path + '/chart.html', function() {
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
          data: process_data(descriptor.series[i].data, descriptor.dataType)[1],
          color: descriptor.series[i].color,
          animation: false
        };
      }

      $('#container').highcharts({
        chart: {
          type: descriptor.type,
          animation: false
        },
        title: descriptor.title,
        xAxis: descriptor.xAxis,
        yAxis: descriptor.yAxis,
        series: series
      });
    });
  }, process_data, descriptor);

  page.render(output_image);
  phantom.exit();
});
