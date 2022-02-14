// input box number Only
$(function() {
 $(document).on("keyup", "input:text[numberOnly]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});
 $(document).on("keyup", "input:text[datetimeOnly]", function() {$(this).val( $(this).val().replace(/[^0-9:\-]/gi,"") );});
});
/**
 * 숫자만 입력
 */
function isNumber(obj) {

	var exp = /[^0-9]/g;
	if (exp.test(obj.value)) {
		alert("숫자만 입력가능합니다.");
		// obj.value = "0"; 
		obj.focus();
	}
}

var callAjax = function(pMethod, pUrl, pData, fnSuccess, fnError, pDataType) {
	if (pMethod == null || pMethod == '') {
		console.debug('callAjax : pMethod is null');
		pMethod = 'POST';
	}
	if (pData == null || pData == '') {
		console.debug('callAjax : pData is null');
		pData = '';
	}
	if (fnSuccess == null || fnSuccess == '') {
		console.debug('callAjax : fnSuccess is null');
		fnSuccess = ajaxSuccess;
	}
	if (fnError == null || fnError == '') {
		console.debug('callAjax : fnError is null');
		fnError = ajaxError;
	}
	if (pDataType == null || pDataType == '') {
		console.debug('callAjax : pDataType is null');
		pDataType = 'json';  
	}

	var promise = $.ajax({
		method: pMethod,
		url: pUrl,
		dataType: pDataType,
		data: pData
	});
	
	$('#result').html('waiting…');
	
	promise.done(fnSuccess);
	
	promise.done(function(){$('#result').hide();});
	
	promise.fail(fnError);
	
	var t = process();
	t.progress(function() {
	  $('#result').html($('#result').html() + '.');
	});
  
	return promise;
};

function process() {
	  var deferred = $.Deferred();
	 
	  timer = setInterval(function() {
	    deferred.notify();
	  }, 1000);
	   
	  setTimeout(function() {
	     clearInterval(timer);
	     deferred.resolve();
	  }, 10000);
	   
	  return deferred.promise();
	}


// 레이어 팝업(문의내역 답변)
function layer_open(el){

	var temp = $('#' + el);		//레이어의 id를 temp변수에 저장
	var bg = temp.prev().hasClass('bg');	//dimmed 레이어를 감지하기 위한 boolean 변수

	if(bg){
		$('.layer').fadeIn();
	}else{
		temp.fadeIn();	//bg 클래스가 없으면 일반레이어로 실행한다.
	}

	// 화면의 중앙에 레이어를 띄운다.
	if (temp.outerHeight() < $(document).height() ) temp.css('margin-top', '-'+temp.outerHeight()/2+'px');
	else temp.css('top', '0px');
	if (temp.outerWidth() < $(document).width() ) temp.css('margin-left', '-'+temp.outerWidth()/2+'px');
	else temp.css('left', '0px');

	temp.find('a.cbtn').click(function(e){
		if(bg){
			$('.layer').fadeOut();
		}else{
			temp.fadeOut();		//'닫기'버튼을 클릭하면 레이어가 사라진다.
		}
		e.preventDefault();
	});

	$('.layer .bg').click(function(e){
		$('.layer').fadeOut();
		e.preventDefault();
	});
}				


var getError = function(xhr, status, err){
	console.log('fn : getError');
    console.log(JSON.stringify(xhr)+'\n'+JSON.stringify(status)+'\n'+JSON.stringify(err));
};

 
function getPaging(startPage,endPage,totalPageSize,currentPage,viewName){
	var pagingHtml = '';
	
	// pagingHtml+='<div class="inner">';
	// pagingHtml+='<a href="javascript:prevPage('+viewName+','+currentPage+');"><img src="/images/icon_prev.gif" alt="앞으로"  width="6px"/></a>';
	// for(startPage; startPage <= endPage; startPage++ ){
	// 	if(startPage == currentPage){
	// 		pagingHtml += '<a href="javascript:searchView('+viewName+','+startPage+');" class="current">'+startPage+'</a>';
	// 	} else {
	// 		pagingHtml += '<a href="javascript:searchView('+viewName+','+startPage+');">'+startPage+'</a>';
	// 	}
	// }
	// pagingHtml += '<a href="javascript:nextPage('+viewName+','+currentPage+','+totalPageSize+');"><img src="/images/icon_next.gif" alt="다음"  width="6px" /></a>';
	// pagingHtml += '</div>';    

	pagingHtml += '<div class="dataTables_paginate paging_full_numbers" >';
	pagingHtml += '<a href="javascript:prevPage('+viewName+','+currentPage+');" class="previous paginate_button paginate_button_disabled">Previous</a>';
	pagingHtml += '<span>';
	
	for(startPage; startPage <= endPage; startPage++ ){
		if(startPage == currentPage){
			pagingHtml += '<a href="javascript:searchView('+viewName+','+startPage+');" class="paginate_active">'+startPage+'</a>';
		} else {
			pagingHtml += '<a href="javascript:searchView('+viewName+','+startPage+');">'+startPage+'</a>';
		}
	}
	pagingHtml += '</span>';
	pagingHtml += '<a href="javascript:nextPage('+viewName+','+currentPage+','+totalPageSize+');" class="next paginate_button">Next</a>';
	pagingHtml += '</div>';

	return pagingHtml;
}


//solider 리스트
var soliderGetSuccess = function(data, status, xhr, groupId){
	var gbInnerHtml = "";
	var classGroupList = data.list;
	$('#pageGrideInSoliderListTb').empty();
	
	
	if( data.list.length > 0 ){
		$.each(data.list, function(index, value) {
			var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);
			
			gbInnerHtml += "<tr data-code='" + value.idx + "'>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+no+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.orgname+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.rank+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.name+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>나라사랑카드번호</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.number+"</td>";  
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.insert_dt+"<br class='changeLine'/> </td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.insert_dt+"<br class='changeLine'/> </td>";
			gbInnerHtml += "</tr>";  
		
		});	
	}else{  
		gbInnerHtml += "<tr><td colspan='8' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
	}
	
	startPage = data.pagingVo.startPage;
	endPage = data.pagingVo.endPage; 
	totalPageSize = data.pagingVo.totalPageSize;
	currentPage = data.pagingVo.currentPage;
	totalRecordSize = data.pagingVo.totalRecordSize;
	
	var viewName='classSoliderList';
	if(totalRecordSize > 0){
		$("#pagginationInSoliderList").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
	}
	$('#pageGrideInSoliderListTb').append(gbInnerHtml);
	
}



