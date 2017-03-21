<%@page import="com.xss.web.util.DateUtils"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<!doctype html>
<html class="no-js">
<head>
<jsp:include page="base/head.jsp" />
</head>
<body>
	<form class="am-form am-form-horizontal" method="post" id="dataform">
		<div class="admin-content">
			<div class="am-cf am-padding">
				<div class="am-fl am-cf">
					<strong class="am-text-primary am-text-lg">系统管理</strong> / <small>添加后缀</small>
				</div>
			</div>
			<hr>
			<div class="am-panel am-panel-default">
				<div class="am-panel-hd am-cf"
					data-am-collapse="{target: '#collapse-panel-4'}">
					添加后缀<span class="am-icon-chevron-down am-fr"></span>
				</div>
				<div id="collapse-panel-4" class="am-panel-bd am-collapse am-in">
					<div class="am-g">
						<div class="am-u-sm-12 am-u-md-4 am-u-md-push-8"></div>
						<div class="am-u-sm-12 am-u-md-8 am-u-md-pull-4">

							<div class="am-form-group">
								<label for="user-name" class="am-u-sm-3 am-form-label"><small>网站后缀</small></label>
								<div class="am-u-sm-9">
								 <input type="text"
										id="user-name" name="suffix" datatype="*1-10"
										placeholder="请输入网站后缀" errormsg="请输入正确的网站后缀(1-10位)"
										sucmsg="输入正确" nullmsg="请输入网站后缀">
								</div>
							</div>
							<div class="am-form-group">
								<label for="user-QQ" class="am-u-sm-3 am-form-label"><small>是否开启</small></label>
								<div class="am-u-sm-9">
									<label class="am-checkbox-inline"> <input
										name="isOpen" id="private" type="radio" value="1"
										checked> <label style="color: #7A7D7E" for="private">开启</label>
									</label> <label class="am-checkbox-inline"> <input
										name="isOpen" id="public" type="radio" value="0">
										<label style="color: #7A7D7E" for="public">关闭</label>
									</label>
								</div>
							</div>
						</div>
					</div>
					<div class="am-form-group">
						<div class="am-u-sm-9 am-u-sm-push-3">
							<button class="am-btn am-btn-primary" type="submit">保存修改</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
<jsp:include page="base/js.jsp" />
<script>
	$("#dataform").Validform({
		label : ".lable",
		showAllError : false,
		postonce : true,
		tiptype : 3,
		beforeSubmit : function(curform) {
			saveSuffix();
			return false;
		}
	});
	function saveSuffix() {
		$.ajax({
			type : "POST",
			dataType : 'json',
			data : $("#dataform").serialize(),
			url : 'addSuffixRun.${defSuffix}',
			timeout : 60000,
			success : function(json) {
				alert(json.msg);
				if (json.code == 0) {
					location.href = "adminSuffix.${defSuffix}";
				}
			},
			error : function() {
				alert("系统繁忙");
			}
		});
	}
</script>
</html>
