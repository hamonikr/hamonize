<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>


<script>
function beforeClick(treeId, treeNode, clickFlag) {
	className = (className === "dark" ? "":"dark");
	return (treeNode.click != false);
}
function onCheck(event, treeId, treeNode) {
}
//메뉴 Tree onClick
function onClick(event, treeId, treeNode, clickFlag) {
	console.log("p_seq===="+$('form[name=frm] input[name=p_seq]').val());
	var zTree = $.fn.zTree.getZTreeObj("tree");
	var node = zTree.getNodeByParam('id', treeNode.pId);
	var pSpan = "#"+treeNode.parentTId+"_span";
	console.log(treeNode);
	
	$.post("/org/orgManage",{type:'show',seq:treeNode.id,domain:treeNode.domain},
	function(result){
		var agrs = result;

		if(agrs.section == "S"){
			
			$("#trOrg_num").remove();
			$("#trPseq").remove();
			$('#nm').html("팀명");
		
			var shtml = "<tr id=\"trPseq\"><th>상위 조직번호</th> <td><input type=\"text\" name=\"p_seq\" id=\"p_seq\" class=\"input_type1 w100\" readonly /></td></tr>";
			$(".board_view tbody").append(shtml);
		}else{
			$('#nm').html("조직명");
			$("#trOrg_num").remove();
			$("#trPseq").remove();
				
			var shtml = "<tr id=\"trPseq\"><th>상위 조직번호</th> <td><input type=\"text\" name=\"p_seq\" id=\"p_seq\" class=\"input_type1 w100\" /></td></tr>";
			
			$(".board_view tbody").append(shtml);
		}
		$('form[name=frm] input[name=p_org_nm]').val($(pSpan).text());
		$('form[name=frm] input[name=seq]').val(agrs.seq);
		$('form[name=frm] input[name=p_seq]').val(agrs.p_seq);
		$('form[name=frm] input[name=org_ordr]').val(agrs.org_ordr);
		$('form[name=frm] input[name=org_nm]').val(agrs.org_nm);
		$('form[name=frm] input[name=sido]').val(agrs.sido);
		$('form[name=frm] input[name=gugun]').val(agrs.gugun);
		$('form[name=frm] input[name=all_org_nm]').val(agrs.all_org_nm);
		$('form[name=frm] input[name=section]').val(agrs.section);
		$('form[name=frm] input[name=inventory_id]').val(agrs.inventory_id);
		$('form[name=frm] input[name=group_id]').val(agrs.group_id);
	
	});
}

$(document).ready(function () {
	//등록버튼
	$("#btnSave").click(fnSave);
	$.ajaxSetup({ async:false });

	//$("#btnAddOrg").unbind("click");
	$("#btnAddOrg").on("click", {isParent:false}, addOrgcht);
	$("#btnAddOrg_s").bind("click", {isParent:false}, addOrgcht_s);
	$("#btnDelOrg").bind("click", removeOrgcht);
	
});

//조직 추가
 function addOrgcht(e) {
	$("#trOrg_num").remove();
	$("#trSido").remove();
	$("#trGugun").remove();
	$("#trPseq").remove();
	var shtml = "";
	$(".board_view tbody").append(shtml);
		
		var zTree = $.fn.zTree.getZTreeObj("tree"),
		isParent = e.data.isParent,
		nodes = zTree.getSelectedNodes(),
		treeNode = nodes[0];
		$("#nm").html("조직명");
		$("#org_nm").attr("placeholder","조직명을 입력하세요");
				
		console.log("isParent: "+ isParent);
		console.log(nodes);
		console.log("treeNode: "+ treeNode);
		
		if (treeNode) {
			$('form[name=frm] input[name=type]').val('save');
			$('form[name=frm] input[name=p_org_nm]').val('');
			$('form[name=frm] input[name=org_nm]').val('');
			$('form[name=frm] input[name=p_seq]').val('');
			$('form[name=frm] input[name=seq]').val('');
			if(treeNode.children==null)
				$('form[name=frm] input[name=org_ordr]').val(1);
			else		
				$('form[name=frm] input[name=org_ordr]').val(treeNode.children.length+1);
				
				$('form[name=frm] input[name=p_org_nm]').val(treeNode.name);
				$('form[name=frm] input[name=p_seq]').val(treeNode.id);
				//$('form[name=frm]').append("<input type='hidden' name='p_seq' id='p_seq' value='"+treeNode.id+"' />");
				$('form[name=frm] input[name=org_nm]').focus();
				
				console.log("treeNode.id==="+treeNode.id);
				console.log("all====="+$("#all_org_nm").val());
				console.log(treeNode.name);
				console.log(treeNode.id);
				console.log($("#seq").val());
				console.log();
			
		} else {
			alert("조직을 선택해 주세요.");
		}
	};
	
	//팀 추가
	 function addOrgcht_s(e) {
		 $("#trSido").remove();
		 $("#trGugun").remove();
		 $("#trOrg_num").remove();
		 $("#trPseq").remove();
		
		var shtml = "";
		$(".board_view tbody").append(shtml);
		
		var zTree = $.fn.zTree.getZTreeObj("tree"),
			isParent = e.data.isParent,
			nodes = zTree.getSelectedNodes(),
			treeNode = nodes[0];
			$("#nm").html("팀명");
			console.log(isParent);
			console.log(nodes);
			console.log(treeNode);
			if (treeNode) {
				$('form[name=frm] input[name=p_org_nm]').val('');
				$('form[name=frm] input[name=org_nm]').val('');
				$('form[name=frm] input[name=p_seq]').val('');
				$('form[name=frm] input[name=seq]').val('');
				if(treeNode.children==null)
					$('form[name=frm] input[name=org_ordr]').val(1);
				else		
					$('form[name=frm] input[name=org_ordr]').val(treeNode.children.length+1);
					
					$('form[name=frm] input[name=p_org_nm]').val(treeNode.name);
					$('form[name=frm]').append("<input type='hidden' name='p_seq' id='p_seq' value='"+treeNode.id+"' />");
					$('form[name=frm] input[name=section]').val('S');
					$('form[name=frm] input[name=org_nm]').focus();
				
					console.log(treeNode.name);
					console.log(treeNode.id);
					console.log($("#seq").val());
					console.log($("#section").val());
				
			} else {
				alert("상위 조직을 선택해 주세요.");
			}
		};
		
		//조직 삭제 
 function removeOrgcht(e) {
	 	var all_org_nm = $("#all_org_nm").val();
		var zTree = $.fn.zTree.getZTreeObj("tree"),
		nodes = zTree.getSelectedNodes(),
		treeNode = nodes[0];
		
		if (nodes.length == 0) {
			alert("조직을 선택해 주세요");
			return;
		}else{
			if(confirm("하위조직이 있다면 하위조직도 전부 삭제됩니다 삭제하시겠습니까?")){
				
				 $.post("/org/orgManage",{
						type: 'delt',
						seq:treeNode.id,
						p_seq:treeNode.pId,
						org_ordr:treeNode.od,
						org_nm:$("#org_nm").val(),
						all_org_nm:$("#all_org_nm").val(),
						domain:treeNode.domain,
						inventory_id:treeNode.inventoryId,
						group_id:treeNode.groupId
					},
					function(result){
						console.log("result===="+result);
						if(result > 0)
							alert("정상적으로 삭제되었습니다.");
						else
							alert("삭제가 실패되었습니다.");
						
						var callbackFlag = $("#callbackTrigger").attr("checked");
						zTree.removeNode(treeNode, callbackFlag);
						location.reload();
				}); 
			}
		}
	};
 