// 사이트IP관리 리스트
var ipMngrGetSuccess = function(data, status, xhr, groupId){
	var gbInnerHtml = "";
	var classGroupList = data.list;
	
	$('#pageGrideInMngrListTb').empty();
	
	if( data.list.length > 0 ){
		$.each(data.list, function(index, value) {
			var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);
			
			gbInnerHtml += "<tr>";
			gbInnerHtml += "<td class='t_left'>";
			gbInnerHtml += "<input type='checkbox' name='' id="+no+"><label for="+no+" class='dook'></label></td>";
			gbInnerHtml += "<td>"+no+"</td>";
			gbInnerHtml += "<td>"+value.sma_ipaddress+"</td>";
			gbInnerHtml += "<td>"+value.sma_macaddress+"</td>";
			gbInnerHtml += "<td>"+value.sma_info+"</td>";
			gbInnerHtml += "</tr>";
			
		});	 
	}else{ 
		gbInnerHtml += "<tr><td colspan='5'>등록된 정보가 없습니다. </td></tr>";
	}
	
	startPage = data.pagingVo.startPage;
	endPage = data.pagingVo.endPage; 
	totalPageSize = data.pagingVo.totalPageSize;
	currentPage = data.pagingVo.currentPage;
	totalRecordSize = data.pagingVo.totalRecordSize;
	
	var viewName='classMngrList';
	if(totalRecordSize > 0){
		$(".page_num").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
	}
	$('#pageGrideInMngrListTb').append(gbInnerHtml);
}



