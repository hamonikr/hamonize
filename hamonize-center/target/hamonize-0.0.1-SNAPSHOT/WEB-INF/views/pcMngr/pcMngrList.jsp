<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>

<!-- <link rel="stylesheet" type="text/css" href="/css/notice/notice.css" /> -->
<link rel="stylesheet" type="text/css" href="/css/template/bootstrap4.css" />

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script type="text/javascript" src="/js/common.js"></script>


<!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script> -->
<link rel="stylesheet" href="/css/materialize.css">
<script src="/js/materialize.js"></script>


<script type="text/javascript">
	var data = <%= request.getAttribute("gList") %>;
	
	$(document).ready(function(){
		
		// 그룹 클릭
		$('.groupLabel').on('click', function(){
			group_label_fnt(this);
		});
		

		$('#tree .groupLabel').eq(0).trigger('click');
		
	});
	
	function group_label_fnt(doc){
		var $lavel = $(doc).parent('div').parent('li').find('.groupLabel');
		var $defaultStep = $(doc).data("value");
		var formText = '';
		
		// 초기화
		$('#insert').css('display', 'block');
		$('#groupForm').empty();
		
		formText += mk_form_text($lavel[0], $($lavel[0]).data("value"), $defaultStep);
	
		$('#groupForm').html(formText);
		
		getPcMngrList();
	}
	
	//입력폼 생성 - 텍스트
	function mk_form_text(doc, step, defaultStep){
		var formText;
		formText = '<div id="gbcdval" data-value="' + step + '" data-upcode="' + $(doc).data("upcode") + '" data-code="' + $(doc).data("code") + '" data-orgseq="' + $(doc).data("orgseq") + '" class="addForm input-group mb-3 formBase">';
		formText += '<input type="text" name="selectOrgName" id="selectOrgName" placeholder="부대명" class="form-control" value="' + $(doc).text() + '"   >';
		formText += '</div>';
		return formText;
	}
</script>


<body>
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	<%@ include file="../template/groupMenu.jsp" %>
	
	<!-- content body -->
	<section class="body">
		<article>
			<div class="code-html contents">
			
				<div id="groupForm" style="width: 50%;"></div>
				<hr/>
				
				<div class="table-responsive" id="grid">
					<table data-toggle="table" id="dataTable" width="100%" cellspacing="0" border=0 class="table table-striped table-bordered" >
						<thead>
						<tr class="filters">
							<th><input type="text" class="form-control" placeholder="번호" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="Host Name" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="IP" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="MacAddress" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="HDD" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="CPU" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="Memory" disabled></th>
	                        <!-- <th><input type="text" class="form-control" placeholder="비고" disabled></th> -->
	                    </tr>
		        		</thead>
						<tbody id="pageGrideInPcMngrListTb">
							<input type="hidden" id="pcMngrListCurrentPage" name="pcMngrListCurrentPage" value="1" class="form-control" >
						</tbody>
					</table>
				</div>
				
				<!-- 페이징 -->
				<ul class="pagination" id="pagginationInPcMngrList"></ul>
				
				
		    </div>
		    </div>
		</article>
	</section>
	
	

<script type="text/javascript">


$(document).ready(function() {
	
	// 찾기
	$('#dateSearchBtn').click(function() {
		getList();
	});
	
	var getKeyWord = "${mngeVo.keyWord}";
	if(getKeyWord.length == 0){ 
		$("#keyWord option:eq(1)").prop("selected", true);		
	}else{
		$("#keyWordID").val(getKeyWord).attr("selected", true);
	} 
	
	$("#txtSearch").keydown(function(key) {
		if (key.keyCode == 13) {
			key.preventDefault();
			getList();
		}
	});
	
});



/*
 * 이전 페이지
 */
function prevPage(viewName, currentPage){
	var page = eval(currentPage) - 1;

		if(page < 1){
			page = 1;
		}
	searchView(viewName, page);
}

/*
 * 다음 페이지
 */
function nextPage(viewName, currentPage, totalPageSize){
	var page = eval(currentPage) + 1;
	var totalPageSize = eval(totalPageSize);

	if(page > totalPageSize){
		page = totalPageSize;
	}
	searchView(viewName, page);
}


function searchView(viewName, page){
	switch(viewName){
		case 'classMngrList' : $("#pcMngrListCurrentPage").val(page); getList(); break;	//	공지사항
	default :
	}
}

// update & view
/* $('#pageGrideInMngrListTb').on('click','tr',function(){
	var $form = $('<form></form>').attr('action','/notice/noticeDetail.acnt').attr('method','POST');
	var $ipt = $('<input type="text" name="noti_seq"></input').val($(this).data('code'));
	$form.append($ipt).appendTo('form').submit();
}); */


function getPcMngrList(){
	var url ='/pcMngr/pcMngrList.proc';
	
	var keyWord = $("select[name=keyWord]").val();
	var vData = 'pcMngrListCurrentPage=' + $("#pcMngrListCurrentPage").val() +"&keyWord="+ keyWord + "&txtSearch=" + $("#txtSearch").val()+ "&selectOrgSeq=" + $("#gbcdval").attr("data-orgseq") ; 
	callAjax('POST', url, vData, userpcMngrGetSuccess, getError, 'json');
}

</script>
		
</body>
</html>