//등록 처리결과(공통명 : 프로그램명Json )
function fnSave(){
	
	var button = document.getElementById('btnSave');
	if($("#org_nm").val()==""){
		alert("조직명을 입력해주세요.");
		return false;
	}
	
	var regExp = /[\{\}\[\]\?.,;:|\*~`!^\-<>@\#/_+()$%&\\\=\'\"]/gi;
	 
	if(regExp.test($("#org_nm").val())){
		//특수문자 존재
		alert("조직명에 특수문자는 사용하실수 없습니다.");
		return false;
	}
	
	if($("#seq").val() == null){
		console.log("등록");
	}else{
		console.log("수정");
		console.log("p_seq===="+$('form[name=frm] input[name=p_seq]').val());
	}
	var all_org_nm = $("#all_org_nm").val();
	var org_nm = all_org_nm.split("|");
    $('form[name=frm]').append("<input type='hidden' name='type' value='save' />");
				button.disabled	= true;
    $.ajax({
		url: '/org/orgManage',							// Any URL
		type: 'post',
		data: $('#frm').serialize(),                 // Serialize the form data
		success: function (data) { 					// If 200 OK
			alert("등록되었습니다.");
			button.disabled	= true;
			location.reload();
		},
		error: function (xhr, text, error) {              // If 40x or 50x; errors
			alert("등록되지 않았습니다.");
			return false;
		}
	});
}

</script>

<section class="scrollable">
	<section class="hbox stretch">
		<!-- body left Start  -->
		<%@ include file="../template/orgTree.jsp" %>
		<!-- body left End  -->


		<!-- body right -->
		<aside class="bg-white">
			<section class="vbox">
				<section class="scrollable">
					<div class="wrapper"> 

						<section class="panel">

							<div class="col-sm-12">
								

									<section class="panel panel-default">
										<header class="panel-heading font-bold">조직정보</header>
										<div class="panel-body" >
											<!-- <form role="form"> -->
											<form name="frm" id="frm" method="post" action="orgManage.do" class="row">
													<input type="hidden" name="p_seq" id="p_seq" value="" />
													<input type="hidden" name="seq" id="seq" value="" />
													<input type="hidden" name="section" id="section" value="" />
													<input type="hidden" name="all_org_nm" id="all_org_nm" value="" />
													<input type="hidden" name="inventory_id" id="inventory_id" value="" />
													<input type="hidden" name="group_id" id="group_id" value="" />
												<div class="form-group">
													<label>상위조직</label>
													<input type="text" class="form-control" name="p_org_nm" id="p_org_nm"  placeholder="Enter email">
												</div>
												<div class="form-group">
													<label>순서</label>
													<input type="text" class="form-control" name="org_ordr" id="org_ordr"  placeholder="Password">
												</div>
												<div class="form-group">
													<label id="nm">팀명</label>
													<input type="text" class="form-control"  name="org_nm" id="org_nm"  placeholder="Password">
												</div>
											</form>
											<!-- <button type="submit" class="btn btn-sm btn-default">Submit</button> -->
										</div>
									</section>
								<!-- </form> -->

							</div>

							
							

						</section>
						<section class="panel clearfix bg-info lter" style="background-color: #ebefef;">
							<div class="panel-body" >
							 
								<div class="">
						
									<!-- <a href="#" class="btn btn-xs btn-success m-t-xs">Follow</a> -->
									<button type="reset" class="btn btn-sm btn-default" id="btnInit">초기화</button>
								<button type="button" class="btn btn-sm btn-default" id="btnSave">저장</button>
								</div>
							</div>
						</section>
					</div>
				</section>
			</section>
		</aside>


	</section>
</section>




<%@ include file="../template/footer.jsp" %>