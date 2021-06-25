<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp"%>
<link rel="stylesheet" type="text/css" href="/css/ztree/zTreeStyle.css" />
<script type="text/javascript" src="/js/ztree/jquery.ztree.core.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.exedit.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.excheck.js"></script>

<!-- <link rel="stylesheet" href="/css/materialize.css">
<script src="/js/materialize.js"></script> -->

<style>
.tts {
    position: absolute;
    left: -9999px;
    width: 1px;
    height: 1px;
    font-size: 0;
    line-height: 0;
    overflow: hidden;
}

.btn {
	display: inline-block;
	text-align: center;
	vertical-align: middle;
	white-space: nowrap;
	text-decoration: none !important;
}

</style>
<script type="text/javascript">
//<![CDATA[

	
	$(document).ready(function(){
		setNav('PC등록');
		
	//등록버튼
	$("#btnSave").click(fnSave);
	
	// 파일첨부 디자인 버튼
	$('.btn-attach, .input_type1').bind("click", function(){
		$(this).siblings('input[type=file]').click();
	});
	$('input[type=file]').bind("change", function(){
		if(window.FileReader) {
			// modern browser
			var filename = $(this)[0].files[0].name;
		} else {
			// old IE 
			var filename = $(this).val().split('/').pop().split('\\').pop();
		} 
		$(this).siblings('.input_type1').val(filename); 
	});

	
});
	
	function showFile(){
		$('#pageGrideInPcMngrListTb').empty();
		var cnt = 0;
		var shtml = "";
		var frm = $("frm")[0];
		var formData = new FormData(frm);
		formData.append("filename",$("input[name=filename]")[0].files[0]);
		formData.append("input-fake",$("input[name=input-fake]").val());
		$.ajax({
		    type : "POST",
		    url : "showJsonPc.do",
		    data : formData,
		    processData: false,
		    contentType: false,
		    success : function(data) {
		    	var gbInnerHtml = "";
				
				if( data.list.length > 0 ){
					$.each(data.list, function(index, value) {
						var i = index +1;
						gbInnerHtml += "<tr>";
						gbInnerHtml += "<input type=\"hidden\" name=\"sgb_pc_ip\" id=\"sgb_pc_ip\" class=\"input_type1\" value="+value.sgb_pc_ip+">";
						gbInnerHtml += "<td>"+i+"</td>";
						gbInnerHtml += "<td><input type=\"text\" name=\"name\" id=\"name\" class=\"input_type1 w100\" value="+value.name+"></td>";
						if(value.flag == "Y"){
							 gbInnerHtml += "<td>정상</td>"; 
						 }else{
							 cnt++;
							 gbInnerHtml += "<td style=\"color:red\">패턴에러</td>"; 
						 }
						gbInnerHtml += "<td><input type=\"text\" name=\"sgbname\" id=\"sgbname\" class=\"input_type1\" readonly value="+value.sgbname+"></td>";
						gbInnerHtml += "<td><input type=\"text\" name=\"date\" id=\"date\" class=\"input_type1\" value="+value.date+"></td>";
						gbInnerHtml += "</tr>";
					});	
				}else{  
					gbInnerHtml += "<tr><td colspan='5' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
				}
				$('#pageGrideInPcMngrListTb').append(gbInnerHtml);
				
		    },
		    err : function(err) {
		        alert("실패하였습니다.");
		    }
		});
	    return false;
	}	
	

//등록 처리결과(공통명 : 프로그램명Json )
function fnSave(){
	
	if($("#filename").val()== ""){
		alert("파일을 등록해주세요.");
		return false;
	}
	var success = true;
	var pcArray = [];    
    $('#pageGrideInPcMngrListTb tr').each(function(i){// 리스트 저장
    	  if($("#pageGrideInPcMngrListTb tr").eq(i).find('input[name="date"]').val() == "" || $("#pageGrideInPcMngrListTb tr").eq(i).find('input[name="date"]').val() == 'null'){
    		alert("설치일을 입력해주세요.");
    		success = false;
            return success;
    	}
    	if($("#pageGrideInPcMngrListTb tr").eq(i).find('input[name="date"]').val().length > 4){
    		alert("설치월일만 입력해주세요.");
    		success = false;
            return success;
    	}  
    	
    	var data = {
    		"name":$("#pageGrideInPcMngrListTb tr").eq(i).find('input[name="name"]').val(),
    		"sgbname":$("#pageGrideInPcMngrListTb tr").eq(i).find('input[name="sgbname"]').val(),
    		"date":"2019"+$("#pageGrideInPcMngrListTb tr").eq(i).find('input[name="date"]').val(),
    		"sgb_pc_ip":$("#pageGrideInPcMngrListTb tr").eq(i).find('input[name="sgb_pc_ip"]').val()
    		
    };
    	pcArray.push(data);
    });
    if (!success)
    	   return false;
    
    $.post("saveJsonPc.do", {dataType:'json', data:JSON.stringify(pcArray)}, 
			 function(data){
    	var wrongNum = data.wrongNum + 1;
		if(data.result=="SUCCESS"){
			alert("정상적으로  처리되었습니다.");
			location.reload();
		}
		else
			alert(wrongNum+"번째 패턴이 잘못되었습니다.");
   }); 

	/* $.ajax({
	    type : "POST",
	    url : "saveJsonPc.do",
	    data : JSON.stringify(pcArray),
	    success : function(data) {
	         if(data == "SUCCESS"){
	            alert("정상적으로 등록되었습니다.");
	        }else{
	            alert("실패하였습니다.");
	        } 
	         location.reload();
	    },
	    err : function(err) {
	        alert("실패하였습니다.");
	    }
	}); */
    return false;
}
//]]>
</script>

