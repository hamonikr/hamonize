<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>

<script src="/js/sgb/wow.min.js"></script>
<script src="/js/adapter.js"></script>
<!-- OpenLayers 3 & Proj4js -->
        <link rel="stylesheet" type="text/css" href="javascript/ol.css" />
        <link rel="stylesheet" type="text/css" href="javascript/ol3-layerswitcher.css" />
        <script type="text/javascript" src="javascript/ol-debug.js"></script>
<style>
.ol-mouse-position {display:none;}
.ol-zoom  {display:none;}
.ol-zoom-extent {display:none;}
.ol-attribution {display:none;}
.tooltip {position:relative; padding: 3px 7px; background:rgba(0, 0, 0, 0.6); color:#fff; font-size:13px; font-weight: 600; text-align:center; height:25px; border-radius:3px} 
.tooltip:after {position:absolute; top:21px; left: 15px; content: '▼' ;  color:#000; opacity:0.7; font-size:9px }
#tooltip2:after {position:absolute; top:-16px; left: 4px; content: '▲' ;  color:#000; opacity:0.7; font-size:9px }
#tooltip4 {left: 17px;}
#tooltip4:after {position:absolute; top:21px; left: 70px; content: '▼' ;  color:#000; opacity:0.7; font-size:9px }
#tooltip8:after {position:absolute; top:-16px; left: 75px; content: '▲' ;  color:#000; opacity:0.7; font-size:9px }
#tooltip11 {left: 17px;}
#tooltip11:after {position:absolute; top:-16px; left: 65px; content: '▲' ;  color:#000; opacity:0.7; font-size:9px }
#tooltip13:after {position:absolute; top:-16px; left: 15px; content: '▲' ;  color:#000; opacity:0.7; font-size:9px }
#tooltip15:after {position:absolute; top:-16px; left: 25px; content: '▲' ;  color:#000; opacity:0.7; font-size:9px }
#tooltip17 {left: 28px;}
#tooltip17:after {position:absolute; top:21px; left: 69px; content: '▼' ;  color:#000; opacity:0.7; font-size:9px }


</style>
<script>

$(document).ready(function(){

});

	new WOW().init();
</script>
<body>
	<%@ include file="../template/topMenu.jsp" %>

    <div class="hamo_container">
        <div class="main_box">
            <!--- 좌측 -->
            <div class="main_left">
                <div class="graph mT50" style="margin-top: 0px;">                    
					<div id="map" class="map" style="height:915px; font-size: 12px;"></div>
                    <div id="tooltip"  class="tooltip"></div>
 						<div id="tooltip2" class="tooltip"></div>
 						<div id="tooltip3" class="tooltip"></div>
 						<div id="tooltip4" class="tooltip"></div>
 						<div id="tooltip5" class="tooltip"></div>
 						<div id="tooltip6" class="tooltip"></div>
 						<div id="tooltip7" class="tooltip"></div>
 						<div id="tooltip8" class="tooltip"></div>
 						<div id="tooltip9" class="tooltip"></div>
 						<div id="tooltip10" class="tooltip"></div>
 						<div id="tooltip11" class="tooltip"></div>
 						<div id="tooltip12" class="tooltip"></div>
 						<div id="tooltip13" class="tooltip"></div>
 						<div id="tooltip14" class="tooltip"></div>
 						<div id="tooltip15" class="tooltip"></div>
 						<div id="tooltip16" class="tooltip"></div>
 						<div id="tooltip17" class="tooltip"></div>
                </div>
            </div>
            
            <!--- //좌측 -->

            <!--- 우측 -->
            <div class="main_right">
            <div class="main_title">
                    	PC운영현황
                    <span></span>
                </div>
            <ul class="cyberinfo">
                    <li><span>구분</span></li>
                    <li><span>합계</span></li>
                    <li><span>사용 현황</span></li>
                    <li><span>미사용 현황</span></li>
                </ul>
                <!-- 기술지원 현황 -->
                <%-- <div class="main_title">장애처리현황</div>
                <ul style="margin-top: 20px;margin-bottom: 20px;">
                    <li>
                        <div class="board_list_1 mT20">
                            <table id="tchnlgyCount">
                                <colgroup>
                                    <col style="width:25%;" />
                                    <col style="width:25%;" />
                                    <col style="width:25%;" />
                                    <col />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th style='text-align: center'>총등록</th>
                                        <th style='text-align: center'>진행중</th>
                                        <th style='text-align: center'>답변완료</th>
                                    </tr>
                                </thead>
                                <tbody id = "tchnlgyCountBody">                                    
                                </tbody>
                            </table>
                        </div>
				<!-- //List -->
                    </li>
                </ul> --%>
                <!-- 접속현황 -->
                <div class="main_title">접속현황(전국)</div>
                <ul class="col2">
                    <li>
                        <div class="board_list_1 mT20">
                            <table id="sido1">
                                <colgroup>
                                    <col style="width:50%;" />
                                    <col />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>지역</th>
                                        <th class="t_right">사용현황</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>서울특별시</td>
                                        <td class="t_right">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>부산광역시</td>
                                        <td class="t_right">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>대구광역시</td>
                                        <td class="t_right">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>인천광역시</td>
                                        <td class="t_right">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>광주광역시</td>
                                        <td class="t_right">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>대전광역시</td>
                                        <td class="t_right">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>울산광역시</td>
                                        <td class="t_right">
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div><!-- //List -->
                    </li>
                    <li id="hamain_right2">
                        <div class="board_list_2 mT20">
                            <table id="sido2">
                                <colgroup>
                                    <col style="width:50%;" />
                                    <col />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>지역</th>
                                        <th class="t_right">사용현황</th>
                                    </tr>
                                </thead>
                                <tbody>
                                	<tr>
                                        <td>경기도</td>
                                        <td class="t_right">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>강원도</td>
                                        <td class="t_right">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>충청북도</td>
                                        <td class="t_right">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>충청남도</td>
                                        <td class="t_right">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>전라북도</td>
                                        <td class="t_right">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>전라남도</td>
                                        <td class="t_right">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>경상북도</td>
                                        <td class="t_right">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>경상남도</td>
                                        <td class="t_right">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>제주특별자치도</td>
                                        <td class="t_right">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>세종특별자치시</td>
                                        <td class="t_right">
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div><!-- //List -->
                    </li>
                </ul>
                <!-- //접속현황 -->
                
                <!-- 주요접속 유해사이트 -->
                <ul class="col2" style="margin-top: 20px;">
                    <li id="hamain_left1">
                        <div class="main_title">주요접속 URL 통계(월간)</div>
                         <ul class="siteinfo">
                            <li>
                                <div class="sname con"><span>0%</span></div>
                                <div class="sbar">
                                    <div class="present rank1 wow fadeInLeft" data-wow-delay="0.5s" style="width:0%"></div>
                                </div>
                            </li>
                            <li>
                                <div class="sname con"><span>0%</span></div>
                                <div class="sbar">
                                    <div class="present rank2 wow fadeInLeft" data-wow-delay="1s" style="width:0%"></div>
                                </div>
                            </li>
                            <li>
                                <div class="sname con"><span>0%</span></div>
                                <div class="sbar">
                                    <div class="present rank3 wow fadeInLeft" data-wow-delay="1.5s" style="width:0%"></div>
                                </div>
                            </li>
                            <li>
                                <div class="sname con"> <span>0%</span></div>
                                <div class="sbar">
                                    <div class="present wow fadeInLeft" data-wow-delay="1.8s" style="width:0%"></div>
                                </div>
                            </li>
                            <li>
                                <div class="sname con"> <span>0%</span></div>
                                <div class="sbar">
                                    <div class="present wow fadeInLeft" data-wow-delay="2s" style="width:0%"></div>
                                </div>
                            </li>
                        </ul>  
                    </li>
                    <li id="hamain_right1">
                        <div class="main_title">유해사이트 차단현황(월간)</div>
                         <ul class="siteinfo">
                            <li>
                                <div class="sname ill"> <span>0%</span></div>
                                <div class="sbar">
                                    <div class="present rank1 wow fadeInLeft" data-wow-delay="0.5s" style="width:0%"></div>
                                </div>
                            </li>
                            <li>
                                <div class="sname ill"> <span>0%</span></div>
                                <div class="sbar">
                                    <div class="present rank2 wow fadeInLeft" data-wow-delay="1s" style="width:0%"></div>
                                </div>
                            </li>
                            <li>
                                <div class="sname ill"> <span>0%</span></div>
                                <div class="sbar">
                                    <div class="present rank3 wow fadeInLeft" data-wow-delay="1.5s" style="width:0%"></div>
                                </div>
                            </li>
                            <li>
                                <div class="sname ill"><span>0%</span></div>
                                <div class="sbar">
                                    <div class="present wow fadeInLeft" data-wow-delay="1.8s" style="width:0%"></div>
                                </div>
                            </li>
                            <li>
                                <div class="sname ill"> <span>0%</span></div>
                                <div class="sbar">
                                    <div class="present wow fadeInLeft" data-wow-delay="2s" style="width:0%"></div>
                                </div>
                            </li>
                        </ul> 
                    </li>
                </ul>
                <input type="button" class="btn_type4" id="btnClose" name="btnClose" value="닫기" style="float: right;" />
                <input type="button" class="btn_type4" id="btnMore" name="btnMore" value="더보기" style="float: right;" />  
                <!-- //주요접속 유해사이트 -->

            </div>
            <!--- //우측 -->
        </div>

    </div><!-- //content -->
	<script>
			$(document).ready(function(){
				var offset = 0;
				$(".tooltip").css("display","none");
				$.post("inetLogCount.do",{dataType:'json',offset:offset},
						function(data){
					var conList = data.conList;
					var illList = data.illList;
					console.log(data.conList);
					for(var i = 0; i < conList.length;i++){
						console.log("con"+conList[i].cnnc_url +":::"+conList[i].count);
						console.log("ill"+illList[i].cnnc_url +":::"+illList[i].count);
						$(".con").eq(i).html(conList[i].cnnc_url+"<span><a href=\"/auditLog/iNetLog?prcssname=1&txtSearch0=1&txtSearch4="+conList[i].cnnc_url+"\">"+numberWithCommas(conList[i].count)+"건</a>("+conList[i].per+"%)</span>");
						$(".fadeInLeft").eq(i).css("width",conList[i].per+"%");
						$(".ill").eq(i).html(illList[i].cnnc_url+"<span><a href=\"/auditLog/iNetLog?prcssname=1&txtSearch0=2&txtSearch4="+illList[i].cnnc_url+"\">"+numberWithCommas(illList[i].count)+"건</a>("+illList[i].per+"%)</span>");
						$("#hamain_right1 .fadeInLeft").eq(i).css("width",illList[i].per+"%");
					}
				});
				$("#btnMore").on("click",function(){
					offset += 5;
					 $.post("inetLogCount.do",{dataType:'json',offset:offset},
							function(data){
						var conList = data.conList;
						var illList = data.illList;
						for(var i = 0; i < conList.length;i++){
							var chtml = "";
							var ihtml = "";

							chtml += "<li class=\"more\">";
							chtml += "<div class=\"sname con\">"+conList[i].cnnc_url;
							chtml += "<span><a href=\"/auditLog/iNetLog?prcssname=1&txtSearch0=1&txtSearch4="+conList[i].cnnc_url+"\">"+numberWithCommas(conList[i].count)+"건</a>("+conList[i].per+"%)</span>";
							chtml += "<div class=\"sbar\">";
							chtml += "<div class=\"present wow fadeInLeft\" data-wow-delay=\"0.5s\" style=\"width:"+conList[i].per+"%\"></div>";
							chtml += "</div>";

							ihtml += "<li class=\"more\">";
							ihtml += "<div class=\"sname ill\">"+illList[i].cnnc_url;
							ihtml += "<span><a href=\"/auditLog/iNetLog?prcssname=1&txtSearch0=2&txtSearch4="+illList[i].cnnc_url+"\">"+numberWithCommas(illList[i].count)+"건</a>("+illList[i].per+"%)</span>";
							ihtml += "<div class=\"sbar\">";
							ihtml += "<div class=\"present wow fadeInLeft\" data-wow-delay=\"0.5s\" style=\"width:"+illList[i].per+"%\"></div>";
							ihtml += "</div>";
							
							$("#hamain_left1 .siteinfo").append(chtml);
							$("#hamain_right1 .siteinfo").append(ihtml);
						}
					}); 
				})
					$("#btnClose").on("click",function(){
						$(".more").remove();
						offset = 0;
						})
   
		$.post("sidoCount.do",{dataType:'json'},
				function(data){
			$(".tooltip").css("display","block");
			var SU = 0,BS = 0,DG = 0,IC = 0,GJ = 0,DJ = 0,US = 0,GG = 0,
			GW = 0,NC = 0,SC = 0,NJ = 0,SJ = 0,NG = 0,SG = 0,JJ = 0,SE = 0;
			var sum = 0;
			var SU1 = 0,BS1 = 0,DG1 = 0,IC1 = 0,GJ1 = 0,DJ1 = 0,US1 = 0,GG1 = 0,
			GW1 = 0,NC1 = 0,SC1 = 0,NJ1 = 0,SJ1 = 0,NG1 = 0,SG1 = 0,JJ1 = 0,SE1 = 0;
			var SU2 = 0,BS2 = 0,DG2 = 0,IC2 = 0,GJ2 = 0,DJ2 = 0,US2 = 0,GG2 = 0,
			GW2 = 0,NC2 = 0,SC2 = 0,NJ2 = 0,SJ2 = 0,NG2 = 0,SG2 = 0,JJ2 = 0,SE2 = 0;
			var sum1 = 0;
			var agrs = data.sidoCount;
			for(var i = 0; i < agrs.length;i++){

					if(agrs[i].sido == '서울'){
						SU = agrs[i].pc_cnt;
						SU1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '부산'){
						BS = agrs[i].pc_cnt;
						BS1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '대구'){
						DG = agrs[i].pc_cnt;
						DG1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '인천'){
						IC = agrs[i].pc_cnt;
						IC1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '광주'){
						GJ = agrs[i].pc_cnt;
						GJ1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '대전'){
						DJ = agrs[i].pc_cnt;
						DJ1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '울산'){
						US = agrs[i].pc_cnt;
						US1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '경기'){
						GG = agrs[i].pc_cnt;
						GG1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '강원'){
						GW = agrs[i].pc_cnt;
						GW1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '충북'){
						NC = agrs[i].pc_cnt;
						NC1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '충남'){
						SC = agrs[i].pc_cnt;
						SC1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '전북'){
						NJ = agrs[i].pc_cnt;
						NJ1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '전남'){
						SJ = agrs[i].pc_cnt;
						SJ1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '경북'){
						NG = agrs[i].pc_cnt;
						NG1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '경남'){
						SG = agrs[i].pc_cnt;
						SG1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '제주'){
						JJ = agrs[i].pc_cnt;
						JJ1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '세종'){
						SE = agrs[i].pc_cnt;
						SE1 = agrs[i].t_sum;
					}
			}
		sum = SU+BS+DG+IC+GJ+DJ+US+GG+GW+NC+SC+NJ+SJ+NG+SG+JJ+SE;
		sum1 = SU1+BS1+DG1+IC1+GJ1+DJ1+US1+GG1+GW1+NC1+SC1+NJ1+SJ1+NG1+SG1+JJ1+SE1;
		var total=sum;
		var on = data.useList.length;
		var off = (total - on);
		var wCount = data.wCount;
		var hCount = data.hCount;
		var tot = wCount+total;
		var totper = Math.floor((wCount/25000)*100)+Math.floor((total/25000)*100);


		$(".cyberinfo li").each(function (i,v){
			if(i==0){
				$(this).html("<span>구분</span><img src=\"/images/icon_total.png\" width=\"25\" height=\"25\">&nbsp;&nbsp;합계<br/><img src=\"/images/icon_w.png\" width=\"25\" height=\"25\">&nbsp;&nbsp;상용<br/><img src=\"/images/icon_h.png\" width=\"25\" height=\"25\">&nbsp;&nbsp;개방");
				$(this).css("color","#333");
			}
			if(i==1)
				$(this).html("<span>합계</span>"+numberWithCommas(tot)+"("+totper+"%)<br/>"+numberWithCommas(wCount)+"("+Math.floor((wCount/25000)*100)+"%)<br/>"+numberWithCommas(total)+"("+Math.floor((total/25000)*100)+"%)");
			if(i==2)
				$(this).html("<span>사용 현황</span>"+numberWithCommas(on)+"("+Math.floor((on/25000)*100)+"%)<br/>-<br/>"+numberWithCommas(on)+"("+Math.floor((on/25000)*100)+"%)");
			if(i==3)
				$(this).html("<span>미사용 현황</span>"+numberWithCommas(off)+"("+Math.floor((off/25000)*100)+"%)<br/>-<br/>"+numberWithCommas(off)+"("+Math.floor((off/25000)*100)+"%)");
			
		});
		var agrs2 = data.useList;
		 //var count = on;
	     var features = new Array(agrs2.length);

			for(var i = 0; i < agrs2.length;i++){
			
			if( agrs2[i].xpoint == null || agrs2[i].xpoint == "" || typeof agrs2[i].xpoint == "undefined"){
				console.log("aaaaaaaaaaaaaaaaaaaaa=================++++"+ JSON.stringify(agrs2[i]));
				
			}
			var x = parseFloat(agrs2[i].xpoint);
			var y = parseFloat(agrs2[i].ypoint);

			var coordinates = [x,y];

			features[i] = new ol.Feature(new ol.geom.Point(ol.proj.transform(coordinates, 'EPSG:4326', 'EPSG:3857')));

			if(agrs2[i].sido == '서울'){
				SU2++;
			}else if(agrs2[i].sido == '부산'){
				BS2++;
			}else if(agrs2[i].sido == '대구'){
				DG2++;
			}else if(agrs2[i].sido == '인천'){
				IC2++;
			}else if(agrs2[i].sido == '광주'){
				GJ2++;
			}else if(agrs2[i].sido == '대전'){
				DJ2++;
			}else if(agrs2[i].sido == '울산'){
				US2++;
			}else if(agrs2[i].sido == '경기'){
				GG2++;
			}else if(agrs2[i].sido == '강원'){
				GW2++;
			}else if(agrs2[i].sido == '충북'){
				NC2++;
			}else if(agrs2[i].sido == '충남'){
				SC2++;
			}else if(agrs2[i].sido == '전북'){
				NJ2++;
			}else if(agrs2[i].sido == '전남'){
				SJ2++;
			}else if(agrs2[i].sido == '경북'){
				NG2++;
			}else if(agrs2[i].sido == '경남'){
				SG2++;
			}else if(agrs2[i].sido == '제주'){
				JJ2++;
			}else if(agrs2[i].sido == '세종'){
				SE2++;
			}
	}


			$("#tooltip").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+SU2+" / "+SU);
			$("#tooltip2").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+BS2+" / "+BS);
			$("#tooltip3").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+DG2+" / "+DG);
			$("#tooltip4").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+IC2+" / "+IC);
			$("#tooltip5").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+GJ2+" / "+GJ);
			$("#tooltip6").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+DJ2+" / "+DJ);
			$("#tooltip7").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+US2+" / "+US);
			$("#tooltip8").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+GG2+" / "+GG);
			$("#tooltip9").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+GW2+" / "+GW);
			$("#tooltip10").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+NC2+" / "+NC);
			$("#tooltip11").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+SC2+" / "+SC);
			$("#tooltip12").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+NJ2+" / "+NJ);
			$("#tooltip13").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+SJ2+" / "+SJ);
			$("#tooltip14").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+NG2+" / "+NG);
			$("#tooltip15").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+SG2+" / "+SG);
			$("#tooltip16").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+JJ2+" / "+JJ);
			$("#tooltip17").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+SE2+" / "+SE);

		// define tile layer
	    var vworldTile = new ol.layer.Tile({
	        title : 'VWorld Gray Map',
	        visible : true,
	        type : 'base',
	        source : new ol.source.XYZ({
	            url : 'http://xdworld.vworld.kr:8080/2d/Base/201802/{z}/{x}/{y}.png',
	            attributions: [
	                new ol.Attribution({ 
	                    html: ['&copy; <a href="http://map.vworld.kr">V-World Map</a>'] 
	                })
	            ]
	        })
	    });
	    
	     //var distance = document.getElementById('distance');
	     
	      var source = new ol.source.Vector({
	       features: features
	     }); 

	     var clusterSource = new ol.source.Cluster({
	       //distance: parseInt(distance.value, 10),
	       source: source
	     });

	     var styleCache = {};
	     var canvas = document.createElement('canvas');
	     canvas.width = 80;
	     canvas.height = 30;
	     var ctx = canvas.getContext('2d');
	     ctx.fillStyle = 'rgba(0, 0, 0, 0.6)';
	     ctx.fillRect(0, 0, canvas.width, canvas.height);;
	     var clusters = new ol.layer.Vector({
	       source: clusterSource,
	       style: function(feature) {
	         var size = feature.get('features').length;
	         var style = styleCache[size];
	         if (!style) {
	           style = [new ol.style.Style({
						image: new ol.style.Icon({
						img: canvas,
						imgSize: [90, 20]
			           }), 

	             text: new ol.style.Text({
	               text: size.toString()+" / "+parseInt((size.toString()*100)/14),
	               scale: 1.5,
	               fill: new ol.style.Fill({
	                 color: '#fff'
	               })
	             })
	           })
	           ];
	           styleCache[size] = style;
	         }
	         return style;
	       }
	     });
	     var styleCache2 = {};
	     var clusters2 = new ol.layer.Vector({
		       source: clusterSource,
		       style: function(feature) {
		         var size = feature.get('features').length;
		         var style = styleCache2[size];
		         if (!style) {
		           style = [new ol.style.Style({
							image: new ol.style.Icon({
								anchor: [3, 0.5],
				        	    scale: 0.3,
	            				anchorXUnits: 'fraction',
	            				anchorYUnits: 'fraction',
			        	   		src:'/images/icon_h4.png'
				           }), 
		           })
		           ];
		           styleCache2[size] = style;
		         }
		         return style;
		       }
		     });

	      var raster = new ol.layer.Tile({
	       source: new ol.source.OSM()
	     }); 
	      var stamenTile = new ol.layer.Tile({
              title : 'Stamen Watercolor',
              visible : false,
              type : 'base',
              source: new ol.source.Stamen({
                  layer: 'watercolor'
              })
          });

	      var overlay = new ol.Overlay({
              element: document.getElementById('overlay'),
              positioning: 'bottom-center'
            });

           var popup = new ol.Overlay({
               element: document.getElementById('tooltip')
             });
           var popup2 = new ol.Overlay({
               element: document.getElementById('tooltip2')
             });
           var popup3 = new ol.Overlay({
               element: document.getElementById('tooltip3')
             });
           var popup4 = new ol.Overlay({
               element: document.getElementById('tooltip4')
             });
           var popup5 = new ol.Overlay({
               element: document.getElementById('tooltip5')
             });
           var popup6 = new ol.Overlay({
               element: document.getElementById('tooltip6')
             });
           var popup7 = new ol.Overlay({
               element: document.getElementById('tooltip7')
             });
           var popup8 = new ol.Overlay({
               element: document.getElementById('tooltip8')
             });
           var popup9 = new ol.Overlay({
               element: document.getElementById('tooltip9')
             });
           var popup10 = new ol.Overlay({
               element: document.getElementById('tooltip10')
             });
           var popup11 = new ol.Overlay({
               element: document.getElementById('tooltip11')
             });
           var popup12 = new ol.Overlay({
               element: document.getElementById('tooltip12')
             });
           var popup13 = new ol.Overlay({
               element: document.getElementById('tooltip13')
             });
           var popup14 = new ol.Overlay({
               element: document.getElementById('tooltip14')
             });
           var popup15 = new ol.Overlay({
               element: document.getElementById('tooltip15')
             });
           var popup16 = new ol.Overlay({
               element: document.getElementById('tooltip16')
             });
           var popup17 = new ol.Overlay({
               element: document.getElementById('tooltip17')
             });

           var ol3_sprint_location = ol.proj.transform([126.77, 37.99], 'EPSG:4326', 'EPSG:3857'); //서울
           var ol3_sprint_location2 = ol.proj.transform([129.00, 35.06], 'EPSG:4326', 'EPSG:3857'); //부산
           var ol3_sprint_location3 = ol.proj.transform([128.33, 36.18], 'EPSG:4326', 'EPSG:3857'); //대구
           var ol3_sprint_location4 = ol.proj.transform([125.70, 37.84], 'EPSG:4326', 'EPSG:3857'); //인천
           var ol3_sprint_location5 = ol.proj.transform([126.63, 35.54], 'EPSG:4326', 'EPSG:3857'); //광주
           var ol3_sprint_location6 = ol.proj.transform([127.38, 36.72], 'EPSG:4326', 'EPSG:3857'); //대전
           var ol3_sprint_location7 = ol.proj.transform([129.05, 35.92], 'EPSG:4326', 'EPSG:3857'); //울산
           var ol3_sprint_location8 = ol.proj.transform([126.11, 37.12], 'EPSG:4326', 'EPSG:3857'); //경기
           var ol3_sprint_location9 = ol.proj.transform([127.98, 38.15], 'EPSG:4326', 'EPSG:3857'); //강원
           var ol3_sprint_location10 = ol.proj.transform([127.83, 37.30], 'EPSG:4326', 'EPSG:3857'); //충북
           var ol3_sprint_location11 = ol.proj.transform([125.78, 36.36], 'EPSG:4326', 'EPSG:3857'); //충남
           var ol3_sprint_location12 = ol.proj.transform([126.96, 36.12], 'EPSG:4326', 'EPSG:3857'); //전북
           var ol3_sprint_location13 = ol.proj.transform([126.54, 34.78], 'EPSG:4326', 'EPSG:3857'); //전남
           var ol3_sprint_location14 = ol.proj.transform([128.75, 36.76], 'EPSG:4326', 'EPSG:3857'); //경북
           var ol3_sprint_location15 = ol.proj.transform([127.81, 35.20], 'EPSG:4326', 'EPSG:3857'); //경남
           var ol3_sprint_location16 = ol.proj.transform([126.23, 33.78], 'EPSG:4326', 'EPSG:3857'); //제주
           var ol3_sprint_location17 = ol.proj.transform([126.15, 36.81], 'EPSG:4326', 'EPSG:3857'); //세종
	     
	        // set map
	        var map = new ol.Map({
	            controls : [
	                new ol.control.Attribution({
	                    collapsible: true
	                }), 
	                new ol.control.Zoom(), 
	                new ol.control.FullScreen(),
	                new ol.control.MousePosition({
	                    projection: 'EPSG:4326',
	                    coordinateFormat: ol.coordinate.createStringXY(2)
	                }),
	                new ol.control.ZoomToExtent({
	                    extent: [12878110, 3779046, 15395028, 5381166]
	                }),
	                new ol.control.ScaleLine(),
	                new ol.control.LayerSwitcher()
	            ],
	            layers : [
	                new ol.layer.Group({
	                    title : 'Base Maps',
	                    layers : [
	                    	//raster,
	                    	vworldTile,
	                        //clusters,
	                        stamenTile
	                    ]
	                  }),
	                new ol.layer.Group({
	                    title: 'Tiled WMS',
	                    layers: [
	                    ]
	                })
	            ],
	            target : 'map',
	            renderer: 'canvas',
	            interactions : ol.interaction.defaults({
	            	shiftDragZoom : false,
	                mouseWheelZoom:true,
	                doubleClickZoom:false
	            }),
	            view : new ol.View({
	                projection: 'EPSG:3857',
	                center : new ol.geom.Point([128, 36]).transform('EPSG:4326', 'EPSG:3857').getCoordinates(),
	                zoom : 7
	            })
	        });

	         map.addOverlay(popup);
            popup.setPosition(ol3_sprint_location);
            map.addOverlay(popup2);
            popup2.setPosition(ol3_sprint_location2);
            map.addOverlay(popup3);
            popup3.setPosition(ol3_sprint_location3);
            map.addOverlay(popup4);
            popup4.setPosition(ol3_sprint_location4);
            map.addOverlay(popup5);
            popup5.setPosition(ol3_sprint_location5);
            map.addOverlay(popup6);
            popup6.setPosition(ol3_sprint_location6);
            map.addOverlay(popup7);
            popup7.setPosition(ol3_sprint_location7);
            map.addOverlay(popup8);
            popup8.setPosition(ol3_sprint_location8);
            map.addOverlay(popup9);
            popup9.setPosition(ol3_sprint_location9);
            map.addOverlay(popup10);
            popup10.setPosition(ol3_sprint_location10);
            map.addOverlay(popup11);
            popup11.setPosition(ol3_sprint_location11);
            map.addOverlay(popup12);
            popup12.setPosition(ol3_sprint_location12);
            map.addOverlay(popup13);
            popup13.setPosition(ol3_sprint_location13);
            map.addOverlay(popup14);
            popup14.setPosition(ol3_sprint_location14);
            map.addOverlay(popup15);
            popup15.setPosition(ol3_sprint_location15);
            map.addOverlay(popup16);
            popup16.setPosition(ol3_sprint_location16);
            map.addOverlay(popup17);
            popup17.setPosition(ol3_sprint_location17);

	        var currZoom = map.getView().getZoom();
	        map.on('moveend', function(e) {
	          var newZoom = map.getView().getZoom();
	          if (currZoom != newZoom) {
	            console.log('zoom end, new zoom: ' + newZoom);
	            currZoom = newZoom;
	            if(newZoom <= 7){
	            	map.addOverlay(popup);
	                popup.setPosition(ol3_sprint_location);
	                map.addOverlay(popup2);
	                popup2.setPosition(ol3_sprint_location2);
	                map.addOverlay(popup3);
	                popup3.setPosition(ol3_sprint_location3);
	                map.addOverlay(popup4);
	                popup4.setPosition(ol3_sprint_location4);
	                map.addOverlay(popup5);
	                popup5.setPosition(ol3_sprint_location5);
	                map.addOverlay(popup6);
	                popup6.setPosition(ol3_sprint_location6);
	                map.addOverlay(popup7);
	                popup7.setPosition(ol3_sprint_location7);
	                map.addOverlay(popup8);
	                popup8.setPosition(ol3_sprint_location8);
	                map.addOverlay(popup9);
	                popup9.setPosition(ol3_sprint_location9);
	                map.addOverlay(popup10);
	                popup10.setPosition(ol3_sprint_location10);
	                map.addOverlay(popup11);
	                popup11.setPosition(ol3_sprint_location11);
	                map.addOverlay(popup12);
	                popup12.setPosition(ol3_sprint_location12);
	                map.addOverlay(popup13);
	                popup13.setPosition(ol3_sprint_location13);
	                map.addOverlay(popup14);
	                popup14.setPosition(ol3_sprint_location14);
	                map.addOverlay(popup15);
	                popup15.setPosition(ol3_sprint_location15);
	                map.addOverlay(popup16);
	                popup16.setPosition(ol3_sprint_location16);
	                map.addOverlay(popup17);
	                popup17.setPosition(ol3_sprint_location17);
	                map.removeLayer(clusters);
	                map.removeLayer(clusters2);
		            }else{
		            	map.removeOverlay(popup);
						map.removeOverlay(popup2);
						map.removeOverlay(popup3);
						map.removeOverlay(popup4);
						map.removeOverlay(popup5);
						map.removeOverlay(popup6);
						map.removeOverlay(popup7);
						map.removeOverlay(popup8);
						map.removeOverlay(popup9);
						map.removeOverlay(popup10);
						map.removeOverlay(popup11);
						map.removeOverlay(popup12);
						map.removeOverlay(popup13);
						map.removeOverlay(popup14);
						map.removeOverlay(popup15);
						map.removeOverlay(popup16);
						map.removeOverlay(popup17);
						map.removeLayer(clusters);
						map.addLayer(clusters);
						map.removeLayer(clusters2);
						map.addLayer(clusters2);

			            }
	          }
	        });


		var append = "";
		var progress = parseInt(data.tchnlgyCount.receipt)+parseInt(data.tchnlgyCount.progress);
		append += "<tr>";
		append += "<td style='text-align: center'><font class='purple'>"+data.tchnlgyCount.tbl_cnt+"</font></td>";
		append += "<td style='text-align: center'><font class='purple'>"+progress+"</font></td>";
		append += "<td style='text-align: center'><font class='purple'>"+data.tchnlgyCount.complete+"</font></td>";
		append += "</tr>";
		append += "";
		$("#tchnlgyCountBody").append(append);
		$("#tchnlgyCount td").each(function(i,v){
			if(i==1)
				$(this).children().eq(1).html("<font class='purple'>"+data.tchnlgyCount.tbl_cnt+"</font>");
			if(i==2)
				$(this).children().eq(1).html("<font class='purple'>"+data.tchnlgyCount.receipt+"</font> / "+BS);
			if(i==3)
				$(this).children().eq(1).html("<font class='purple'>"+data.tchnlgyCount.complete+"</font> / "+DG);
			if(i==4)
				$(this).children().eq(1).html("<font class='purple'>"+data.tchnlgyCount.progress+"</font> / "+IC);

		});
		$("#sido1 tr").each(function(i,v){
			if(i==1)
				$(this).children().eq(1).html("<font class='purple'>"+SU2+"</font> / "+SU);
			if(i==2)
				$(this).children().eq(1).html("<font class='purple'>"+BS2+"</font> / "+BS);
			if(i==3)
				$(this).children().eq(1).html("<font class='purple'>"+DG2+"</font> / "+DG);
			if(i==4)
				$(this).children().eq(1).html("<font class='purple'>"+IC2+"</font> / "+IC);
			if(i==5)
				$(this).children().eq(1).html("<font class='purple'>"+GJ2+"</font> / "+GJ);
			if(i==6)
				$(this).children().eq(1).html("<font class='purple'>"+DJ2+"</font> / "+DJ);
			if(i==7)
				$(this).children().eq(1).html("<font class='purple'>"+US2+"</font> / "+US);
			
		});
		$("#sido2 tr").each(function(i,v){
			if(i==1)
				$(this).children().eq(1).html("<font class='purple'>"+GG2+"</font> / "+GG);
			if(i==2)
				$(this).children().eq(1).html("<font class='purple'>"+GW2+"</font> / "+GW);
			if(i==3)
				$(this).children().eq(1).html("<font class='purple'>"+NC2+"</font> / "+NC);
			if(i==4)
				$(this).children().eq(1).html("<font class='purple'>"+SC2+"</font> / "+SC);
			if(i==5)
				$(this).children().eq(1).html("<font class='purple'>"+NJ2+"</font> / "+NJ);
			if(i==6)
				$(this).children().eq(1).html("<font class='purple'>"+SJ2+"</font> / "+SJ);
			if(i==7)
				$(this).children().eq(1).html("<font class='purple'>"+NG2+"</font> / "+NG);
			if(i==8)
				$(this).children().eq(1).html("<font class='purple'>"+SG2+"</font> / "+SG);
			if(i==9)
				$(this).children().eq(1).html("<font class='purple'>"+JJ2+"</font> / "+JJ);
			if(i==10)
				$(this).children().eq(1).html("<font class='purple'>"+SE2+"</font> / "+SE);
			
		});
	});
});
			
	function startInterval(seconds, callback) { 
		callback(); 
	return setInterval(callback, seconds * 1000);
	}

</script>

<script type="text/javascript" src="javascript/ol.js"></script>
<script type="text/javascript" src="javascript/ol3-layerswitcher.js"></script>
<script type="text/javascript" src="javascript/proj4.js"></script>

	
	<%@ include file="../template/footer.jsp" %>
</body>
