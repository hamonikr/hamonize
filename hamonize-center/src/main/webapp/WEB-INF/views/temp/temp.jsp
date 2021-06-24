<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/template/tui-grid.css" />
<link rel="stylesheet" type="text/css" href="/css/template/tui-pagination.css" />

<link href="https://gitcdn.github.io/bootstrap-toggle/2.2.2/css/bootstrap-toggle.min.css" rel="stylesheet">
<script src="https://gitcdn.github.io/bootstrap-toggle/2.2.2/js/bootstrap-toggle.min.js"></script>
<script>

$(".colors span").click(function(){
	  color = $(this).attr("class");
	  $(".demo .minitoggle").removeAttr("class").addClass('minitoggle' + ' ' + color);
	});
	
</script>
<style>
/* The switch - the box around the slider */
.switch {
  position: relative;
  display: inline-block;
  width: 60px;
  height: 34px;
  vertical-align:middle;
}
 
/* Hide default HTML checkbox */
.switch input {display:none;}
 
/* The slider */
.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  -webkit-transition: .4s;
  transition: .4s;
}
 
.slider:before {
  position: absolute;
  content: "";
  height: 26px;
  width: 26px;
  left: 4px;
  bottom: 4px;
  background-color: white;
  -webkit-transition: .4s;
  transition: .4s;
}
 
input:checked + .slider {
  background-color: #2196F3;
}
 
input:focus + .slider {
  box-shadow: 0 0 1px #2196F3;
}
 
input:checked + .slider:before {
  -webkit-transform: translateX(26px);
  -ms-transform: translateX(26px);
  transform: translateX(26px);
}
 
/* Rounded sliders */
.slider.round {
  border-radius: 34px;
}
 
.slider.round:before {
  border-radius: 50%;
}
 
p {
  margin:0px;
  display:inline-block;
  font-size:15px;
  font-weight:bold;
}

</style>
<link href="/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<body>
	<%@ include file="../template/topMenu.jsp" %>
	<div class="contents">
		<div class="component-header">
			<div class="content-container">
				<h2 class="component-title">
					<span class="icon chart"></span>
					<span class="title">정책관리</span>
				</h2>
			
			</div>
		</div>
	</div>
	
	<!-- content body -->
	<section class="body" style="padding-left: 100px;">
			
				
				
<label class="switch">
  <input type="checkbox">
  <span class="slider round"></span>
</label>
<p>OFF</p><p style="display:none;">ON</p>
				
<script>
var check = $("input[type='checkbox']");
check.click(function(){
  $("p").toggle();
});

</script>
		
		
		

<select class="custom-select custom-select-sm">
  <option selected>Open this select menu</option>
  <option value="1">One</option>
  <option value="2">Two</option>
  <option value="3">Three</option>
</select>
				
				
				
				
<input type="checkbox" checked data-toggle="toggle">
				
				



		</article>
	</section>
	
	
 	
	
</body>
</html>