<body>
	<%@ include file="../template/topMenu.jsp"%>
	<%@ include file="../template/topNav.jsp"%>


	
	
	<div class="hamo_container other">
	     
	 <!-- 좌측 트리 -->
        <div class="con_left">
        <div class="left_box">
        <ul class="location">
                </ul>
                <h2 class="tree_head">PC등록</h2>
            <form name="frm" id="frm" method="post" action="jsonPcSave.do" style="padding: 15px;">
            <br/>
	         <h3><span>파일 업로드</span></h3>
      				<input type="file" name="filename" id="filename" class="tts" title="파일첨부" value="" onChange="showFile()"><br /> 
					<input type="text" class="input_type1" name="input-fake" title="파일명" style="width:calc(100% - 80px);" readonly>
					<button type="button" class="btn_type3 btn-default btn-attach">찾아보기</button>

		</form>
        </div>
        </div>
	
		<!-- 우측 리스트 -->
		<div class="con_right">
	     <div class="right_box">
	      <h3>AMT개통pc 정보 검사</h3>
	         json 파일 규격 :<strong>pc일련번호=IP=MACADDR </strong>
	          EX)H10249=172.29.74.71=04-d9-f5-a9-d6-a4
	     <div class="board_list mT20">
	            <table>
	                <colgroup>
	                   <col style="width:5%;" />
	                   <col style="width:45%;" />
	                   <col style="width:10%;" />
	                   <col style="width:20%;" />
	                   <col style="width:20%;" />
	                </colgroup>
	                <thead>
	                   <tr>
	                   	   <th>번호</th>
	                       <th>name</th>
	                       <th>상태</th>
	                       <th>방번호</th>
	                       <th>설치일(0901)</th>
	                   </tr>
	                </thead>
	                <tbody id="pageGrideInPcMngrListTb"></tbody>
	            </table>
	        </div>
	     
		<!-- //update list -->
			         <div class="right mT20" id="buttons">
			             <!-- <button type="reset" class="btn_type2" id="btnInit"> 초기화</button> -->
			             <button type="button" class="btn_type2" id="btnSave" > 저장</button>
			         </div>
	    	</div>
		 </div>
	</div>

	<!-- content body -->
	<%-- <div class="mng_menu org" style="width: 100%; text-align: center;">
		<div class="tree_area" style="display: inline-block;">
			<div class="tree_ctrl">
				<button type="button" class="btn inline nav" id="expandAllBtn" style="float: left;">+ 전체열기</button>
				<button type="button" class="btn inline nav" id="collapseAllBtn">- 전체닫기</button>
			</div>
			<div class="scroll_area">
				<ul id="tree" class="ztree"></ul>
			</div>
			<!-- <div class="menu_ctrl">
				<button type="button" class="btn act" id="btnAddOrg" name="btnAddOrg">+ 부대추가</button>
				<button type="button" class="btn" id="btnDelOrg" name="btnDelOrg">- 부대삭제</button>
				<button type="button" class="btn act" id="btnAddOrg_s" name="btnAddOrg_s">+ 사지방추가</button>
				<button type="button" class="btn act" id="btnChange" name="btnChange">순서변경</button>
			</div> -->
		</div>
		<div class="input_area" style="display: inline-block;">
		
		<form name="frm" method="post" action="orgManage.do" >					
			<input type="hidden" name="org_seq"  id="org_seq" value="" />
			<input type="hidden" name="ppm_seq" id="ppm_seq" value="" />
			<input type="hidden" name="section" id="section" value="" />
			
			<c:forEach items="${pList}" var="data" varStatus="status" >
			<c:if test="${data.sm_gubun eq 'D'}">
			<input type="checkbox" name="sm_seq" value="<c:out value="${data.sm_seq}" />">
			<c:out value="${data.sm_name}" /><c:out value="${data.sm_dc}" />
			</c:if>
			</c:forEach>	
			<div class="btn_area">
				<button type="reset" class="btn nav"  id="btnInit" style="float: left;">초기화</button>
				<button type="button" class="btn act" id="btnSave">변경저장</button>		
			</div>
		</form>
		</div>
	</div> --%>


	<%@ include file="../template/grid.jsp"%>
	<%@ include file="../template/footer.jsp"%>


</body>
</html>