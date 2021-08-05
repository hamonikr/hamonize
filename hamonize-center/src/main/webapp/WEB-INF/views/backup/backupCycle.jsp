<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/ztree/zTreeStyle.css" />
<script type="text/javascript" src="/js/ztree/jquery.ztree.core.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.exedit.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.excheck.js"></script>
<style>

/* 레이어 달력 */
#divCalendar {position:absolute; width:180px; padding:8px 10px; border:2px solid #999; font-size:11px; background-color:#fff; z-index:999;}
#divCalendar * {margin:0; padding:0; font-size:11px !important;}
#divCalendar caption {height:0; font-size:0; line-height:0; overflow:hidden;}
#divCalendar table {table-layout:auto; width:100%; text-align:center; border:0px solid #000; color:#000;}
#divCalendar table, #divCalendar table a {font-size:13px; line-height:20px;}
#divCalendar #tableCalendarTitle td, #divCalendar #tableCalendarTitle td a, #divCalendar #tableMonthTitle td a, #tableYearTitle td {font-weight:600; font-size:13px !important;}
#divCalendar #tableYear a {font-size:12px !important;}
#divCalendar table th {border:0px solid #f8720f; height:auto; background:none; padding:0 !important; margin:0; color:#595959; text-align:center; line-height:20px;}
#divCalendar table td {padding:0 !important; margin:0; height:auto; text-align:center; border:0px solid #000; line-height:1;}
#divCalendar table td a {display:block; color:#595959; text-decoration:none;}
#divCalendar table td a.today {color:#fff !important; background-color:#437dca; font-weight:600; border:1px solid #2059a5; border-radius:2px;}
#divCalendar #tableCalendar th:first-child, #divCalendar #tableCalendar td:first-child a {color:#cf2121;}
#divCalendar #tableCalendar th:last-child, #divCalendar #tableCalendar td:last-child a {color:#0072cf;}
#divCalendar .btn_cal_close {position:absolute; top:-2px; right:-19px; text-align:right;}
#divCalendar .btn_cal_close a {display:block; background:url(/images/ico_delete.gif) no-repeat; text-indent:100%; white-space:nowrap; overflow:hidden;}
#divCalendar .btn_cal_close, #divCalendar .btn_cal_close a {width:17px; height:16px;}
</style>

<link rel="stylesheet" type="text/css" href="/css/jquery.timepicker.css" />
<script type="text/javascript" src="/js/jquery.timepicker.js"></script>
<script type="text/javascript">
//<![CDATA[
//zTree 셋팅
	var setting = {
			view: {
				selectedMulti: false
			},
			data: {
				simpleData: {
					enable: true
				}
			},
			 check: {
				enable: true,
				chkboxType: { "Y" : "s", "N" : "ps" }
			},
			edit: {
				drag: {
				}, 
				enable: true,
				showRemoveBtn: false,
				showRenameBtn: false
			},
			callback: {
				beforeClick: beforeClick,
				onClick: onClick
			}
		};
	var zNodes =[
		<c:forEach items="${oList}" var="data" varStatus="status" >
		{ id:"${data.seq}", pId:"${data.p_seq}",
			<c:if test="${data.section ne 'S'}">
			name:"${data.org_nm}",
			icon:"/images/icon_tree1.png"
			</c:if>
			<c:if test="${data.section eq 'S'}">
			name:"[B]"+"${data.org_nm}",
			icon:"/images/icon_tree2.png"
			</c:if>
			,od:"${data.org_ordr}"
			<c:if test="${data.level eq '0' or data.level eq '1' or data.level eq '2'}">
			,open:true
			</c:if>},
		</c:forEach>				
	];
	
	$(document).ready(function(){
		setNav('백업관리 > 백업주기설정');
	//트리 init
	$.fn.zTree.init($("#tree"), setting, zNodes); 
	
	$("#expandAllBtn").bind("click", {type:"expandAll"}, expandNode);
	$("#collapseAllBtn").bind("click", {type:"collapseAll"}, expandNode);
		
	//등록버튼
	 $("#btnSave").click(fnSave);
	
	$("input[name=bac_gubun]").on("change", function(){
		 if( $(this).val() == "D" ){
			 $(".ui-datepicker-trigger").prop("disabled",true); //매월 버튼 막기
			 $('input:checkbox[name=bac_cycle_option]').prop("disabled",false); //매주 체크박스 막기
			 $('input:checkbox[name=bac_cycle_option]').prop("checked", false); //매주 체크 해제
			 $("input[name=bac_cycle_date]").val(""); //매월 날짜 초기화
		}else if( $(this).val() == "M" ){
			$('input:checkbox[name=bac_cycle_option]').prop("disabled",true); //매주 체크박스 막기
			$(".ui-datepicker-trigger").prop("disabled",false); //매월 버튼 막기 해제
			$('input:checkbox[name=bac_cycle_option]').prop("checked", false); //매주 체크 해제
		}
		else if( $(this).val() == "E" ){
			$(".ui-datepicker-trigger").prop("disabled",true); //매월 버튼 막기bac_gubun
			$('input:checkbox[name=bac_cycle_option]').prop("disabled",true); //매주 체크박스 막기
			$('input:checkbox[name=bac_cycle_option]').prop("checked", false); //매주 체크 해제
			$("input[name=bac_cycle_date]").val(""); //매월 날짜 초기화 
			
		}
	});
	//달력
	 $("#bac_cycle_date").datepicker();
	
});
	//시간
	function fn_timePicker(obj) {
		var id = $(obj).attr("id");
		$("#" + id).timepicker({
			timeFormat : "HH:mm",
			interval : 30,
			dynamic : false,
			dropdown : true,
			scrollbar : true
		});
		$("#" + id).timepicker("open");
	}
	
	var log, className = "dark", curDragNodes, autoExpandNode;
	
	function setTrigger() {
		var zTree = $.fn.zTree.getZTreeObj("tree");
		zTree.setting.edit.drag.autoExpandTrigger = $("#callbackTrigger").attr("checked");
	}
	
	 function beforeClick(treeId, treeNode,clickFlag) {
		var zTree = $.fn.zTree.getZTreeObj("tree");
		zTree.checkNode(treeNode, !treeNode.checked, true, true);
		return true;
	} 