// 사이트IP관리 삭제
var deleteIpSuccess = function(data, status, xhr, groupId){
	var url ='/gplcs/ipManagementList.proc';
	
	var keyWord = $("select[name=keyWord]").val();
	var vData = 'notiListCurrentPage=' + $("#notiListCurrentPage").val() +"&keyWord="+ keyWord + "&txtSearch=" + $("#txtSearch").val();
	
	function fnt(data, status, xhr, groupId){ 
		ipMngrGetSuccess(data, status, xhr, groupId); 
		$('.mdl-data-table__cell--non-numeric .form-control').css('opacity', '1');
	}
	
	callAjax('POST', url, vData, fnt, getError, 'json');
}

// 유해사이트관리 삭제
var deleteBlockingNxssSuccess = function(data, status, xhr, groupId){
	var url ='/gplcs/blockingNxssMngrList.proc';

	var keyWord = $("select[name=keyWord]").val();
	var vData = 'notiListCurrentPage=' + $("#notiListCurrentPage").val() +"&keyWord="+ keyWord + "&txtSearch=" + $("#txtSearch").val();
	
	function fnt(data, status, xhr, groupId){ 
		blockingNxssGetSuccess(data, status, xhr, groupId); 
		$('.mdl-data-table__cell--non-numeric .form-control').css('opacity', '1');
	}
	
	callAjax('POST', url, vData, fnt, getError, 'json');
}



//프로그램  리스트
var hmProgramGetSuccess = function(data, status, xhr, groupId){
	var gbInnerHtml = "";
	var sgbInnerHtml = "";
	var classGroupList = data.list;
	var programManagementList = data.programManagementList;	// 목록

	// 목록 배열화
	if(null != programManagementList){
		programManagementList = programManagementList.split('{')[1]
		programManagementList = programManagementList.split('}')[0]
		programManagementList = programManagementList.split(',')
		programManagementList.sort();
	}
	
	$('#pageGrideInHmprogram').empty();
	$('#pageGrideInSgbList').empty();
	
	if( data.sgblist.length > 0 ){
		$.each(data.sgblist, function(index, value) {
			
			sgbInnerHtml +='<div class="col-md-4">';
			sgbInnerHtml +='<div class="card bg-light mb-3" style="width: 100%">';
			sgbInnerHtml +='<div class="card-header">';
			sgbInnerHtml +='<span class="form-check-sign" >'+value.orgname+'</span>';
			sgbInnerHtml += '</div>';
			sgbInnerHtml += '</div>';
			sgbInnerHtml += '</div>';
			sgbInnerHtml += '</div>';
			
		});
	}else{
		sgbInnerHtml += '등록된 사지방 정보가 없습니다.';
	}
	
	if( data.list.length > 0 ){
		$.each(data.list, function(index, value) {
			var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);
			
			gbInnerHtml +='<div class="col-md-4">';
			gbInnerHtml +='<div class="card bg-light mb-3" style="width: 100%">';
			gbInnerHtml +='<div class="card-header">';
			gbInnerHtml +='<div class="form-check">	';
			gbInnerHtml +='<label class="form-check-label">';
			gbInnerHtml +='<input class="form-check-input" type="checkbox" name="programChkbx" value="'+value.pcm_seq+'">';
			gbInnerHtml +='<span class="form-check-sign">'+value.pcm_name+'</span>';
			gbInnerHtml += '</label>';
			gbInnerHtml += '</div>';
			gbInnerHtml += '</div>';
			gbInnerHtml += '<div class="card-body">';
			gbInnerHtml += '<p class="card-text">'+value.pcm_dc+'</p>';
			gbInnerHtml += '</div>';
			gbInnerHtml += '</div>';
			gbInnerHtml += '</div>';
		
		});	
	}else{  
		gbInnerHtml += "등록된 데이터가 없습니다. ";
	}
	
	startPage = data.pagingVo.startPage;
	endPage = data.pagingVo.endPage; 
	totalPageSize = data.pagingVo.totalPageSize;
	currentPage = data.pagingVo.currentPage;
	totalRecordSize = data.pagingVo.totalRecordSize;
	
	$('#pageGrideInHmprogram').append(gbInnerHtml);
	$('#pageGrideInSgbList').append(sgbInnerHtml);

	
	// 프로그램 설정 - 체크박스
	var ckArr = $('#pageGrideInHmprogram input[name=programChkbx]');
	
	if(null != programManagementList){
		$.each(programManagementList, function(i, programValue) {
			$.each(ckArr, function(j, ckbox) {
				if(programValue == $(ckbox).val() ){
					$(ckbox).prop('checked', true);
					return false;
				}
			});
		});
	}
}


