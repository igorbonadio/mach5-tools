var page = require('webpage').create();
page.open('chart.html', function() {
  page.evaluate(function() {
    $(function () {
      $('#container').highcharts({
        chart: {
          type: 'bar',
          animation: false
        },
        title: {
          text: 'Fruit Consumption'
        },
        xAxis: {
          categories: ['Apples', 'Bananas', 'Oranges']
        },
        yAxis: {
          title: {
            text: 'Fruit eaten'
          }
        },
        series: [{
          name: 'Jane',
          data: [1, 0, 4],
          animation: false
        }, {
          name: 'John',
          data: [5, 7, 3],
          animation: false
        }]
      });
    });
  });
  page.render('example.png');
  phantom.exit();
});