//메뉴펼침, 닫힘
function expandNode(e) {
	var zTree = $.fn.zTree.getZTreeObj("tree"),
	type = e.data.type,
	nodes = zTree.getSelectedNodes();
	if (type == "expandAll") {
		zTree.expandAll(true);
	} else if (type == "collapseAll") {
		zTree.expandAll(false);
	} 
}
//메뉴 Tree onClick
function onClick(event, treeId, treeNode, clickFlag) {
	$('input:checkbox[name=bac_cycle_option]').prop("checked", false);
	$('input:radio[name=bac_gubun]').prop("checked", false);
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		if(treeNode.checked){
			console.log("treeNode.id=="+treeNode.id);
		$.post("backupShow.do",{org_seq:treeNode.id},
		function(result){
			    $('input[name=bac_cycle_time]').val()
				var agrs = result;
				
				console.log( "backupShow dataInfo: " + agrs.dataInfo);
				if(agrs.dataInfo != null){
					
				$('input:radio[name="bac_gubun"][value='+agrs.dataInfo.bac_gubun+']').prop('checked',true);
				$('input[name=bac_cycle_time]').val(agrs.dataInfo.bac_cycle_time);
				if(agrs.dataInfo.bac_gubun == "M")
				$('input[name=bac_cycle_date]').val(agrs.dataInfo.bac_cycle_option);

				var bac_cycle_option = agrs.dataInfo.bac_cycle_option;
				bac_cycle_option = bac_cycle_option.split(",");
				for(var i=0; i < bac_cycle_option.length; i++){
				 $('input:checkbox[name=bac_cycle_option]').each(function() {
					 if($(this).val() == bac_cycle_option[i] ){
						 $(this).prop("checked", true);
						 console.log($(this).val() +"======"+ bac_cycle_option[i]);
					 }
				    });
				}
		
			}

		});
		}		
		}
		
function setCheck() {
	var zTree = $.fn.zTree.getZTreeObj("tree"),
	py = $("#py").attr("checked")? "p":"",
	sy = $("#sy").attr("checked")? "s":"",
	pn = $("#pn").attr("checked")? "p":"",
	sn = $("#sn").attr("checked")? "s":"",
	type = { "Y":py + sy, "N":pn + sn};
	zTree.setting.check.chkboxType = type;
	showCode('setting.check.chkboxType = { "Y" : "' + type.Y + '", "N" : "' + type.N + '" };');
}



