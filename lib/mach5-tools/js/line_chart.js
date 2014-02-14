var page = require('webpage').create();
page.open('line_chart.html', function() {
  page.render('example.png');
  phantom.exit();
});