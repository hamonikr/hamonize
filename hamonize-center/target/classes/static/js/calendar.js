var div, x, y, day, obj, mode;
var agent = navigator.userAgent;

function openCalendar(_obj, _mode) {
	div = document.createElement("div");
	div.id = "divCalendar";

	obj = _obj;
	mode = _mode;

	x = document.documentElement.clientLeft + GetObjectLeft(_obj);
	y = document.documentElement.clientTop + GetObjectTop(_obj);
	
	div.style.left = parseInt(x,10) + "px";
	div.style.top = parseInt(y + _obj.offsetHeight,10) + "px";

	var arrValue = _obj.value;

	if (arrValue.length == 10) {
		if (checkNumber(arrValue.substring(0,4) + arrValue.substring(5,7) + arrValue.substring(8,10))) {
			day = arrValue.substring(0,4) + "-" + arrValue.substring(5,7) + "-" + arrValue.substring(8,10);

			showCalendar(arrValue.substring(0,4), arrValue.substring(5,7), arrValue.substring(8,10), ' (현재선택)');
		}
	} else if (arrValue.length == 7) {
		if (checkNumber(arrValue.substring(0,4) + arrValue.substring(5,7))) {
			day = arrValue.substring(0,4) + "-" + arrValue.substring(5,7);

			showCalendar(arrValue.substring(0,4), arrValue.substring(5,7), '01', ' (현재선택)');
		}
	}  else if (arrValue.length == 4) {
		if (checkNumber(arrValue.substring(0,4))) {
			day = arrValue.substring(0,4);

			showCalendar(arrValue.substring(0,4), '01', '01', ' (Selected)');
		}
	} else {
		var now = new Date();

		day = now.getFullYear() + "-" + ((parseInt(now.getMonth() + 1,10) < 10) ? "0" + (now.getMonth() + 1)  : (now.getMonth() + 1)) + "-" + ((parseInt(now.getDate(),10) < 10) ? "0" + (now.getDate())  : (now.getDate()));

		showCalendar(now.getFullYear(), now.getMonth() + 1, now.getDate(), ' (Today)');
	}
	
	if (mode == 'month') {
		document.getElementById("tableCalendarTitle").style.display = "none";
		document.getElementById("tableCalendar").style.display = "none";
		document.getElementById("tableMonthTitle").style.display = "";
		document.getElementById("tableMonth").style.display = "";
		document.getElementById("tableYearTitle").style.display = "none";
		document.getElementById("tableYear").style.display = "none";
	} else if (mode == 'year') {
		document.getElementById("tableCalendarTitle").style.display = "none";
		document.getElementById("tableCalendar").style.display = "none";
		document.getElementById("tableMonthTitle").style.display = "none";
		document.getElementById("tableMonth").style.display = "none";
		document.getElementById("tableYearTitle").style.display = "";
		document.getElementById("tableYear").style.display = "";
	}
}

