<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/template/tui-grid.css" />
<link rel="stylesheet" type="text/css" href="/css/template/tui-pagination.css" />

 
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">

<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>


<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.3/jquery.timepicker.min.css">
<script src="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.3/jquery.timepicker.min.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.8.0/css/bootstrap-datepicker.css" />
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.8.0/js/bootstrap-datepicker.js"></script>
 


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
		

<form>
  <div class="form-group">
    <label for="exampleInputEmail1">백업을 원하시는 주기를 설정하세요.</label>
    <select class="custom-select custom-select-sm" id="select_id">
	  <option value="2">매일/매주</option>
	  <option value="3">매월</option>
	</select>
  </div>
  
  
  <div id="week" style="display:block">
  
  <div class="form-check form-check-inline">
	  <input class="form-check-input" type="checkbox" id="inlineCheckbox1" value="option1">
	  <label class="form-check-label" for="inlineCheckbox1">일</label>
	</div>
	<div class="form-check form-check-inline">
	  <input class="form-check-input" type="checkbox" id="inlineCheckbox2" value="option2">
	  <label class="form-check-label" for="inlineCheckbox2">월</label>
	</div>
	<div class="form-check form-check-inline">
	  <input class="form-check-input" type="checkbox" id="inlineCheckbox1" value="option1">
	  <label class="form-check-label" for="inlineCheckbox1">화</label>
	</div>
	<div class="form-check form-check-inline">
	  <input class="form-check-input" type="checkbox" id="inlineCheckbox2" value="option2">
	  <label class="form-check-label" for="inlineCheckbox2">수</label>
	</div>
	<div class="form-check form-check-inline">
	  <input class="form-check-input" type="checkbox" id="inlineCheckbox1" value="option1">
	  <label class="form-check-label" for="inlineCheckbox1">목</label>
	</div>
	<div class="form-check form-check-inline">
	  <input class="form-check-input" type="checkbox" id="inlineCheckbox2" value="option2">
	  <label class="form-check-label" for="inlineCheckbox2">금</label>
	</div>
	<div class="form-check form-check-inline">
	  <input class="form-check-input" type="checkbox" id="inlineCheckbox1" value="option1">
	  <label class="form-check-label" for="inlineCheckbox1">토</label>
	</div>
	
 
  
  
  </div>
  <div id="month" style="display:block">
  
		<p id="basicExample">
		    <input type="text" class="date start" />
		</p>
		
		
  </div>
	
  	<div class="form-group">
	    <div class="container text-center">
		     <strong>Select Time:</strong> <input type="text" id="timepickerqq" class="from-control">
		</div>
  </div>	  
  
  
  <button type="submit" class="btn btn-primary">Submit</button>
  
  
</form>
				
	</section>
	
	
	
<script type="text/javascript">
    $( "#timepickerqq" ).timepicker();
     
     $(document).ready(function(){
    	 $('#week').show();  
    	 $('#month').hide();  
    });   
    
    
    $("#select_id").on("change", function(){
    	 if( $(this).val() == "2" ){
    		$('#daily').hide();
    		$('#week').show();
       	 	$('#month').hide()
    	}else if( $(this).val() == "3" ){
    		$('#daily').hide();  
       	 	$('#week').hide();
    		$('#month').show();
    	}
    });
    
    $('#basicExample .date').datepicker({
        'format': 'yyyy/d/m',
        'autoclose': true
    });

    // initialize datepair
    var basicExampleEl = document.getElementById('basicExample');
    var datepair = new Datepair(basicExampleEl);
</script>


</body>
</html>