//프로그램 업데이트  리스트
var hmProgramUdptGetSuccess = function(data, status, xhr, groupId){
	var programInnerHtml = "";
	var sgbInnerHtml = "";
	var classGroupList = data.list;
	var updateManagementList = data.updateManagementList;	// 목록
	
	// 목록 배열화
	if(null != updateManagementList){
		updateManagementList = updateManagementList.split('{')[1]
		updateManagementList = updateManagementList.split('}')[0]
		updateManagementList = updateManagementList.split(',')
		updateManagementList.sort();
	}
	
	$('#pageGrideInHmprogramUdpt').empty();
	$('#pageGrideInSgbList').empty();
	
	if( data.sgblist.length > 0 ){
		$.each(data.sgblist, function(index, value) {
			
			sgbInnerHtml +='<div class="col-md-4">';
			sgbInnerHtml +='<div class="card bg-light mb-3" style="width: 100%">';
			sgbInnerHtml +='<div class="card-header"><span class="form-check-sign" >'+value.orgname+'</span></div>';
			sgbInnerHtml += '</div>';
			sgbInnerHtml += '</div>';
			sgbInnerHtml += '</div>';
			
		});
	}else{
		sgbInnerHtml += '등록된 사지방 정보가 없습니다.';
	}
	
	if( data.list.length > 0 ){
		$.each(data.list, function(index, value) {
			var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);
			
			// gbInnerHtml += "<tr data-code='" + value.idx + "'>";
			var puStatusStr = "", puStatusChk="";
			if( value.pu_status == "I"){
				puStatusStr = "[신규프로그램]";
			}else if( value.pu_status == "U"){
				puStatusStr = "[업데이트]";
			}else {
				puStatusStr = "[설치완료]";
				puStatusChk = "checked";
			}
			
			
			programInnerHtml +='<div class="col-md-4">';
			programInnerHtml +='<div class="card bg-light mb-3" style="width: 100%">';
			programInnerHtml +='<div class="card-header">';
			programInnerHtml +='<div class="form-check">	';
			programInnerHtml +='<label class="form-check-label">';
			programInnerHtml +='<input class="form-check-input" type="checkbox" name="programChkbx" value="'+value.pu_seq+'" '+puStatusChk+'>';
			programInnerHtml +='<span class="form-check-sign">'+value.pu_name+'</span>';
			programInnerHtml += '</label>';
			programInnerHtml += '<span>'+puStatusStr+'</span></div>';
			
			//programInnerHtml += '<input type="text" name="puStatusStr" id="puStatusStr" value="'+puStatusStr+'"></div>';
			programInnerHtml += '</div>';
			programInnerHtml += '<div class="card-body">';
			programInnerHtml += '<p class="card-text">'+value.pu_dc+'</p>';
			programInnerHtml += '</div>';
			programInnerHtml += '</div>';
			programInnerHtml += '</div>';
			
			
			
		});
	}else{  
		programInnerHtml += "등록된 데이터가 없습니다. ";
	}
	
	startPage = data.pagingVo.startPage;
	endPage = data.pagingVo.endPage; 
	totalPageSize = data.pagingVo.totalPageSize;
	currentPage = data.pagingVo.currentPage;
	totalRecordSize = data.pagingVo.totalRecordSize;
	
	/*var viewName='';
	if(totalRecordSize > 0){
		$("#pagginationInHmProgramList").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
	}*/
	$('#pageGrideInHmprogramUdpt').append(programInnerHtml);
	$('#pageGrideInSgbList').append(sgbInnerHtml);
	
	
	
	// 프로그램 설정 - 체크박스
	var ckArr = $('#pageGrideInHmprogramUdpt input[name=programChkbx]');
	var puStatusStr = $('#pageGrideInHmprogramUdpt input[name=puStatusStr]');
	
	if(null != updateManagementList){
		$.each(updateManagementList, function(i, programValue) {
			$.each(ckArr, function(j, ckbox) {
				if(programValue == $(ckbox).val() ){
					$(ckbox).prop('checked', true);
					$(puStatusStr).val("");
					return false;
				}
			});
		});
	}
}




