<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./template/head.jsp" %>
<%@ include file="./template/left.jsp" %>



<section class="scrollable">
	<section class="hbox stretch">
		<!-- body left Start  -->
		<%@ include file="./template/orgTree.jsp" %>
		<!-- body left End  -->


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
									<p>Wellcome <a href="#" class="text-info">@Drew Wllon</a> and play this web
										application
										template, have fun1 </p>
									<small class="block text-muted"><i class="fa fa-clock-o"></i> 2 minuts ago</small>
								</li>
								<li class="list-group-item">
									<p>Morbi nec <a href="#" class="text-info">@Jonathan George</a> nunc condimentum
										ipsum
										dolor sit amet, consectetur</p>
									<small class="block text-muted"><i class="fa fa-clock-o"></i> 1 hour ago</small>
								</li>
								<li class="list-group-item">
									<p><a href="#" class="text-info">@Josh Long</a> Vestibulum ullamcorper sodales nisi
										nec
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




<%@ include file="./template/footer.jsp" %>