//등록 처리결과(공통명 : 프로그램명Json )
function fnSave(){
	var button = document.getElementById('btnSave');

	if(confirm("하위부서가 있다면 하위부서에도 전부 적용됩니다 적용하시겠습니까?")){
	var bac_cycle_option = "";
	var bac_cycle_time = $('input[name=bac_cycle_time]').val();
	var bac_cycle_date = $('input[name=bac_cycle_date]').val();
	var bac_gubun = $("input:radio[name=bac_gubun]:checked").val();
	
	
	if(bac_gubun == ""){
		alert("백업주기를 선택해주세요.");
		return false;
	}
	if(bac_cycle_time == ""){
		alert("백업시간을 입력해주세요.");
		return false;
	}
	
	if(bac_gubun == "D"){
    $('input:checkbox[name=bac_cycle_option]').each(function(i) {
       if($(this).is(':checked'))
    	   bac_cycle_option += ($(this).val())+",";
    });
	bac_cycle_option = bac_cycle_option.substr(0,bac_cycle_option.length -1);
	if(bac_cycle_option == ""){
		alert("백업요일을 선택해주세요.");
		return false;
	}
    console.log("매주====="+bac_cycle_option);
	} else if (bac_gubun == "M"){
		bac_cycle_option = bac_cycle_date;
		if(bac_cycle_option == ""){
			alert("백업날짜를 선택해주세요.");
			return false;
		}
		console.log("매월====="+bac_cycle_option);	
	}

    
    var zTree = $.fn.zTree.getZTreeObj("tree");
	var nodes = zTree.getCheckedNodes(true);
	var nodeLength=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
	var queryArr=[];
	if(nodes.length == 0){
		alert("부서를 선택해주세요.");
		return false;
	}
    console.log(nodes);
    
    $.each(zTree.transformToArray(zTree.getNodes()) && nodes,function(i,v){
    	if(i>=0){
			if(v.children!=null)
			nodeLength[v.level]=0;
			nodeLength[eval(v.level-1)]++;
			 var data={
					 "org_seq": v.id
			} 
			queryArr.push(data);
    	}
	})
	
	button.disabled	= true;

	$.post("backupSave.do", {dataType:'json',bac_cycle_option:bac_cycle_option,
		  bac_cycle_time:bac_cycle_time,bac_gubun:bac_gubun, data:JSON.stringify(queryArr)}, 
			 function(result){
		if(result=="SUCCESS"){
			alert("정상적으로  처리되었습니다.");
			button.disabled	= false;
			location.reload();
		}
		else{
			alert("실패하였습니다.");
			button.disabled	= false;
		}
			
    });  

    return false;
	}
}
//]]>
</script>

<body>
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	
	<div class="hamo_container other">

        <!-- 좌측 트리 -->
    <div class="con_left">
        <div class="left_box">
            <ul class="location">
                <li>Home</li>
                <li>Location</li>
            </ul>
            <h2 class="tree_head">백업관리</h2>

            <ul class="view_action">
				<li id="expandAllBtn">전체열기 </li>
				<li id="collapseAllBtn">전체닫기</li>
			</ul>
		
			<!-- 트리 리스트 -->
            <div class="tree_list">
                <ul id="tree" class="ztree"></ul>
            </div>
        </div>
    </div>

        <!-- 우측 리스트 -->
    <div class="con_right">
        <div class="right_box">

            <h3>백업주기 선택</h3>              
            <div class="board_view mT20">
            <form name="frm" method="post" action="orgManage.do" class="row">					
								<input type="hidden" name="org_seq"  id="org_seq" value="" />
								<input type="hidden" name="ppm_seq" id="ppm_seq" value="" />
								<input type="hidden" name="section" id="section" value="" />
                <table>
                    <colgroup>
                        <col style="width:15%;" />
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th rowspan="3">백업주기선택</th>
                            <td><input type="radio" name="bac_gubun" id="bac_gubun1" value="E"><label for="bac_gubun1" class="pR50 blue">매일</label></td>
                        </tr>
                        <tr>
                            <td>
                                <input type="radio" name="bac_gubun" id="bac_gubun2" value="D"><label for="bac_gubun2" class="pR50 blue">매주</label>

                                <input type="checkbox" name="bac_cycle_option" id="sun" value="sun"><label for="sun" class="pR20">일</label>
                                <input type="checkbox" name="bac_cycle_option" id="mon" value="mon"><label for="mon" class="pR20">월</label>
                                <input type="checkbox" name="bac_cycle_option" id="tue" value="tue"><label for="tue" class="pR20">화</label>
                                <input type="checkbox" name="bac_cycle_option" id="wed" value="wed"><label for="wed" class="pR20">수</label>
                                <input type="checkbox" name="bac_cycle_option" id="thu" value="thu"><label for="thu" class="pR20">목</label>
                                <input type="checkbox" name="bac_cycle_option" id="fri" value="fri"><label for="fri" class="pR20">금</label>
                                <input type="checkbox" name="bac_cycle_option" id="sat" value="sat"><label for="sat" class="pR20">토</label>

                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="radio" name="bac_gubun" id="bac_gubun3" value="M"><label for="bac_gubun3" class="pR50 blue">매월</label>
                                <label for="date1"></label><input type="text" name="bac_cycle_date" id="date" class="input_type1" autocomplete="off"/> 
                                <a href="#divCalendar" class="btn_cal" onclick="openCalendar(document.getElementById('date')); return false;"><img src="/images/datepicker-icon.png" style="width:37px; height:37px;" alt="달력버튼"/></a> 
                            </td>
                        </tr>
                        <tr>
                            <th rowspan="3">백업시간 선택</th>
                            <td>
								<input type="text" id="bac_cycle_time" name="bac_cycle_time" onclick="javascript:fn_timePicker(this);" class="input_type1" placeholder="시간선택" autocomplete="off" />
                            </td>
                        </tr>
                    </tbody>
                </table>
                </form>
            </div>
			<!-- //List -->
					<div class="right mT20">
			             <button type="button" class="btn_type2" id="btnSave"> 저장</button>
			         </div>



        </div>
    </div>


	</div>
	<!-- //content -->
	
	<%@ include file="../template/grid.jsp" %>
	<%@ include file="../template/footer.jsp" %>
	
	
</body>
</html>