<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>


<script>

//메뉴 Tree onClick
function onClick(event, treeId, treeNode, clickFlag) {

	var zTree = $.fn.zTree.getZTreeObj("tree");
	var node = zTree.getNodeByParam('id', treeNode.pId);
	var pSpan = "#"+treeNode.parentTId+"_span";
	$.post("/org/orgManage",{type:'show',seq:treeNode.id,domain:treeNode.domain},
	function(result){
		var agrs = result;
		console.log(agrs);
		if(agrs.section == "S"){
			
			$("#trOrg_num").remove();
			$("#trPseq").remove();
			$('#nm').html("팀명");
		
			var shtml = "<tr id=\"trPseq\"><th>상위 부서번호</th> <td><input type=\"text\" name=\"p_seq\" id=\"p_seq\" class=\"input_type1 w100\" readonly /></td></tr>";
			$(".board_view tbody").append(shtml);
		}else{
			$('#nm').html("부서명");
			$("#trOrg_num").remove();
			$("#trPseq").remove();
				
			var shtml = "<tr id=\"trPseq\"><th>상위 부서번호</th> <td><input type=\"text\" name=\"p_seq\" id=\"p_seq\" class=\"input_type1 w100\" /></td></tr>";
			
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
													<input type="hidden" name="seq" id="seq" value="" />
													<input type="hidden" name="section" id="section" value="" />
													<input type="hidden" name="all_org_nm" id="all_org_nm" value="" />
												<div class="form-group">
													<label>상위부서</label>
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