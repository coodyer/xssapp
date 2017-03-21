<%@page import="com.xss.web.util.DateUtils"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%@ taglib prefix="fn" uri="/WEB-INF/tld/fn.tld"%>
<!doctype html>
<html class="no-js">
<head>
<jsp:include page="base/head.jsp" />
</head>
<body>
	<form class="am-form am-form-horizontal" method="post" id="dataform"
		name="searchForm">
		<div class="admin-content">
			<div class="am-cf am-padding">
				<div class="am-fl am-cf">
					<strong class="am-text-primary am-text-lg">源码管理</strong> / <small>包目录列表</small>
				</div>
			</div>
			<hr>
			<div class="am-panel am-panel-default">
				<div class="am-panel-hd am-cf"
					data-am-collapse="{target: '#collapse-panel-base'}">
					&nbsp; &nbsp;系统监控列表<span
						class="am-icon-chevron-down am-fr" style="display: none"></span>
				</div>
				<div id="collapse-panel-base" class="am-panel-bd am-collapse am-in">
					<table class="am-table am-table-bordered">
						<thead>
							<tr>
								<th>监控KEY</th>
								<th>操作</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty keys}">
								<tr>
									<td colspan="3" style="text-align:center ">暂无数据</td>
								</tr>
							</c:if>
							<c:forEach items="${keys }" var="key">
								<tr>
									<td>${key }</td>
									<td><a href="#">查看详情</a><a href="#">取消监控</a></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
			<div class="am-panel am-panel-default">
				<div class="am-panel-hd am-cf"
					data-am-collapse="{target: '#collapse-panel-base'}">
					&nbsp; &nbsp;当前目录：${currFile }<span
						class="am-icon-chevron-down am-fr" style="display: none"></span>
				</div>
				<div id="collapse-panel-base" class="am-panel-bd am-collapse am-in">
					<table class="am-table am-table-bordered">
						<thead>
							<tr>
								<th>文件列表</th>
								<th>文件大小</th>
								<th>创建时间</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><a href="?file=${parentFile}"> <img width="30px"
										src="${basePath }/assets/img/file.png" />上级目录
								</a></td>
								<td>-</td>
								<td>-</td>
							</tr>
							<c:if test="${empty files}">
								<tr>
									<td colspan="3" style="text-align:center ">暂无数据</td>
								</tr>
							</c:if>
							<c:forEach items="${files }" var="file">
								<tr>
									<td><c:if test="${file.type==0 }">
											<a href="?file=${file.path }"> <img width="30px"
												src="${basePath }/assets/img/file.png" />${fn:replace(file.path, currFile, '')}
											</a>
										</c:if> <c:if test="${file.type!=0 }">
											<a href="fileInfo.${defSuffix }?file=${file.path }"> <img
												width="30px"
												src="${basePath }/assets/img/${file.suffix=='class'?'java':'txt' }.png" />${fn:replace(file.path, currFile, '')}
											</a>
										</c:if></td>
									<td>${file.size==null?'-':file.size }</td>
									<td><fmt:formatDate value="${file.time }"
											pattern="yyyy-MM-dd HH:mm:ss" /></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</form>
</body>
<jsp:include page="base/js.jsp" />
<script>
	function delDate(id) {
		if (!confirm("数据删除后将无法恢复,是否继续操作?")) {
			return;
		}
		$.ajax({
			type : "POST",
			dataType : 'json',
			data : 'id=' + id,
			url : 'letterDel.${defSuffix}',
			timeout : 60000,
			success : function(json) {
				alert(json.msg);
				if (json.code == 0) {
					location.reload(true);
				}

			},
			error : function() {
				alert("系统繁忙");
			}
		});
	}
</script>
</html>