// 보안관리 리스트
var hmSecurityGetSuccess = function(data, status, xhr, groupId){
	var programInnerHtml = "";
	var securityDeviceInnerHtml = "";
	var sgbInnerHtml = "";
	var classGroupList = data.list;
	var securityList = data.securityList;	// 목록
	
	// 목록 배열화
	if(null != securityList){
		securityList = securityList.split('{')[1]
		securityList = securityList.split('}')[0]
		securityList = securityList.split(',')
		securityList.sort();
	}
	
	$('#pageGrideInHmprogramUdpt').empty();
	$('#securityDevice').empty();
	$('#pageGrideInSgbList').empty();
	
	if( data.sgblist.length > 0 ){
		$.each(data.sgblist, function(index, value) {
			
			sgbInnerHtml +='<div class="col-md-4">';
			sgbInnerHtml +='<div class="card bg-light mb-3" style="width: 100%">';
			sgbInnerHtml +='<div class="card-header">';
			sgbInnerHtml +='<span class="form-check-sign" >'+value.orgname+'</span>';
			sgbInnerHtml += '</div>';
			sgbInnerHtml += '</div>';
			sgbInnerHtml += '</div>';
			sgbInnerHtml += '</div>';
			
		});
	}else{
		sgbInnerHtml += '등록된 사지방 정보가 없습니다.';
	}
	
	
	if( data.list.length > 0 ){
		$.each(data.list, function(index, value) {
			var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);
			
			if( value.sm_gubun == 'P'){
				programInnerHtml +='<div class="col-md-4">';
				programInnerHtml +='<div class="card bg-light mb-3" style="width: 100%">';
				programInnerHtml +='<div class="card-header">';
				programInnerHtml +='<div class="form-check">	';
				programInnerHtml +='<label class="form-check-label">';
				programInnerHtml +='<input class="form-check-input" type="checkbox" name="programChkbx" value="'+value.sm_seq+'">';
				programInnerHtml +='<span class="form-check-sign">'+value.sm_name+'</span>';
				programInnerHtml += '</label>';
				programInnerHtml += '</div>';
				programInnerHtml += '</div>'; 
				programInnerHtml += '</div>';
				programInnerHtml += '</div>';
			}
		}); 
	}else{  
		programInnerHtml += "등록된 데이터가 없습니다. ";
	}
	

	if( data.list.length > 0 ){
		$.each(data.list, function(index, value) {
			var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);
			
			if( value.sm_gubun == 'D'){
				securityDeviceInnerHtml +='<div class="col-md-4">';
				securityDeviceInnerHtml +='<div class="card bg-light mb-3" style="width: 100%">';
				securityDeviceInnerHtml +='<div class="card-header">';
				securityDeviceInnerHtml +='<div class="form-check">	';
				securityDeviceInnerHtml +='<label class="form-check-label">';
				securityDeviceInnerHtml +='<input class="form-check-input" type="checkbox" name="programChkbx" value="'+value.sm_seq+'">';
				securityDeviceInnerHtml +='<span class="form-check-sign">'+value.sm_name+'</span>';
				securityDeviceInnerHtml += '</label>';
				securityDeviceInnerHtml += '</div>';
				securityDeviceInnerHtml += '</div>'; 
				securityDeviceInnerHtml += '</div>';
				securityDeviceInnerHtml += '</div>';
			}
		});
	}else{  
		programInnerHtml += "등록된 데이터가 없습니다. ";
	}
	
	
	startPage = data.pagingVo.startPage;
	endPage = data.pagingVo.endPage; 
	totalPageSize = data.pagingVo.totalPageSize;
	currentPage = data.pagingVo.currentPage;
	totalRecordSize = data.pagingVo.totalRecordSize;
	
	/*var viewName='';
	if(totalRecordSize > 0){
		$("#pagginationInHmProgramList").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
	}*/
	$('#pageGrideInHmprogramUdpt').append(programInnerHtml);
	$('#securityDevice').append(securityDeviceInnerHtml);
	$('#pageGrideInSgbList').append(sgbInnerHtml);
	
	
	
	// 프로그램 설정 - 체크박스
	var ckArr = $('#pageGrideInHmprogramUdpt input[name=programChkbx]');
	
	if(null != securityList){
		$.each(securityList, function(i, programValue) {
			$.each(ckArr, function(j, ckbox) {
				if(programValue == $(ckbox).val() ){
					$(ckbox).prop('checked', true);
					return false;
				}
			});
		});
	}
}



