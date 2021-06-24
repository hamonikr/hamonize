<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <title>Highcharts Example</title>


        <!-- 1. Add these JavaScript inclusions in the head of your page -->
        <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
        <script src="https://code.highcharts.com/highcharts.js"></script>
        <script src="https://code.highcharts.com/modules/exporting.js"></script>
        <script src="https://code.highcharts.com/modules/export-data.js"></script>


        <!-- 2. Add the JavaScript to initialize the chart on document ready -->
        <script>
        var chart; // global

        /**
         * Request data from the server, add it to the graph and set a timeout to request again
         */
        function requestData() {
            $.ajax({
                url: 'http://192.168.0.57:8086/query?db=collectd&epoch=ms&q=select time, value from cpu_value order by time desc limit 1', 
                success: function(point) {
                	
                	console.log("results=="+ JSON.stringify(point.results[0]));
                	console.log("series=="+ JSON.stringify(point.results[0].series[0]));
                	console.log("name=="+ JSON.stringify(point.results[0].series[0].name));
                	console.log("columns=="+ JSON.stringify(point.results[0].series[0].columns));
                	console.log("values=="+ JSON.stringify(point.results[0].series[0].values[0]));
                	
                	
                    // call it again after one second
                   //setTimeout(requestData, 1000);  
                },
                cache: false
            });
        }

        $(document).ready(function() {
        	requestData();
        	
          /*   chart = new Highcharts.Chart({
                chart: {
                    renderTo: 'container',
                    defaultSeriesType: 'spline',
                    events: {
                        load: requestData
                    }
                },
                title: {
                    text: 'Live random data'
                },
                xAxis: {
                    type: 'datetime',
                    tickPixelInterval: 150,
                    maxZoom: 20 * 1000
                },
                yAxis: {
                    minPadding: 0.2,
                    maxPadding: 0.2,
                    title: {
                        text: 'Value',
                        margin: 80
                    }
                },
                series: [{
                    name: 'cpu_value',
                    data: [1559107563888260000,125756541]
                }]
            });      */
        });
        </script>

    </head>
    <body>

        <!-- 3. Add the container -->
        <div id="container" style="width: 100%; height: 100%; margin: 0 auto"></div>
    </body>
</html>