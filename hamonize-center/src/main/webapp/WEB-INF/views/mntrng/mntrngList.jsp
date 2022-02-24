<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>


<script type="text/javascript" src="/js/ztree/jquery.ztree.exhide.js"></script>
<script>

// $.fn.zTree.getZTreeObj("tree").getNodes()[0].checked = true;

function beforeClick(treeId, treeNode, clickFlag) {
	className = (className === "dark" ? "":"dark");
	return (treeNode.click != false);
}
function onCheck(event, treeId, treeNode) {
}

//메뉴 Tree onClick
function onClick(event, treeId, treeNode, clickFlag) {


	$('.monitor_list').empty();
	$('#total').empty();
	$('#on').empty();
	$('#off').empty();
	var zTree = $.fn.zTree.getZTreeObj("tree");
	var node = zTree.getNodeByParam('id', treeNode.pId);
	$.post("/mntrng/pcList",{org_seq:treeNode.id},
	function(result){
			var agrs = result.pcList;
			var strHtml ="";
			
			if(agrs.length > 0){
				for(var i =0; i< agrs.length;i++){
					var uuid = agrs[i].pc_uuid;
					var hostnameVal = '';
					if( agrs[i].pc_hostname.length >= textCutLength ){
						hostnameVal = agrs[i].pc_hostname.substr(0,textCutLength)+'...'; 
				   }else{
					   hostnameVal = agrs[i].pc_hostname; 
					}
				 
					if( agrs[i].pc_status == "true"){
						strHtml += '<div class="panel-body col-lg-3 "><blockquote class="bodyDataLayer mntrngBox">'; 
						strHtml += '<span class="fa-stack pull-left m-r-sm"> <i class="fa fa-play"></i> </span>';
						strHtml += hostnameVal;
						strHtml += '</blockquote></div>';
					}else{


						strHtml += '<div class="panel-body col-lg-3 "><blockquote class="bodyDataLayer mntrngBox">';
						strHtml += '<span class="fa-stack pull-left m-r-sm"> <i class="fa fa-pause"></i> </span>';
						strHtml += hostnameVal;
						strHtml += '</blockquote></div>';
						
					}
				}
			}else{
				strHtml += "<div class=\"mr-sm-3\">등록된 pc가 없습니다</div>";
			}
			$(".monitor_list").append(strHtml);
// 			$("#total").append("<font class=\"total\">●</font>TOTAL - "+(parseInt(result.on)+parseInt(result.off))+"대");
			$("#on").append("<span class=\"fa-stack pull-left m-r-sm\"> <i class=\"fa fa-play fa-2xs\"></i> </span>ON - "+result.on+"대");
			$("#off").append("<span class=\"fa-stack pull-left m-r-sm\"> <i class=\"fa fa-pause\"></i> </span>OFF - "+result.off+"대");

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
				<section class="scrollable padder">
<!-- 					<div class="wrapper"> -->


						<section class="panel panel-default">

<!-- 							<div class="col-sm-12"> -->


<!-- 								<section class="panel panel-default"> -->

									<header class="panel-heading bg-light">
										<ul class="nav nav-tabs pull-right ">
<!-- 											<li><a href="#" id="total">total</a></li> -->
											<li><a href="#" id="on" class="mntrngTitle"></a></li>
											<li><a href="#" id="off" class="mntrngTitle"></a></li>
										</ul>
										<span class="hidden-sm"># 모니터링 </span> 
									</header>

									<div class="panel-body">
										<!-- <form role="form"> -->
										<form name="frm" method="post" action="orgManage" class="row">
											<input type="hidden" name="org_seq" id="org_seq" value="" />
											<input type="hidden" name="ppm_seq" id="ppm_seq" value="" />
											<input type="hidden" name="section" id="section" value="" />
											<!-- <div class="monitor_list"></div> -->

											<div class="row m-l-none m-r-none bg-light lter monitor_list">
												
											</div>

										</form>


									</div>
<!-- 								</section> -->

<!-- 							</div> -->

						</section>
						
<!-- 					</div> -->
				</section>
			</section>
		</aside>


	</section>
</section>



<script>
	$(function () {
		$('[data-toggle="tooltip"]').tooltip({
			html: true,
			trigger: 'hover focus'
		});
	});
</script>



<script type="text/javascript">
	var textCutLength = 20;

	$(document).ready(function () {

		$("#expandAllBtn").bind("click", {
			type: "expandAll"
		}, expandNode);
		$("#collapseAllBtn").bind("click", {
			type: "collapseAll"
		}, expandNode);

		fuzzySearch('tree', '#key', null, true); //initialize fuzzysearch function

		//getMntrngList();

	});

	function getMntrngList() {

		var url = '/mntrng/pcList';
		$.post(url, {
				org_seq: 1
			},
			function (result) {
				var agrs = result.pcList;
				var mntrngStrHtml = "";

				for (var i = 0; i < agrs.length; i++) {
					var uuid = agrs[i].pc_uuid,
						hostnameVal = '';

					if (agrs[i].pc_hostname.length >= textCutLength) {
						hostnameVal = agrs[i].pc_hostname.substr(0, textCutLength) + '...';
					} else {
						hostnameVal = agrs[i].pc_hostname;
					}
					if (agrs[i].pc_status == "true") {
						// mntrngStrHtml += '<li class="on"><a href="pcView?uuid=' + uuid +'" data-toggle="tooltip" title="' +agrs[i].pc_hostname + '">' + hostnameVal + '</a></li>'

						mntrngStrHtml += '<div class="col-sm-2 col-md-3 padder-v b-r b-light lt">';
						mntrngStrHtml += '<span class="fa-stack fa-2x pull-left m-r-sm"> <i class="fa fa-circle fa-stack-2x text-warning"></i> </span>';
						mntrngStrHtml += '<a class="clear" href="/mntrng/pcView?uuid=' + uuid +'">';
						mntrngStrHtml += '<span class="h3 block m-t-xs"><strong id="bugs">'+hostnameVal+'</strong></span>';
						mntrngStrHtml += '<small class="text-muted text-uc">description</small>';
						mntrngStrHtml += '</a>';
						mntrngStrHtml += '</div>';

					} else {
						// mntrngStrHtml += '<li><div data-toggle="tooltip" data-placement="top" title="' + agrs[i].pc_hostname + '">' + hostnameVal + '</div></li>'

						mntrngStrHtml += '<div class="col-sm-2 col-md-3 padder-v b-r b-light lt">';
						mntrngStrHtml += '<span class="fa-stack fa-2x pull-left m-r-sm"> <i class="fa fa-circle fa-stack-2x text-dark"></i> </span>';
						mntrngStrHtml += '<span class="h3 block m-t-xs"><strong id="bugs">'+hostnameVal+'</strong></span>';
						mntrngStrHtml += '<small class="text-muted text-uc">description</small>';
						mntrngStrHtml += '</div>';

					}


					


				}
				console.log(mntrngStrHtml);
				$(".monitor_list").append(mntrngStrHtml);
				$("#total").append("<font class=\"total\"></font>- " + (parseInt(result.on) + parseInt(result.off)) +
					"대");
				$("#on").append("<font class=\"on\"></font>- " + result.on + "대");
				$("#off").append("<font class=\"off\"></font> - " + result.off + "대");
			});

	}

	var log, className = "dark",
		curDragNodes, autoExpandNode;




	//]]>
</script>


<%@ include file="../template/footer.jsp" %>