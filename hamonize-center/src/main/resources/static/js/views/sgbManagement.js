 /** 
  * Writing day : 2019.04.29
  * Modifying day : 2019.04.29
  * Writer : LukeHan(LukeHan1128@gmail.com)
  */

$(document).ready(function(){
	//클릭시 이벤트
	$('.tui-tree-text.tui-js-tree-text.node').on('click', function(){
	});
	
	// 그룹 클릭
	$('.groupLabel').on('click', function(){
		group_label_fnt(this);
	});
	
	// 하위부서 생성
	$('#addGroup').on('click', function(){
		add_group_fnt();
	});
	
	// 저장
	$('#insert').on('click', '.saveGroup', function(){
		save_group_fnt(this);
	});
	
	// 삭제
	$('#insert').on('click', '.deleteGroup', function(){
		delete_group_fnt(this);
	});
});



// 부서명 확인
function ck_orgname_fnt($orgname){
	var ck = true;

	$orgname = $orgname.trim();

	if($orgname == null || 1 > $orgname.length){
		ck = false;
		alert('부서명이 입력되지 않았습니다.');
	}
	return ck;
}

// 코드 및 스탭 확인
function ck_code_n_step_fnt($val){
	var regex= /[^0-9]/g
	var ck = true;
	
	$val = $val.trim();
	
	if($val == null || 1 > $val.length || !regex.test($val)){
		ck = false;
		alert('잘못된 입력입니다.');
	}
	return ck;
}


// 그룹 클릭
function group_label_fnt(doc){
	var $lavel = $(doc).parent('div').parent('li').find('.groupLabel');
	var $defaultStep = $(doc).data("value");
	var formText = '';
	
	// 초기화
	$('#insert').css('display', 'block');
	$('#groupForm').empty();
	
	// 동적생성을 위한 텍스트
	for(var i=0; i<$lavel.length ;++i){
		formText += mk_form_text($lavel[i], $($lavel[i]).data("value"), $defaultStep);
	}
	
	// 생성
	$('#groupForm').html(formText);
}

// 입력폼 생성 - 텍스트
function mk_form_text(doc, step, defaultStep){
	var formText;
	
	formText = '<div data-value="' + step + '" data-upcode="' + $(doc).data("upcode") + '" data-code="' + $(doc).data("code") + '" class="addForm input-group mb-3';
	
	// 들여쓰기
	if(step == defaultStep) formText += ' formBase">';
	else formText += '" style="padding-left: ' + ((step - defaultStep)*20) + 'px">';
	
	var textSplitData = "";
	var splitTmp = $(doc).text().split("]");
	console.log("splitTmp.length=="+ splitTmp.length);
	
	if( splitTmp.length > 1 ){
		console.log("1========"+ splitTmp[0] + "-- "  + splitTmp[1]);
		textSplitData = splitTmp[1];
	}else{
		console.log("222+++===="+ splitTmp[0] + "-- "  + splitTmp[1]);
		textSplitData = $(doc).text();
	}
	
	formText += '<input type="text" name="orgname" placeholder="부서명" class="form-control" value="' + textSplitData + '">';
	formText += '<input type="button" class="saveGroup btn btn-outline-success waves-effect" value="저장"> ';
	formText += '<input type="button" class="deleteGroup btn btn-outline-info" value="삭제">';
	
	formText += '</div>';
	
	return formText;
}


// 하위부서 생성
function add_group_fnt(){
	var doc = $('#groupForm > .addForm').eq(0);
	
	$(doc).data("upcode", $(doc).data("code"));
	$(doc).data("code", '');
	
	$('#groupForm > .formBase').after(mk_form_text(doc, ($(doc).data("value")+1), $(doc).data("value")));
}

// 저장
function save_group_fnt(saveGroup){
	var $orgname = $(saveGroup).parent('.addForm').children('input[name=orgname]').val();
	var $code = $(saveGroup).parent('.addForm').data('code');
	var $upcode;
	var $step;
	
	if(null == $code || '' == $code){
		// 부서 생성
		console.log(" :::: " + $('#groupForm > .formBase').length);
		saveGroup = $('#groupForm > .formBase').eq(0);
		
		$upcode = $(saveGroup).attr('data-upcode');
		$code = $(saveGroup).attr('data-code');
		$step = $(saveGroup).data('value');
		
		console.log(" - 부서생성 :::: orgname : " + $orgname + "\n - upcode : " + $upcode + "\n - code : " + $code + "\n - step : " + $step);
	}else{
		// 부서 수정
//		$orgname = $(saveGroup).parent('.addForm').children('input[name=orgname]').val();
//		$upcode = $(saveGroup).parent('.addForm').data('upcode');
//		$step = $(saveGroup).parent('.addForm').data('value');
		
	}
	console.log(" - orgname : " + $orgname + "\n - upcode : " + $upcode + "\n - code : " + $code + "\n - step : " + $step);
	
	// 확인 - 변경필요
	if( !( ck_orgname_fnt($orgname) ) ){
		return
	}
	
	
	$.ajax({
		url : '/group/sgbInsert',
		type: 'POST',
		data:{
			orgname :$orgname,
			orgcode : $code,
			orguppercode : $upcode,
			orgstep : $step
		},
		success : function(res) {
			alert(res);
			location.reload();l
		},
		error:function(request,status,error){
			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			$('#textInfo').text(msg.AJAX_FAIL);
		}
	});
}


// 삭제
function delete_group_fnt(group){
	console.log($(group).parent('.addForm').attr('data-upcode'));
	$upcode = $(group).parent('.addForm').attr('data-upcode');
	$code = $(group).parent('.addForm').attr('data-code');
	$step = $(group).parent('.addForm').attr('data-value');
	$upcode = $upcode.trim();
	$code = $code.trim();
	$step = $step.trim();
	
	if(undefined == $upcode || null == $upcode || 1 > $upcode.length || undefined == $code || null == $code || 1 > $code.length){
		alert('유효하지 않은 코드입니다. 확인후 다시 시도해 주시기 바랍니다.');
		return
	}
	
	$.ajax({
		url : '/group/delete',
		type: 'POST',
		data:{
			orguppercode : $upcode,
			orgcode : $code,
			orgstep : $step
		},
		success : function(res) {
			alert(res);
			location.reload();
		},
		error:function(request,status,error){
			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			$('#textInfo').text(msg.AJAX_FAIL);
		}
	});
}
