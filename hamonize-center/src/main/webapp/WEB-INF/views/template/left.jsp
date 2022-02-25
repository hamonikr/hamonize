<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- background-color: #2a304c; -->
<style>
a {
  color: #e2c9c9;
}
.nav-xs .nav-primary > ul > li > a span {
  font-weight: normal;
  text-transform: none;
  font-size: 13px;
  color:#000;
}


</style>
<section class="vbox">


    <section>
        <section class="hbox stretch">
            <!-- .aside -->

            <!-- .aside -->
            <aside class=" aside-md hidden-print" id="nav" style="background-color: #2a304c;">
            <!-- <aside class="bg-light lter b-r aside-md hidden-print" id="nav" style="background-color: #2a304c;"> -->
                <section class="vbox">
                    
                    <header class="header dker navbar navbar-fixed-top-xs">
                        <div class="navbar-header">
                          
                          <a href="#" class="navbar-brand" data-toggle="fullscreen">
                            <img src="/logintemplet/notebook/images/hlogo.png" class="m-r-sm">
                            <span class="hidden-nav-xs"><img src="/logintemplet/notebook/images/hamonize.png" class="m-r-sm" width="70%"></span>
                          </a>
                          
                        </div>
                      </header>
                      
                    <!-- <header class="header text-center clearfix">
                        <div class="btn-group">
                            <div class="btn-group hidden-nav-xs">
                                <a href="#" class="navbar-brand" data-toggle="fullscreen">
                                    <img src="/logintemplet/notebook/images/hlogo.png" class="m-r-sm">
                                    <span class="hidden-nav-xs">Notebook</span>
                                  </a>
                                </div>
                            </div>
                        </header> -->
                        <!-- <a href="/" class="" data-toggle="fullscreen">
                          <img src="http://ts.hamonikr.org/images/hlogo.png" class="m-r-sm" width="90%"></a> -->
                        
                        <!-- <img src="/logintemplet/notebook/images/hlogo.png" class="m-r-sm" >
                        <img src="/logintemplet/notebook/images/hamonize.png" class="m-r-sm" width="90%"></a -->

                    <section class="w-f scrollable">
                        <div class="slim-scroll" data-height="auto" data-disable-fade-out="true" data-distance="0"
                            data-size="5px" data-color="#333333">

                            <!-- nav -->
                            <nav class="nav-primary hidden-xs">
                                <ul class="nav">
                                    <li>
                                        <a href="/mntrng/pcControlList" >
                                            <!-- <i class="fa fa-dashboard icon"> -->
                                            <i class="fa fa-dashboard icon" >
                                                
                                                <b class="bg-menu"></b>
                                            </i>
                                            <span>모니터링</span>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="/org/orgManage">
                                            <i class="fa fa-columns icon">
                                                <b class="bg-warning"></b>
                                            </i>
                                            <span>조직관리</span>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="/pcMngr/pcMngrList">
                                            <i class="fa fa-laptop icon">
                                                <b class="bg-primary dker"></b>
                                            </i>
                                            <span>PC관리</span>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="/gplcs/umanage">
                                            <i class="fa circle-0 icon">
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
                                                <a href="/gplcs/umanage">
                                                    <i class="fa fa-angle-right"></i>
                                                    <span>프로그램설치관리</span>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="/gplcs/pmanage">
                                                    <i class="fa fa-angle-right"></i>
                                                    <span>프로그램차단관리</span>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="/gplcs/fmanage">
                                                    <i class="fa fa-angle-right"></i>
                                                    <span>방화벽관리</span>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="/gplcs/dmanage">
                                                    <i class="fa fa-angle-right"></i>
                                                    <span>디바이스관리</span>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="/auditLog/updateCheckLog">
                                                    <i class="fa fa-angle-right"></i>
                                                    <span>정책배포결과</span>
                                                </a>
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="/backupRestore/backupR">
                                            <i class="fa circle-1 icon">
                                                <b class="bg-primary"></b>
                                            </i>
                                            <span class="pull-right">
                                                <i class="fa fa-angle-down text"></i>
                                                <i class="fa fa-angle-up text-active"></i>
                                            </span>
                                            <span>복구관리</span>
                                        </a>
                                    </li>
                                    <!-- <li>
                                        <a href="/backupRecovery/backupC">
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
                                                <a href="/backupRecovery/backupC">
                                                    <i class="fa fa-angle-right"></i>
                                                    <span>백업주기설정</span>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="/backupRecovery/backupR">
                                                    <i class="fa fa-angle-right"></i>
                                                    <span>복구관리</span>
                                                </a>
                                            </li>
                                        </ul>
                                    </li> -->
                                    <li>
                                        <a href="/auditLog/pcUserLog">
                                            <i class="fa circle-2 icon">
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
                                                <a href="/auditLog/pcUserLog">
                                                    <i class="fa fa-angle-right"></i>
                                                    <span>사용자접속로그</span>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="/auditLog/prcssBlockLog">
                                                    <i class="fa fa-angle-right"></i>
                                                    <span>프로그램 차단 로그</span>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="/auditLog/pcChangeLog">
                                                    <i class="fa fa-angle-right"></i>
                                                    <span>하드웨어 변경 로그</span>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="/auditLog/unAuthLog">
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
                                <a href="javascript:;" data-toggle="dropdown" data-target="#notiLayer">
                                    <i class="fa fa-thumb-tack"></i>
                                    <span>알림</span>
                                </a>
                            </li>
                            <li>
                                <a href="javascript:;" data-toggle="dropdown" data-target="#settingsLayer">
                                    <!-- <i class="fa fa-gears"></i> -->
                                    <i class="fa fa-thumb-tack"></i>
                                    <span>환경설정</span>
                                </a>
                            </li>
                            <li>
                                <a href="http://192.168.0.210:8080/user/detail">
                                    <i class="fa fa-thumb-tack"></i>
                                    <span>${userSession.userid} 님</span>
                                </a>
                            </li>
                            <li>
                                <a href="http://192.168.0.210:8080/login/logout">
                                    <i class="fa fa-thumb-tack"></i>
                                    <span>로그아웃</span>
                                </a>
                            </li>
                        </ul>
                        <div id="notiLayer" class="dropup">
                            <section class="dropdown-menu on aside-md m-l-n" style="width:800px; height: 700px; margin-left: 110%;">
                                <section class="panel bg-white">
                                    <header class="panel-heading b-b b-light">Active chats</header>
                                    <div class="panel-body animated fadeInRight">
                                        <p class="text-sm">No active chats.</p>
                                        <p><a href="#" class="btn btn-sm btn-default">Start a chat</a></p>
                                    </div>
                                </section>
                            </section>
                        </div>

                        <div id="settingsLayer" class="dropup">
                            <section class="dropdown-menu on aside-md m-l-n" style="width:800px; height: 700px; margin-left: 110%;">
                                <section class="panel bg-white">
                                    <header class="panel-heading b-b b-light animated fadeInRight">Hamonize 서버 정보</header>
                                    <div class="panel-body animated fadeInRight">
                                        <!-- <p class="text-sm">No active chats.</p> -->
                                        <p><a href="#" class="btn btn-sm btn-default">Start a chat</a></p>
                                    </div>
                                </section>
                            </section>
                        </div>
                        
                        <a href="#nav" data-toggle="class:nav-xs" class="pull-right btn btn-sm btn-default btn-icon">
                            <i class="fa fa-angle-left text"></i>
                            <i class="fa fa-angle-right text-active"></i>
                        </a>
                      
                    </footer>
                </section>
            </aside>
            <!-- /.aside -->



            <!--  body start  -->
            <section id="content">
                <section class="vbox">
