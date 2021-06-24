/* 기간별 사용시간 */
var container_time = document.getElementById('chart-time');
var data_time = {
    categories: ['6월, 2015', '7월, 2015', '8월, 2015', '9월, 2015', '10월, 2015', '11월, 2015', '12월, 2015'],
    series: [
        {
            name: '서울',
            data: [5000, 3000, 5000, 7000, 6000, 4000, 1000]
        },
        {
            name: '경기',
            data: [8000, 1000, 7000, 2000, 6000, 3000, 5000]
        },
        {
            name: '강원',
            data: [4000, 4000, 6000, 3000, 4000, 5000, 7000]
        },
        {
            name: '대전',
            data: [6000, 3000, 3000, 1000, 2000, 4000, 3000]
        },
        {
            name: '충청',
            data: [8000, 1000, 7000, 2000, 6000, 3000, 5000]
        },
        {
            name: '전라',
            data: [4000, 4000, 6000, 3000, 4000, 5000, 7000]
        },
        {
            name: '경상',
            data: [8000, 1000, 7000, 2000, 6000, 3000, 5000]
        },
        {
            name: '제주',
            data: [6000, 3000, 3000, 1000, 2000, 4000, 3000]
        }
    ]
};
var options_time = {
    chart: {
        width: 1160,
        height: 650,
        title: '사용시간',
        format: '1,000'
    },
    yAxis: {
        title: '시간',
        min: 0,
        max: 9000
    },
    xAxis: {
        title: '기간'
    },
    legend: {
        align: 'top'
    }
};
var theme_time = {
    series: {
        colors: [
            '#83b14e', '#458a3f', '#295ba0', '#2a4175', '#289399',
            '#289399', '#617178', '#8a9a9a', '#516f7d', '#dddddd'
        ]
    }
};
// For apply theme
// tui.chart.registerTheme('myTheme', theme);
// options.theme = 'myTheme';
tui.chart.columnChart(container_time, data_time, options_time);