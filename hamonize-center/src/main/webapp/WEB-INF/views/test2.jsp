<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml"%>



<!DOCTYPE html>
<html lang="en" class="app">

<head>
  <meta charset="utf-8" />
  <title>Notebook | Web Application</title>
  <meta name="description"
    content="app, web app, responsive, admin dashboard, admin, flat, flat ui, ui kit, off screen nav" />
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
  <link rel="stylesheet" href="/logintemplet/notebook/css/bootstrap.css" type="text/css" />
  <link rel="stylesheet" href="/logintemplet/notebook/css/animate.css" type="text/css" />
  <link rel="stylesheet" href="/logintemplet/notebook/css/font-awesome.min.css" type="text/css" />
  <link rel="stylesheet" href="/logintemplet/notebook/css/font.css" type="text/css" />

  <link rel="stylesheet" href="/logintemplet/notebook/css/app.css" type="text/css" />
  <!--[if lt IE 9]>
    <script src="js/ie/html5shiv.js"></script>
    <script src="js/ie/respond.min.js"></script>
    <script src="js/ie/excanvas.js"></script>
  <![endif]-->
</head>

<body>
  <section class="vbox">


    <section>
      <section class="hbox stretch">
        <!-- .aside -->
        <aside class="bg-light lter b-r aside-md hidden-print" id="nav">
          <section class="vbox">
            
            <header class="header bg-primary lter text-center clearfix">
              <div class="btn-group">
                <div class="btn-group hidden-nav-xs">
                  <a href="#" class="" data-toggle="fullscreen"><img src="http://ts.hamonikr.org/images/hlogo.png" class="m-r-sm" width="90%"></a>
                </div>
              </div>
            </header>


            <section class="w-f scrollable">
              <div class="slim-scroll" data-height="auto" data-disable-fade-out="true" data-distance="0" data-size="5px" data-color="#333333">

                <!-- nav -->
                <nav class="nav-primary hidden-xs">
                  <ul class="nav">
                    <li>
                      <a href="index.html">
                        <i class="fa fa-dashboard icon">
                          <b class="bg-danger"></b>
                        </i>
                        <span>모니터링</span>
                      </a>
                    </li>
                    <li>
                      <a href="#layout">
                        <i class="fa fa-columns icon">
                          <b class="bg-warning"></b>
                        </i>
                        <span>조직관리</span>
                      </a>
                    </li>
                    <li>
                      <a href="mail.html">
                        <i class="fa fa-envelope-o icon">
                          <b class="bg-primary dker"></b>
                        </i>
                        <span>PC관리</span>
                      </a>
                    </li>
                    <li>
                      <a href="#pages" >
                        <i class="fa fa-file-text icon">
                          <b class="bg-primary"></b>
                        </i>
                        <span class="pull-right">
                          <i class="fa fa-angle-down text"></i>
                          <i class="fa fa-angle-up text-active"></i>
                        </span>
                        <span>정책관리</span>
                      </a>
                      <ul class="nav lt">
                        <li>
                          <a href="signin.html">
                            <i class="fa fa-angle-right"></i>
                            <span>프로그램설치관리</span>
                          </a>
                        </li>
                        <li>
                          <a href="signup.html">
                            <i class="fa fa-angle-right"></i>
                            <span>프로그램차단</span>
                          </a>
                        </li>
                        <li>
                          <a href="404.html">
                            <i class="fa fa-angle-right"></i>
                            <span>방화벽관리</span>
                          </a>
                        </li>
                        <li>
                          <a href="docs.html">
                            <i class="fa fa-angle-right"></i>
                            <span>디바이스관리</span>
                          </a>
                        </li>
                        <li>
                          <a href="docs.html">
                            <i class="fa fa-angle-right"></i>
                            <span>정책배포결과</span>
                          </a>
                        </li>
                      </ul>
                    </li>
                    <li>
                      <a href="#pages" >
                        <i class="fa fa-file-text icon">
                          <b class="bg-primary"></b>
                        </i>
                        <span class="pull-right">
                          <i class="fa fa-angle-down text"></i>
                          <i class="fa fa-angle-up text-active"></i>
                        </span>
                        <span>백업관리</span>
                      </a>
                      <ul class="nav lt">
                        <li>
                          <a href="signin.html">
                            <i class="fa fa-angle-right"></i>
                            <span>백업주기설정</span>
                          </a>
                        </li>
                        <li>
                          <a href="signup.html">
                            <i class="fa fa-angle-right"></i>
                            <span>복구관리</span>
                          </a>
                        </li>
                      </ul>
                    </li>
                    <li>
                      <a href="#pages" >
                        <i class="fa fa-file-text icon">
                          <b class="bg-primary"></b>
                        </i>
                        <span class="pull-right">
                          <i class="fa fa-angle-down text"></i>
                          <i class="fa fa-angle-up text-active"></i>
                        </span>
                        <span>로그감사</span>
                      </a>
                      <ul class="nav lt">
                        <li>
                          <a href="signin.html">
                            <i class="fa fa-angle-right"></i>
                            <span>사용자접속로그</span>
                          </a>
                        </li>
                        <li>
                          <a href="signup.html">
                            <i class="fa fa-angle-right"></i>
                            <span>프로그램 차단 로그</span>
                          </a>
                        </li>
                        <li>
                          <a href="signup.html">
                            <i class="fa fa-angle-right"></i>
                            <span>하드웨어 변경 로그</span>
                          </a>
                        </li>
                        <li>
                          <a href="signup.html">
                            <i class="fa fa-angle-right"></i>
                            <span>디바이스로그</span>
                          </a>
                        </li>
                      </ul>
                    </li>
                  </ul>
                  
                </nav>
                <!-- / nav -->
              </div>
            </section>

            <footer class="footer lt hidden-xs b-t b-light">
              <ul class="nav">
                <li>
                  <a href="signup.html">
                    <i class="fa fa-thumb-tack"></i>
                    <span>알림</span>
                  </a>
                </li>
                <li>
                  <a href="signup.html">
                    <!-- <i class="fa fa-gears"></i> -->
                    <i class="fa fa-thumb-tack"></i>
                    <span>환경설정</span>
                  </a>
                </li>
                <li>
                  <a href="signup.html">
                    <i class="fa fa-thumb-tack"></i>
                    <span>Admin</span>
                  </a>
                </li>
              </ul>
              <div id="chat" class="dropup">
                <section class="dropdown-menu on aside-md m-l-n">
                  <section class="panel bg-white">
                    <header class="panel-heading b-b b-light">Active chats</header>
                    <div class="panel-body animated fadeInRight">
                      <p class="text-sm">No active chats.</p>
                      <p><a href="#" class="btn btn-sm btn-default">Start a chat</a></p>
                    </div>
                  </section>
                </section>
              </div>
              <div id="invite" class="dropup">
                <section class="dropdown-menu on aside-md m-l-n">
                  <section class="panel bg-white">
                    <header class="panel-heading b-b b-light">
                      John <i class="fa fa-circle text-success"></i>
                    </header>
                    <div class="panel-body animated fadeInRight">
                      <p class="text-sm">No contacts in your lists.</p>
                      <p><a href="#" class="btn btn-sm btn-facebook"><i class="fa fa-fw fa-facebook"></i> Invite from
                          Facebook</a></p>
                    </div>
                  </section>
                </section>
              </div>
              <a href="#nav" data-toggle="class:nav-xs" class="pull-right btn btn-sm btn-default btn-icon">
                <i class="fa fa-angle-left text"></i>
                <i class="fa fa-angle-right text-active"></i>
              </a>
              <div class="btn-group hidden-nav-xs">
                <button type="button" title="Chats" class="btn btn-icon btn-sm btn-default" data-toggle="dropdown"
                  data-target="#chat"><i class="fa fa-comment-o"></i></button>
                <button type="button" title="Contacts" class="btn btn-icon btn-sm btn-default" data-toggle="dropdown"
                  data-target="#invite"><i class="fa fa-facebook"></i></button>
              </div>
            </footer>
          </section>
        </aside>
        <!-- /.aside -->

        <!--  body start  -->
        <section id="content">
          <section class="vbox">


            <section class="scrollable">
              <section class="hbox stretch">
                <!-- body left  -->
                <aside class="aside-lg bg-light lter b-r">
                  <section class="vbox">
                    <section class="scrollable">
                      <div class="wrapper">

                        <div class="clearfix m-b">
                          <div class="clear" style="float:right">
                            <small class="text-muted"><i class="fa fa-map-marker"></i> Home / 정책관리 / 업데이트관리</small>
                          </div>
                        </div>


                        <div class="panel wrapper panel-success">
                          <div class="row">
                            <div class="col-xs-12">
                              <div class="btn-group btn-group-justified m-b">
                                <a class="btn btn-primary btn-rounded" id="expandAllBtn"><span
                                    class="text">전체열기</span></a>
                                <a class="btn btn-dark btn-rounded" id="collapseAllBtn"><span
                                    class="text">전체닫기</span></a>
                              </div>
                              <div class="tree_list">
                                <ul id="tree" class="ztree"></ul>
                              </div>
                            </div>
                          </div>


                        </div>

                        <div class="panel-footer text-right">
                          <div class="btn-group">
                            <button class="btn btn-default" id="btnAddOrg_s" name="btnAddOrg_s"><i
                                class="fa fa-arrow-right"></i>추가</button>
                            <button class="btn btn-default" id="btnDelOrg" name="btnDelOrg"><i
                                class="fa fa-trash-o"></i> 삭제</button>
                          </div>
                        </div>

                      </div>
                    </section>
                  </section>
                </aside>


                <!-- body right -->
                <aside class="bg-white">
                  <section class="vbox">
                    <section class="scrollable">
                      <div class="wrapper">
                        <section class="panel panel-default">
                          <form>
                            <textarea class="form-control no-border" rows="3"
                              placeholder="What are you doing..."></textarea>
                          </form>
                          <footer class="panel-footer bg-light lter">
                            <button class="btn btn-info pull-right btn-sm">POST</button>
                            <ul class="nav nav-pills nav-sm">
                              <li><a href="#"><i class="fa fa-camera text-muted"></i></a></li>
                              <li><a href="#"><i class="fa fa-video-camera text-muted"></i></a></li>
                            </ul>
                          </footer>
                        </section>
                        <section class="panel panel-default">
                          <h4 class="font-thin padder">Latest Tweets</h4>
                          <ul class="list-group">
                            <li class="list-group-item">
                              <p>Wellcome <a href="#" class="text-info">@Drew Wllon</a> and play this web application
                                template, have fun1 </p>
                              <small class="block text-muted"><i class="fa fa-clock-o"></i> 2 minuts ago</small>
                            </li>
                            <li class="list-group-item">
                              <p>Morbi nec <a href="#" class="text-info">@Jonathan George</a> nunc condimentum ipsum
                                dolor sit amet, consectetur</p>
                              <small class="block text-muted"><i class="fa fa-clock-o"></i> 1 hour ago</small>
                            </li>
                            <li class="list-group-item">
                              <p><a href="#" class="text-info">@Josh Long</a> Vestibulum ullamcorper sodales nisi nec
                                adipiscing elit. </p>
                              <small class="block text-muted"><i class="fa fa-clock-o"></i> 2 hours ago</small>
                            </li>
                          </ul>
                        </section>
                        <section class="panel clearfix bg-info lter">
                          <div class="panel-body">
                            <a href="#" class="thumb pull-left m-r">
                              <img src="images/avatar.jpg" class="img-circle">
                            </a>
                            <div class="clear">
                              <a href="#" class="text-info">@Mike Mcalidek <i class="fa fa-twitter"></i></a>
                              <small class="block text-muted">2,415 followers / 225 tweets</small>
                              <a href="#" class="btn btn-xs btn-success m-t-xs">Follow</a>
                            </div>
                          </div>
                        </section>
                      </div>
                    </section>
                  </section>
                </aside>
              </section>
            </section>
            
            
          </section>
          <a href="#" class="hide nav-off-screen-block" data-toggle="class:nav-off-screen" data-target="#nav"></a>
        </section>

        <!--  body end  -->

      </section>
    </section>
  </section>
  
  
  <script src="/logintemplet/notebook/js/jquery.min.js"></script>
  <!-- Bootstrap -->
  <script src="/logintemplet/notebook/js/bootstrap.js"></script>
  <!-- App -->
  <script src="/logintemplet/notebook/js/app.js"></script>
  <script src="/logintemplet/notebook/js/app.plugin.js"></script>
  <script src="/logintemplet/notebook/js/slimscroll/jquery.slimscroll.min.js"></script>





