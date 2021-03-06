// thanks http://zargony.com/2012/02/29/google-charts-on-your-site-the-unobtrusive-way
jQuery(function ($) {
  // Load Google visualization library if a chart element exists
  if ($('[data-chart]').length > 0) {
    $.getScript('https://www.google.com/jsapi', function (data, textStatus) {
      google.load('visualization', '1.0', { 'packages': ['corechart'], 'callback': function () {
        // Google visualization library loaded
        $('[data-chart]').each(function () {
          var div = $(this)
          // Fetch chart data
          $.getJSON(div.data('chart'), function (data) {
            // Create DataTable from received chart data
            var table = new google.visualization.arrayToDataTable(data.data);

            // Draw the chart
            var chart = new google.visualization.ChartWrapper();
            chart.setChartType(data.type);
            chart.setDataTable(table);
            chart.setOptions(data.options);
            chart.setOption('width', div.width());
            chart.setOption('height', div.height());
            chart.draw(div.get(0));

            // hookup the orientationchange to redraw it
            // orientationchange
            window.addEventListener('orientationchange', function () {
              chart.setOption('width', div.width());
              chart.setOption('height', div.height());
              chart.draw(div.get(0));
            });
          });
        });
      }});
    });
  }
});