// 백업주기 설정 리트트트
var backupCycleInfoGetSuccess = function(data, status, xhr, groupId){
	var ckArr = $('#week input[type=checkbox]');
	
	var sgbInnerHtml = "";
	var backupGubun = null;
	var backupOption = null;
	var backupTime = null;
	
	// 초기화
	$("#select_id").val('D').prop("selected", true);
	$.each(ckArr, function(j, ckbox) {
		$(ckbox).prop('checked', false);
	});
	$("#basicExample input").val('');
	$('#timepickerqq').val('');
	 
	
	// 값이 있을 경우 값 설정
	if(null != data.backupCycleData){
		if(null != data.backupCycleData.bac_gubun)			backupGubun = data.backupCycleData.bac_gubun;
		if(null != data.backupCycleData.bac_cycle_option) backupOption = data.backupCycleData.bac_cycle_option;
		if(null != data.backupCycleData.bac_cycle_time)	backupTime = data.backupCycleData.bac_cycle_time;
	}
	
	// 목록 배열화 - 매일/매주 인 경우
	if(null != backupOption){
		backupOption = backupOption.split(',')
		backupOption.sort();
	}
	
	$('#pageGrideInSgbList').empty();
	
	if( data.sgblist.length > 0 ){
		$.each(data.sgblist, function(index, value) {
			
			sgbInnerHtml +='<div class="col-md-2">';
			sgbInnerHtml +='<div class="card bg-light mb-3" style="width: 100%">';
			sgbInnerHtml +='<div class="card-header">';
			sgbInnerHtml +='<span class="form-check-sign" >'+value.orgname+'</span>';
			sgbInnerHtml += '</div>';
			sgbInnerHtml += '</div>';
			sgbInnerHtml += '</div>';
			sgbInnerHtml += '</div>';
			
		});
	}else{
		sgbInnerHtml += '등록된 사지방 정보가 없습니다.';
	}
	
	$('#pageGrideInSgbList').append(sgbInnerHtml);
	
//	console.log(' ---- backupGubun : ' + backupGubun);
//	console.log(' ---- backupOption : ' + backupOption);
//	console.log(' ---- backupTime : ' + backupTime);
	
	// 백업주기 설정
	if(null != backupGubun){
		
		// 매일/매주 옵셜 설정
		if('D' == backupGubun){
			
			// 옵션 설정
			$('#week').css('display', 'block');
			$('#month').css('display', 'none');
			
			// 선택창
			$("#select_id").val('D').prop("selected", true);
			
			// 요일체크
			$.each(backupOption, function(i, weekValue) {
				$.each(ckArr, function(j, ckbox) {
					if(weekValue == $(ckbox).val() ){
						$(ckbox).prop('checked', true);
						return false;
					}
				});
			});
		}

		// 매월 옵셜 설정	
		if('M' == backupGubun){
			// 옵션 설정
			$('#week').css('display', 'none');
			$('#month').css('display', 'block');
			
			// 선택창			
			$("#select_id").val('M').prop("selected", true);
			
			// 날짜
			$("#basicExample input").val(backupOption);
		}
	}
	
	// 백업시간 설정
	if(null != backupTime){
		$('#timepickerqq').val(backupTime);
	}
}

