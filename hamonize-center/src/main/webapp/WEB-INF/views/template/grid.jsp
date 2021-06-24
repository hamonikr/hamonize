<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- <script type="text/javascript" src="/js/template/jquery-1.11.0.js"></script> -->
<script type="text/javascript" src="/js/template/underscore.js"></script>
<script type="text/javascript" src="/js/template/backbone.js"></script>
<script type="text/javascript" src="/js/template/jquery.mockjax.js"></script>
<script type="text/javascript" src="/js/template/tui-code-snippet.js"></script>
<script type="text/javascript" src="/js/template/tui-pagination.js"></script>
<script type="text/javascript" src="/js/template/tui-grid.js"></script>
<script type="text/javascript">
$.mockjax({
    url: 'api/readData',
    responseTime: 0,
    response: function(settings) {
        var page = settings.data.page;
        var perPage = settings.data.perPage;
        var start = (page - 1) * perPage;
        var end = start + perPage;
        var data = gridData.slice(start, end);
        this.responseText = JSON.stringify({
            result: true,
            data: {
                contents: data,
                pagination: {
                    page: page,
                    totalCount: total
                }
            }
        });
    }
});
</script>