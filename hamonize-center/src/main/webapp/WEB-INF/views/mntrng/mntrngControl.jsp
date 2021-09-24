<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/template/tui-grid.css" />
<link rel="stylesheet" type="text/css" href="/css/template/tui-pagination.css" />
<link rel="stylesheet" type="text/css" href="/css/tdemo.css" />
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script type="text/javascript" src="/js/common.js"></script>

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
	
	getMntrngList();
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
				<section class="row">
					<h1 class="col-md-8" id="groupForm" style="width: 50%; margin: 0;"></h1>
				  	<div class="col-md-4" role="group">
				    	<p class="float-right">
				      		<a class="btn bg-success btn-md" style="color: white;"><i class="fa fa-plus" aria-hidden="true"></i> 정상</a>
				      		<a class="btn btn-md bg-dark" style="color: white;"><i class="fa fa-flag" aria-hidden="true" ></i> OFF</a>
				    	</p>
				  	</div>
				</section>

				
				<div id="mntrngList" class="row"></div>
		    </div>
		</article>
	</section>
	
<script type="text/javascript">

$(document).ready(function() {
	
	
});

function getMntrngList(){
	var url ='/mntrng/pcControl.proc';
	
	var keyWord = $("select[name=keyWord]").val();
	var vData = 'mntrngListCurrentPage=' + $("#mntrngListCurrentPage").val() +"&keyWord="+ keyWord + "&txtSearch=" + $("#txtSearch").val() + "&org_seq=" + $("#gbcdval").attr("data-orgseq");
	callAjax('POST', url, vData, pcMngrGetSuccess, getError, 'json');
}
</script>	
</body>
</html>