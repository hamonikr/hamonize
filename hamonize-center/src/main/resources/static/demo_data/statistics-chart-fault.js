/* 장애 처리 현황 */
var container_fault = document.getElementById('chart-fault');
var theme_fault = {
    series: {
        colors: [
            '#83b14e', '#458a3f', '#295ba0', '#2a4175', '#289399',
            '#289399', '#617178', '#8a9a9a', '#516f7d', '#dddddd'
        ]
    }
};

var area_name = ['전체', '서울', '경기', '강원', '대전', '충청', '전라', '경상', '제주']
var data_fault;
var options_fault;


for(i=0; i<area_name.length ;++i){
	data_fault = {
	    categories: [area_name[i]],
	    series: [
	        { name: '정상', data: Math.floor((Math.random() * 1000) + 1) },
	        { name: '장애', data: Math.floor((Math.random() * 300) + 1) }
	    ]
	};
	options_fault = {
	    chart: {
	        width: 300,
	        height: 260,
	        title: area_name[i]
	    },
	    tooltip: {
	        suffix: '건'
	    }
	};
	
	// For apply theme
	// tui.chart.registerTheme('myTheme', theme);
	// options.theme = 'myTheme';
	tui.chart.pieChart(container_fault, data_fault, options_fault);
}