var backupRecoveryGetSuccess = function(data, status, xhr, groupId){
	var sgbInnerHtml = "";
	var recoveryInnerHtml = "";
	var recoveryList = data.recoveryList.recoveryList;
	var pcList = data.recoveryList.pcList;
	
	// 초기화
	$('input[name=recovery]').prop('checked', false);
	
	$('#pageGrideInSgbList').empty();
	$('#pageGrideInRecoveryList').empty();


	if( pcList.length > 0 ){
		$.each(pcList, function(index, value) {
			sgbInnerHtml +='<div class="col-md-3">';
			sgbInnerHtml +='<div class="card bg-light mb-3" style="width: 100%">';
			sgbInnerHtml +='<div class="card-header"><label>';
			sgbInnerHtml += '<input type="checkbox" value="' + value.seq + '">';
			sgbInnerHtml +='<span class="form-check-sign" >'+value.pc_hostname+'</span>';
			sgbInnerHtml += '</label></div>';
			sgbInnerHtml += '</div>';
			sgbInnerHtml += '</div>';
			sgbInnerHtml += '</div>';
		});
	}else{
		sgbInnerHtml += '등록된 사지방 정보가 없습니다.';
	}
	
	if(recoveryList.length > 0){
		$.each(recoveryList, function(i, recovery){
			recoveryInnerHtml += '<div class="col-md-3">'; 
			recoveryInnerHtml += '<div class="card bg-light mb-3" style="width: 100%">';
			recoveryInnerHtml += '<div class="card-header">';
			recoveryInnerHtml += '<div class="form-check">';
			recoveryInnerHtml += '<label class="form-check-label">';
			recoveryInnerHtml += '<label>';
			recoveryInnerHtml += '<input type="radio" name="recovery" value="' + recovery.br_seq + '" class="recoIpt">';
			recoveryInnerHtml += '<span>백업일시<br/>' + recovery.br_backup_iso_dt + '</span>';
			/*recoveryInnerHtml += '<span>' + recovery.br_backup_path + '</span>';*/
			recoveryInnerHtml += '</label>';
			recoveryInnerHtml += '</label>';
			recoveryInnerHtml += '</div>';
			recoveryInnerHtml += '</div>';
			recoveryInnerHtml += '</div>';
			recoveryInnerHtml += '</div>';
		});
	}else{
		recoveryInnerHtml += '백업 정보를 찾을 수 없습니다.';
	}

	$('#pageGrideInSgbList').append(sgbInnerHtml);
	$('#pageGrideInRecoveryList').append(recoveryInnerHtml);
}

/* 네비 설정 */
function setNav(title){
	$('.location').html('<li>Home</li><li>'+title+'</li>');
	/* $('.component-slogan').text(info); */
}


function numberWithCommas(x) {
	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function getToday() {
	var today = new Date();

	var year = today.getFullYear();
	var month = ('0' + (today.getMonth() + 1)).slice(-2);
	var day = ('0' + today.getDate()).slice(-2);

	var dateString = year + "/" + month + "/" + day;
	return dateString;
}

function getMonthAgoday() {
	var today = new Date();

	var year = today.getFullYear();
	var month = ('0' + (today.getMonth())).slice(-2);
	var day = ('0' + today.getDate()).slice(-2);

	var dateString = year + "/" + month + "/" + day;

	return dateString;
}
