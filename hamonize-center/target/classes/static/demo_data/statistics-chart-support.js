/* 기술지원 처리현황 */
var container_support = document.getElementById('chart-support');
var data_support = {
    categories: ['Browser'],
    series: [
        {
            name: 'Chrome',
            data: 46.02
        },
        {
            name: 'IE',
            data: 20.47
        },
        {
            name: 'Firefox',
            data: 17.71
        },
        {
            name: 'Safari',
            data: 5.45
        },
        {
            name: 'Opera',
            data: 3.10
        },
        {
            name: 'Etc',
            data: 7.25
        }
    ]
};
var options_support = {
    chart: {
        width: 700,
        height: 400,
        title: '기술지원 처리현황',
        format: function(value, chartType, areaType, valuetype, legendName) {
            if (areaType === 'makingSeriesLabel') { // formatting at series area
                value = value + '%';
            }
            return value;
        }
    },
    series: {
        startAngle: -90,
        endAngle: 90,
        radiusRange: ['60%', '100%'],
        showLabel: true,
        showLegend: true
    },
    tooltip: {
        suffix: '%'
    },
    legend: {
        align: 'top'
    }
};
var theme_support = {
    series: {
        series: {
            colors: [
                '#83b14e', '#458a3f', '#295ba0', '#2a4175', '#289399',
                '#289399', '#617178', '#8a9a9a', '#516f7d', '#dddddd'
            ]
        },
        label: {
            color: '#fff',
            fontFamily: 'sans-serif'
        }
    }
};
// For apply theme
tui.chart.registerTheme('myTheme', theme_support);
options_support.theme = 'myTheme';
tui.chart.pieChart(container_support, data_support, options_support);
