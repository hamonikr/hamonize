<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/template/tui-grid.css" />
<link rel="stylesheet" type="text/css" href="/css/template/tui-pagination.css" />
<link rel='stylesheet' type='text/css' href='/css/template/tui-chart.css'/>
<link rel="stylesheet" type="text/css" href="/css/ztree/zTreeStyle.css" />
<script type="text/javascript" src="/js/ztree/jquery.ztree.core.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.exedit.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.excheck.js"></script>
<script src="/js/views/userLog.js"></script>

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
			/* check: {
				enable: true
			}, */
			edit: {
				drag: {
					/* autoExpandTrigger: true,
					prev: dropPrev,
					inner: dropInner,
					next: dropNext */
				}, 
				enable: true,
				showRemoveBtn: false,
				showRenameBtn: false
			},
			callback: {
				//beforeDrag: beforeDrag,
				//beforeDrop: beforeDrop,
				//beforeDragOpen: beforeDragOpen,
				//onDrag: onDrag,
				//onDrop: onDrop,
				//onExpand: onExpand,
				beforeClick: beforeClick,
				onClick: onClick
			}
		};
	var zNodes =[
		<c:forEach items="${oList}" var="data" varStatus="status" >
		{ id:"${data.seq}", pId:"${data.p_seq}",
			<c:if test="${data.section ne 'S'}">
			name:"${data.org_nm}"
				</c:if>
			<c:if test="${data.section eq 'S'}">
			name:"[B]"+"${data.org_nm}"
				</c:if>
			,od:"${data.org_ordr}"
			,open:true},
		</c:forEach>				
	];
	
	$(document).ready(function(){
		setNav('모니터링');
	//트리 init
	$.fn.zTree.init($("#tree"), setting, zNodes); 
	
	$("#expandAllBtn").bind("click", {type:"expandAll"}, expandNode);
	$("#collapseAllBtn").bind("click", {type:"collapseAll"}, expandNode);
			
	
});
	var log, className = "dark", curDragNodes, autoExpandNode;
	function setTrigger() {
		var zTree = $.fn.zTree.getZTreeObj("tree");
		zTree.setting.edit.drag.autoExpandTrigger = $("#callbackTrigger").attr("checked");
	}
	function beforeClick(treeId, treeNode, clickFlag) {
		className = (className === "dark" ? "":"dark");
		return (treeNode.click != false);
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
			$('#pageGrideInPcMngrListTb').empty();
			var zTree = $.fn.zTree.getZTreeObj("tree");
			var node = zTree.getNodeByParam('id', treeNode.pId);
			$("#org_seq").val(treeNode.id);
			$.post("pcMngrList.proc",{org_seq:treeNode.id,pcMngrListCurrentPage:$("#pcMngrListCurrentPage").val()},
					function(data){
				var gbInnerHtml = "";
				var classGroupList = data.list;
				
				if( data.list.length > 0 ){
					$.each(data.list, function(index, value) {
						var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);

						gbInnerHtml += "<tr data-code='" + value.sgb_seq + "' data-guidcode='" + value.sgb_pc_guid + "'>";
						gbInnerHtml += "<td style='text-align:center;'>"+no+"</td>";
						gbInnerHtml += "<td>"+value.sgb_pc_hostname+"</td>";
						gbInnerHtml += "<td>"+value.sgb_pc_ip+"</td>";
						gbInnerHtml += "<td>"+value.sgb_pc_macaddress+"</td>"; 
						gbInnerHtml += "<td>"+value.sgb_pc_disk+"</td>"; 
						gbInnerHtml += "<td>"+value.sgb_pc_cpu+"</td>"; 
						gbInnerHtml += "<td>"+value.sgb_pc_memory+"</td>"; 
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
				
				console.log(startPage);
				console.log(endPage);
				console.log(totalPageSize);
				console.log(currentPage);
				console.log(totalRecordSize);
				
				var viewName='classMngrList';
				if(totalRecordSize > 0){
					$("#pagginationInPcMngrList").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
				}else{
					$("#pagginationInPcMngrList").empty();
				}
				$('#pageGrideInPcMngrListTb').append(gbInnerHtml);
				
			});

		}
//]]>
</script>

<body>
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	<aside class="lnb">
				<div class="search-container">
		<div class="row form-check-inline">
		  	<a class="btn bg-success btn-md" style="color: white;" id="checkBtn"><i class="fa fa-check" aria-hidden="true"></i> 전체선택</a>     &nbsp;
			<a class="btn btn-md bg-dark" style="color: white;" id="uncheckBtn"><i class="fa fa-check" aria-hidden="true" ></i> 개별선택</a>
		</div>
	</div>
	
	<div class="code-html" style="padding: 0">
		<!-- tree -->
	    <ul id="tree" class="ztree"></ul>
	</div>
		</aside>
	<!-- content body -->
	<section class="body">
		<article>
		
			<div class="code-html contents">
				<!-- <p id="contentTitle">로딩중..</p>
				<hr/> -->
						
				<div id="grid"></div>
		    </div>
		</article>
	</section>
	
	<%@ include file="../template/grid.jsp" %>
	<%@ include file="../template/footer.jsp" %>	
	
	<script type="text/javascript" class="code-js">
	var gridData = [];
	var total = 1300000; // template/grid 에서도 사용

	for(var i=0;i<total;++i){
		/* dummy data - 하단의 컬럼에 따라 변수명을 지정하면 해당 값을 대입하여 그리드를 작성 */
		gridData.push({
				group_orgcode: '1-1-1중대', 
				number: ('060102-3004181'), 
				solderRank: '이등병',
				name: '홍길동',
				solderId: 'Gildong-Hong', 
				login_dt: '2019-04-26 11:53:47', 
				logout_dt: '2019-04-26 13:32:51'}
		);
	}
	
	
	var grid = new tui.Grid({
	    el: $('#grid'),
	    scrollX: false,
	    scrollY: false,
	    minBodyHeight: 30,
	    rowHeaders: ['rowNum'],
	    pagination: true,
	    columns: [
	    	{
	            title: '소속부문',
	            name: 'group_orgcode'
	        },
	    	{
	            title: '군번',
	            name: 'number'
	        },
	        {
	            title: '계급',
	            name: 'solderRank'
	        },
	        {
	            title: '이름',
	            name: 'name'
	        },
	        {
	            title: '아이디',
	            name: 'solderId'
	        },
	        {
	            title: '접속일시',
	            name: 'login_dt'
	        },
	        {
	            title: '종료일시',
	            name: 'logout_dt'
	        }
	    ]
	});
	grid.use('Net', {
	    perPage: 18,
	    readDataMethod: 'GET',
	    api: {
	        readData: 'api/readData'
	    }
	});
	</script>
</body>
</html>