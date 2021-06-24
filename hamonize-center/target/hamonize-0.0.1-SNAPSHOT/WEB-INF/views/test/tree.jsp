<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
  <link href="http://twitter.github.com/bootstrap/assets/js/google-code-prettify/prettify.css" rel="stylesheet">
  <link href="http://twitter.github.com/bootstrap/assets/css/bootstrap.css" rel="stylesheet">
  <link href="http://twitter.github.com/bootstrap/assets/css/bootstrap-responsive.css" rel="stylesheet">
  <link rel="stylesheet/less" href="/css/bootstrap-checkbox-tree.less" type="text/css" />

  <script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
  <script type="text/javascript" src="/js/bootstrap-checkbox-tree.js"></script>
  <script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/less.js/1.3.0/less-1.3.0.min.js"></script>
  <script type="text/javascript">
  jQuery(document).ready(function(){
    var cbTree = $('.checkbox-tree').checkboxTree({
      checkChildren : true,
      singleBranchOpen: true,
      openBranches: ['.liverpool', '.chelsea']
    });
    $('#tree-expand').on('click', function(e) {
      cbTree.expandAll();
    });
    $('#tree-collapse').on('click', function(e) {
      cbTree.collapseAll();
    });
    $('#tree-default').on('click', function(e) {
      cbTree.defaultExpand();
    });
    $('#tree-select-all').on('click', function(e) {
      cbTree.checkAll();
    });
    $('#tree-deselect-all').on('click', function(e) {
      cbTree.uncheckAll();
    });
    $('.checkbox-tree').on('checkboxTicked', function(e) {
      var checkedCbs = $(e.currentTarget).find("input[type='checkbox']:checked");
      console.log('checkbox tick', checkedCbs.length);
    });
  });
  </script>


  <title>Collapsible Checkbox Tree example</title>
</head>

<body>
  <div class="">
    <div class="">
      <div class="">
        <h2>Example</h2>

        <form action="" method="post" class="well">
          <ul class="checkbox-tree root">
            <li>
              <input type="checkbox" name="" checked="checked" />
              <label>Manchester United</label>
              <ul class="manu">
                <li>
                  <input type="checkbox" name="" />
                  <label>Ryan Giggs</label>
                </li>
                <li>
                  <input type="checkbox" name="" />
                  <label>Paul Scholes</label>
                </li>
                <li>
                  <input type="checkbox" name="" />
                  <label>Wayne Rooney</label>
                </li>
              </ul>
            </li>
            <li>
              <input type="checkbox" name="" />
              <label>Chelsea</label>
              <ul class="chelsea">
                <li>
              <input type="checkbox" name="" />
              <label>Liverpool</label>
              <ul class="liverpool">
                <li>
                  <input type="checkbox" name="" />
                  <label>Fernando Torres</label>
                </li>
                <li>
                  <input type="checkbox" name="" />
	              <label>Liverpool</label>
	              <ul class="liverpool">
	                <li>
	                  <input type="checkbox" name="" />
	                  <label>Fernando Torres</label>
	                </li>
	                <li>
	                  <input type="checkbox" name="" />
	                  <label>Steven Gerrard</label>
	                </li>
	              </ul>
                </li>
              </ul>
            
                </li>
                <li>
                  <input type="checkbox" name="" />
                  <label>Frank Lampard</label>
                </li>
                <li>
                  <input type="checkbox" name="" />
                  <label>Didier Drogba</label>
                </li>
                <li>
                  <input type="checkbox" name="" />
                  <label>John Terry</label>
                </li>
              </ul>
            </li>
          </ul>
        </form>

        <div class="btn-group" data-toggle="buttons-radio">
          <button id="tree-expand" class="btn">Expand All</button>
          <button id="tree-collapse" class="btn">Collapse All</button>
          <button id="tree-default" class="btn">Default</button>
        </div>
        <p></p>
        <div class="btn-group">
          <button id="tree-select-all" class="btn">Select all</button>
          <button id="tree-deselect-all" class="btn">Deselect all</button>
        </div>

      </div>
    </div>

    <hr>
    <div class="row">
      <div class="span12">
        <h2>Usage</h2>
        <pre class='prettyprint'>
          $('.checkbox-tree').checkboxTree({
            checkChildren : true
          });
        </pre>
      </div>
    </div>
  </div>
</body>
</html>