function showCalendar(_year, _month, _day, _stat) {
	if (_stat) {
		var _title = _stat;
	}
	if(document.getElementById("divCalendar")) {
		document.getElementById("divCalendar").parentNode.removeChild(document.getElementById("divCalendar"));

		for(var i = document.getElementsByTagName("roundrect").length - 1; i > -1; i--) {
			document.getElementsByTagName("roundrect")[i].parentNode.removeChild(document.getElementsByTagName("roundrect")[i]);
		}

		div = document.createElement("div");
		div.id = "divCalendar";
		div.style.left = parseInt(x,10) + "px";
		div.style.top = parseInt(y + obj.offsetHeight,10) + "px";
	}

	var arrMonth = new Array("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12");
	var arrLastDay = new Array(0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

	if(((parseInt(_year,10) % 4 == 0) && (parseInt(_year,10) % 100 != 0)) || (parseInt(_year,10) % 400 == 0)) {
		arrLastDay[2] = 29;
	}

	switch(parseInt(_month,10)) {
		case 1 :
			preYear = _year - 1;
			preMonth = 12;
			nxtYear = _year;
			nxtMonth = 2;
			break;
		
		case 12 :
			preYear = _year;
			preMonth = 11;
			nxtYear = _year + 1;
			nxtMonth = 1;
			break;
		
		default :
			preYear = _year;
			preMonth = parseInt(_month,10) - 1;
			nxtYear = _year;
			nxtMonth = parseInt(_month,10) + 1;
			break;
	}

	var firstDay = new Date(_year, _month -1, 1);
	var firstWeek = firstDay.getDay();
	var lastDay = arrLastDay[parseInt(_month,10)];
	var printDay = 1;

	var table, caption, colgroup, col, thead, tbody, tr, th, td, a, span;

	table = document.createElement("table");
	table.id = "tableYearTitle";
	table.style.display = "none";
	table.style.paddingBottom = "10px";

	colgroup = document.createElement("colgroup");
	col = document.createElement("col");
	col.style.width = "10%";
	
	colgroup.appendChild(col);

	col = document.createElement("col");
	col.style.width = "80%";
	
	colgroup.appendChild(col);

	col = document.createElement("col");
	col.style.width = "10%";
	
	colgroup.appendChild(col);
	table.appendChild(colgroup);

	tr = document.createElement("tr");
	td = document.createElement("td");
	
	a = document.createElement("a");
	a.href = "javascript:void(0);";
	a.id = "aFirstY";
	a.onclick = new Function("showYear(" + (parseInt(_year,10) - 12) + ", " + _month + ", " + _day + ");");
	a.innerHTML = "◀";

	td.appendChild(a);
	tr.appendChild(td);

	td = document.createElement("td");
	// td.innerHTML = (parseInt(_year,10) - 5) + "년 ~ " + (parseInt(_year,10) + 6) + "년";
	td.innerHTML = (parseInt(_year,10) - 5) + " ~ " + (parseInt(_year,10) + 6);

	tr.appendChild(td);

	td = document.createElement("td");

	a = document.createElement("a");
	a.href = "javascript:void(0);";
	a.onclick = new Function("showYear(" + (parseInt(_year,10) + 12) + ", " + _month + ", " + _day + ");");
	a.innerHTML = "▶";

	td.appendChild(a);
	tr.appendChild(td);
	table.appendChild(tr);
	div.appendChild(table);

	table = document.createElement("table");
	table.id = "tableYear";
	table.style.display = "none";

	caption = document.createElement("caption");

	colgroup = document.createElement("colgroup");
	
	for(var i = 0; i < 4; i++) {
		col = document.createElement("col");
		col.style.width = "25%";

		colgroup.appendChild(col);
	}

	table.appendChild(colgroup);
	tr = document.createElement("tr");
	
	checkNum = 1;

	for(var i = (parseInt(_year,10) - 5); i <= (parseInt(_year,10) + 6); i++) {
		if(checkNum == 5 || checkNum == 9) {
			tr = document.createElement("tr");
		}

		td = document.createElement("td");
		a = document.createElement("a");
		a.href = "javascript:void(0);";

		if (mode == 'year') {
			var _yy = i;

			a.title = _yy;
			a.onclick = new Function("clickCalendar(this, 'year');");
			if(_year == i && _year == parseInt(day.split("-")[0], 10)) {
				a.setAttribute("class", "today");
				a.title += _title;
			}
		} else {
			a.onclick = new Function("showMonth(" + i + ", " + _month + ", " + _day + ");");
		}

		// a.innerHTML = i + "년";
		a.innerHTML = i;

		if(checkNum == 12) {
			a.onkeydown = new Function("if(event.keyCode == 9){clickCalendar('');}");
		}
		
		td.appendChild(a);
		tr.appendChild(td);
		table.appendChild(tr);

		checkNum ++;
	}
	
	div.appendChild(table);

	table = document.createElement("table");
	table.id = "tableMonthTitle";
	table.style.display = "none";
	table.style.paddingBottom = "10px";
	colgroup = document.createElement("colgroup");
	col = document.createElement("col");
	col.style.width = "10%";
	
	colgroup.appendChild(col);

	col = document.createElement("col");
	col.style.width = "80%";
	
	colgroup.appendChild(col);

	col = document.createElement("col");
	col.style.width = "10%";
	
	colgroup.appendChild(col);
	table.appendChild(colgroup);

	colgroup.appendChild(col);
	table.appendChild(colgroup);

	tr = document.createElement("tr");
	td = document.createElement("td");

	a = document.createElement("a");
	a.id = "aFirstM";
	a.href = "javascript:void(0);";
	a.onclick = new Function("showMonth(" + (parseInt(_year,10) - 1) + ", " + _month + ", " + _day + ");");
	a.innerHTML = "◀";

	td.appendChild(a);
	tr.appendChild(td);

	td = document.createElement("td");
	a = document.createElement("a");
	// a.title = "연도선택 바로가기"
	a.title = "Select Year"
	a.href = "javascript:void(0);";
	a.onclick = new Function("showYear(" + _year + ", " + _month + ", " + _day + ");");
	// a.innerHTML = _year + "년";
	a.innerHTML = _year;

	td.appendChild(a);
	tr.appendChild(td);
	td = document.createElement("td");

	a = document.createElement("a");
	a.href = "javascript:void(0);";



	a.onclick = new Function("showMonth(" + (parseInt(_year,10) + 1) + ", " + _month + ", " + _day + ");");
	a.innerHTML = "▶";

	td.appendChild(a);
	tr.appendChild(td);
	table.appendChild(tr);		
	div.appendChild(table);

	table = document.createElement("table");
	table.id = "tableMonth";
	table.style.display = "none";

	colgroup = document.createElement("colgroup");
	
	for(var i = 0; i < 4; i++) {
		col = document.createElement("col");
		col.style.width = "25%";

		colgroup.appendChild(col);
	}

	table.appendChild(colgroup);

	tr = document.createElement("tr");

	for(var i = 1; i < 13; i++) {
		if(i == 5 || i == 9) {
			tr = document.createElement("tr");
		}

		td = document.createElement("td");
		a = document.createElement("a");
		a.href = "javascript:void(0);";

		if (mode == 'month') {
			var _mm = i;

			if(_mm < 10) {
				_mm = '0' + _mm;
			}
			a.title = _year + "-" + _mm;
			a.onclick = new Function("clickCalendar(this, 'month');");
			if(_month == i && _year == parseInt(day.split("-")[0], 10)) {
				a.setAttribute("class", "today");
				a.title += _title;
			}
		} else {
			a.onclick = new Function("showCalendar(" + _year + ", " + i + ", " + _day + ");");
		}

		// a.innerHTML = i + "월";
		a.innerHTML = i;

		if(i == 12) {
			a.onkeydown = new Function("if(event.keyCode == 9){clickCalendar('');}");
		}
		
		td.appendChild(a);
		tr.appendChild(td);
		table.appendChild(tr);
	}
	
	div.appendChild(table);

	table = document.createElement("table");
	table.id = "tableCalendarTitle";
	table.style.paddingBottom = "10px";
	
	colgroup = document.createElement("colgroup");
	col = document.createElement("col");
	col.style.width = "10%";
	
	colgroup.appendChild(col);

	col = document.createElement("col");
	col.style.width = "80%";
	
	colgroup.appendChild(col);

	tr = document.createElement("tr");
	td = document.createElement("td");

	a = document.createElement("a");
	a.id = "aFirst";
	a.href = "javascript:void(0);";
	a.onclick = new Function("showCalendar(" + preYear + ", " + preMonth + ", " + _day + ");");
	a.setAttribute("class", "prev");
	a.innerHTML = "◀";

	td.appendChild(a);
	tr.appendChild(td);

	td = document.createElement("td");
	a = document.createElement("a");
	a.href = "javascript:void(0);";
	a.onclick = new Function("showMonth(" + _year + ", " + _month + ", " + _day + ");");
	// a.innerHTML = _year + "년 " + parseInt(_month,10) + "월";
	a.innerHTML = _year + " / " + parseInt(_month,10) + "";

	td.appendChild(a);
	tr.appendChild(td);
	td = document.createElement("td");

	a = document.createElement("a");
	a.href = "javascript:void(0);";
	a.onclick = new Function("showCalendar(" + nxtYear + ", " + nxtMonth + ", " + _day + ");");
	a.setAttribute("class", "next");
	a.innerHTML = "▶";

	td.appendChild(a);
	tr.appendChild(td);
	table.appendChild(tr);
	div.appendChild(table);

	table = document.createElement("table");
	table.id = "tableCalendar";
	
	caption = document.createElement("caption");
	caption.innerHTML = "날짜를 선택할 수 있는 달력";

	table.appendChild(caption);

	colgroup = document.createElement("colgroup");

	for(var i = 0; i < 7; i++) {
		col = document.createElement("col");
		col.style.width = "14%";

		colgroup.appendChild(col);
	}

	table.appendChild(colgroup);

	var arrWeekName = new Array("일", "월", "화", "수", "목", "금", "토");

	thead = document.createElement("thead");
	tr = document.createElement("tr");
	
	for(var i = 0; i < 7; i++) {
		th = document.createElement("th");
		th.scope = "col";
		th.innerHTML = arrWeekName[i];

		tr.appendChild(th);
	}

	thead.appendChild(tr);
	table.appendChild(thead);

	tbody = document.createElement("tbody");

	for(var week = 1; week <=6; week++) {
		tr = document.createElement("tr");
		
		for(var dd =1; dd <= 7; dd++) {
			if(firstWeek > 0) {
				td = document.createElement("td");
				td.innerHTML = "&nbsp;";

				tr.appendChild(td);

				firstWeek--;
			} else {
				if(printDay > lastDay) {
					td = document.createElement("td");
					td.innerHTML = "&nbsp;";

					tr.appendChild(td);
				} else {
					td = document.createElement("td");
					a = document.createElement("a");
					a.href = "javascript:void(0);";
					a.title = _year + "/" + ((parseInt(_month,10) < 10) ? "0" + parseInt(_month,10)  : _month) + "/" + ((parseInt(printDay + 1,10) < 11) ? "0" + parseInt(printDay,10)  : printDay);
					a.onclick = new Function("clickCalendar(this);");
					a.innerHTML = printDay;

					if(_day == printDay && _month == parseInt(day.split("-")[1], 10) && _year == parseInt(day.split("-")[0], 10)) {
						a.setAttribute("class", "today");
						a.title += _title;
					}

					td.appendChild(a);
					tr.appendChild(td);
				}

				printDay ++;
			}

			tbody.appendChild(tr);
		}

		if(printDay > lastDay) {
			break;
		}
	}

	table.appendChild(tbody);
	div.appendChild(table);

	/* 닫기버튼 추가 */
	if(agent.indexOf("MSIE 7.0") > -1) {
		span = document.createElement("<span class=\"btn_cal_close\">");
	} else {
		span = document.createElement("span");
		span.setAttribute("class", "btn_cal_close");
	}

	a = document.createElement("a");
	a.href = "javascript:void(0);";
	a.title = "닫기";
	a.onclick = new Function("clickCalendar('');");
	a.onkeydown = new Function("if(event.keyCode == 9){clickCalendar('');}");
	a.innerHTML = "닫기";
	span.appendChild(a);
	/* 닫기버튼 추가 */
	
	div.appendChild(span);
	document.body.appendChild(div);
	setTimeout(
		function(){
			if (mode == 'month') { 
				document.getElementById("aFirstM").focus();	
			} else if (mode == 'year') { 
				document.getElementById("aFirstY").focus();	
			} else {
				document.getElementById("aFirst").focus();
			}
			
		},
		100
	);
}

function clickCalendar(_obj, _mode) {
	if(_obj) {
		var inputVal;
		if (_mode == "month") {
			inputVal = _obj.title.substring(0,7);
			obj.value = inputVal;
		} else if (_mode == "year") {
			inputVal = _obj.title.substring(0,4);
			obj.value = inputVal;
		} else {
			inputVal = _obj.title.substring(0,10);
			obj.value = inputVal;
		} 
		/* 콜백 함수 */
		if(typeof fn_cals != "undefined"){
			fn_cals(obj);
		}
		/* // 콜백 함수 */
	}
	
	div.parentNode.removeChild(div);

	for(var i = document.getElementsByTagName("roundrect").length - 1; i > -1; i--) {
		document.getElementsByTagName("roundrect")[i].parentNode.removeChild(document.getElementsByTagName("roundrect")[i]);
	}
	obj.focus();
}

function showMonth(_year, _month, _day) {
	showCalendar(_year, _month, _day);
	document.getElementById("tableCalendarTitle").style.display = "none";
	document.getElementById("tableCalendar").style.display = "none";
	document.getElementById("tableMonthTitle").style.display = "";
	document.getElementById("tableMonth").style.display = "";
	document.getElementById("tableYearTitle").style.display = "none";
	document.getElementById("tableYear").style.display = "none";
	setTimeout(
		function(){
			document.getElementById("aFirstM").focus(); // 포커싱 추가
		},
		100
	);
}

function showYear(_year, _month, _day) {
	showCalendar(_year, _month, _day);
	document.getElementById("tableCalendarTitle").style.display = "none";
	document.getElementById("tableCalendar").style.display = "none";
	document.getElementById("tableMonthTitle").style.display = "none";
	document.getElementById("tableMonth").style.display = "none";
	document.getElementById("tableYearTitle").style.display = "";
	document.getElementById("tableYear").style.display = "";
	setTimeout(
		function(){
			document.getElementById("aFirstY").focus(); // 포커싱 추가
		},
		100
	);
}

function checkNumber(_value) {
	var pattern = /^[0-9]+$/;

	if(_value.replace(/\s/g,"").length < 1 && !pattern.test(_value)) {
		return false;
	}

	return true;
}

function GetObjectTop(_obj) {
	var intTopSum = _obj.offsetTop;

	while(_obj.nodeName.indexOf("HTML") != 0 && _obj.nodeName.indexOf("BODY") != 0) {
		_obj = _obj.offsetParent;
		intTopSum += _obj.offsetTop;
	}

	return intTopSum;
}

function GetObjectLeft(_obj) {
	var intLeftSum = _obj.offsetLeft;

	while(_obj.nodeName.indexOf("HTML") != 0 && _obj.nodeName.indexOf("BODY") != 0) {
		_obj = _obj.offsetParent;
		intLeftSum += _obj.offsetLeft;
	}

	return intLeftSum;
}