<link rel="stylesheet" type="text/css" href="/css/ztree/zTreeStyle.css" />
<script type="text/javascript" src="/js/ztree/jquery.ztree.core.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.exedit.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.excheck.js"></script>
<script type="text/javascript">
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
			edit: {
				drag: {
					autoExpandTrigger: true,
					prev: dropPrev,
					inner: dropInner,
					next: dropNext
				}, 
				enable: true,
				showRemoveBtn: false,
				showRenameBtn: false
			},
			callback: {
				beforeDrag: beforeDrag,
				beforeDrop: beforeDrop,
				beforeDragOpen: beforeDragOpen,
				onDrag: onDrag,
				onDrop: onDrop,
				onExpand: onExpand,
				beforeClick: beforeClick,
				onClick: onClick
			}
		};
	var zNodes =[
		<c:forEach items="${oList}" var="data" varStatus="status" >
		{ id:"${data.seq}", pId:"${data.p_seq}",
			<c:if test="${data.section ne 'S'}">
			name:"${data.org_nm} "
			</c:if>
			<c:if test="${data.section eq 'S'}">
			name:"${data.org_nm}"
			</c:if>
			,od:"${data.org_ordr}"
			<c:if test="${data.level eq '0' or data.level eq '1' or data.level eq '2'}">
			,open:true
			</c:if>
			},
		</c:forEach>				
	];
	
	$(document).ready(function(){
	//트리 init
	$.fn.zTree.init($("#tree"), setting, zNodes); 
	var treeObj =  $.fn.zTree.getZTreeObj("tree");
	var sNodes = treeObj.getSelectedNodes();
	console.log(sNodes.length);
	if (sNodes.length > 0) {
		var isOpen = sNodes[2].open;
	}
	
	$("#expandAllBtn").bind("click", {type:"expandAll"}, expandNode);
	$("#collapseAllBtn").bind("click", {type:"collapseAll"}, expandNode);
	$("#btnAddOrg").bind("click", {isParent:false}, addOrgcht);
	$("#btnAddOrg_s").bind("click", {isParent:false}, addOrgcht_s);
	$("#btnDelOrg").bind("click", removeOrgcht);
		
	//등록버튼
	$("#btnSave").click(fnSave);
	
	//순서 변경저장
    //$("#btnChange").click(fnChange);	
	
});

 $(document).on("click", ':button',  function() {
	
	var buttonName = this.name; 
	
	//담당업무 추가
	if(buttonName.indexOf('btnAddChrg') != -1) {		
		addRowChrgjob(); //담당업무 추가
	}
	
	//담당업무 삭제
	if(buttonName.indexOf("btnDelChrg") != -1) {
		var idx = $(this).index("button[name='"+buttonName+"'");
		var jobSeq = $("input[name=jobSeq]:eq("+idx+")").val()
		console.log(idx);
		console.log(jobSeq);
		removeRowChrgjob(idx,jobSeq); //담당업무 삭제
	}
}); 
//드래그 관련
 function dropPrev(treeId, nodes, targetNode) {
		var pNode = targetNode.getParentNode();
		if (pNode && pNode.dropInner === false) {
			return false;
		} else {
			for (var i=0,l=curDragNodes.length; i<l; i++) {
				var curPNode = curDragNodes[i].getParentNode();
				if (curPNode && curPNode !== targetNode.getParentNode() && curPNode.childOuter === false) {
					return false;
				}
			}
		}
		return true;
	}
	function dropInner(treeId, nodes, targetNode) {
		if (targetNode && targetNode.dropInner === false) {
			return false;
		} else {
			for (var i=0,l=curDragNodes.length; i<l; i++) {
				if (!targetNode && curDragNodes[i].dropRoot === false) {
					return false;
				} else if (curDragNodes[i].parentTId && curDragNodes[i].getParentNode() !== targetNode && curDragNodes[i].getParentNode().childOuter === false) {
					return false;
				}
			}
		}
		return true;
	}
	function dropNext(treeId, nodes, targetNode) {
		var pNode = targetNode.getParentNode();
		if (pNode && pNode.dropInner === false) {
			return false;
		} else {
			for (var i=0,l=curDragNodes.length; i<l; i++) {
				var curPNode = curDragNodes[i].getParentNode();
				if (curPNode && curPNode !== targetNode.getParentNode() && curPNode.childOuter === false) {
					return false;
				}
			}
		}
		return true;
	}
	
	var log, className = "dark", curDragNodes, autoExpandNode;
	function beforeDrag(treeId, treeNodes) {
		className = (className === "dark" ? "":"dark");
		for (var i=0,l=treeNodes.length; i<l; i++) {
			if (treeNodes[i].drag === false) {
				curDragNodes = null;
				return false;
			} else if (treeNodes[i].parentTId && treeNodes[i].getParentNode().childDrag === false) {
				curDragNodes = null;
				return false;
			}
		}
		curDragNodes = treeNodes;
		return true;
	}
	function beforeDragOpen(treeId, treeNode) {
		autoExpandNode = treeNode;
		return true;
	}
	function beforeDrop(treeId, treeNodes, targetNode, moveType, isCopy) {
		className = (className === "dark" ? "":"dark");
		return true;
	}
	function onDrag(event, treeId, treeNodes) {
		className = (className === "dark" ? "":"dark");
	}
	function onDrop(event, treeId, treeNodes, targetNode, moveType, isCopy) {
		className = (className === "dark" ? "":"dark");
	}
	function onExpand(event, treeId, treeNode) {
		if (treeNode === autoExpandNode) {
			className = (className === "dark" ? "":"dark");
		}
	}
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
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		var pSpan = "#"+treeNode.parentTId+"_span";
	
		$.post("/org/orgManage.do",{type:'show',seq:treeNode.id},
		function(result){
				var agrs = result;
				console.log("agrs============="+agrs);
				if(agrs.section == "S"){
					
					$("#trOrg_num").remove();
					$("#trPseq").remove();
					$('#nm').html("팀명");
				
// 					var shtml = "<tr id=\"trPseq\"><th>상위 부서번호</th> <td><input type=\"text\" name=\"p_seq\" id=\"p_seq\" class=\"input_type1 w100\" readonly /></td></tr>";
					
					var shtml = '<div class="input-group mg-b-pro-edt">';
					shtml += '<span class="input-group-addon"><i class="icon nalika-new-file" aria-hidden="true"></i></span>';
					shtml += '<input type="text" class="form-control" placeholder="상위부서번호" name="p_seq" id="p_seq">';
					shtml += '</div>';
					
					$(".board_view tbody").append(shtml);
				}else{
					$('#nm').html("부서명");
					$("#trOrg_num").remove();
					$("#trPseq").remove();
					 
// 					var shtml = "<tr id=\"trPseq\"><th>상위 부서번호</th> <td><input type=\"text\" name=\"p_seq\" id=\"p_seq\" class=\"input_type1 w100\" /></td></tr>";
					var shtml = '<div class="input-group mg-b-pro-edt">';
					shtml += '<span class="input-group-addon"><i class="icon nalika-new-file" aria-hidden="true"></i></span>';
					shtml += '<input type="text" class="form-control" placeholder="상위부서번호" name="p_seq" id="p_seq">';
					shtml += '</div>';
					
// 					$(".board_view tbody").append(shtml);
					$('#frm').append(shtml);
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
		console.log("section===="+$("#section").val())
			
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

//부서 추가
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
		$("#nm").html("부서명");
		$("#org_nm").attr("placeholder","부서명을 입력하세요");
				
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
				$('form[name=frm]').append("<input type='hidden' name='p_seq' id='p_seq' value='"+treeNode.id+"' />");
				$('form[name=frm] input[name=org_nm]').focus();
				
				console.log("treeNode.id==="+treeNode.id);
				console.log("all====="+$("#all_org_nm").val());
				console.log(treeNode.name);
				console.log(treeNode.id);
				console.log($("#seq").val());
				console.log();
			
		} else {
			alert("부서를 선택해 주세요.");
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
				alert("상위 부서를 선택해 주세요.");
			}
		};
		
		//부서 삭제 
 function removeOrgcht(e) {
	 	var all_org_nm = $("#all_org_nm").val();
		var zTree = $.fn.zTree.getZTreeObj("tree"),
		nodes = zTree.getSelectedNodes(),
		treeNode = nodes[0];
		
		if (nodes.length == 0) {
			alert("부서를 선택해 주세요");
			return;
		}else{
			if(confirm("하위부서가 있다면 하위부서도 전부 삭제됩니다 삭제하시겠습니까?")){
				
				 $.post("/org/orgManage.do",{
						 type: 'delt'
						,seq:treeNode.id
						,p_seq:treeNode.pId
						,org_ordr:treeNode.od
						,org_nm:$("#org_nm").val()
						,all_org_nm:$("#all_org_nm").val()
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
		alert("부서명을 입력해주세요.");
		return false;
	}
	
	var regExp = /[\{\}\[\]\?.,;:|\*~`!^\-<>@\#$%&\\\=\'\"]/gi;
	 
	if(regExp.test($("#org_nm").val())){
		//특수문자 존재
		alert("허용되지 않은 특수문자가 있습니다.특수문자는 ( ) / _ + 만 사용하실수 있습니다.");
		return false;
	}
	
	if($("#seq").val() == null){
		console.log("등록");
	}else{
		console.log("수정");
		console.log("p_seq===="+$("#p_seq").val());
	}
	var all_org_nm = $("#all_org_nm").val();
	var org_nm = all_org_nm.split("|");

    $('form[name=frm]').append("<input type='hidden' name='type' value='save' />");        

	button.disabled	= true;

    $.ajax({
		url: '/org/orgManage.do',							// Any URL
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


</body>

</html>