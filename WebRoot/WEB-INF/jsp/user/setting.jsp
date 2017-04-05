<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<html>
<head lang="en">
<jsp:include page="../base/head.jsp" />
</head>
<body style="text-align:center;">
	<div style="margin:0px auto">
		<jsp:include page="../base/nav.jsp" />
		<div class="am-container">
			<jsp:include page="../base/left.jsp" />
			<div class="am-u-sm-12 am-u-md-12 am-u-lg-9">
				<div class="am-g">
					<div class="am-u-md-12">
						<div class="am-panel am-panel-default">
							<div class="am-panel-bd">
								<form action="" class="am-form" id="dataform" data-am-validator="" novalidate="novalidate">
									<input type="hidden" value="name=&quot;id&quot;">
									<fieldset>
										<legend><small>个人设置</small></legend>
										<div class="am-form-group am-form-success">
											<label for="doc-vld-name-2" class="left"><small>用户邮箱：</small></label>
											 <input type="text" id="doc-vld-name-2" name="email" datatype="*1-48" errormsg="请输入正确的邮箱" sucmsg="输入正确" nullmsg="请输入项目名" placeholder="输入项目名称（至少 1 个字符）" value="${curr_login_user.email}" class="Validform_error am-field-valid">
										</div>
										<div class="am-form-group">
											<label for="doc-vld-ta-2"  class="left"><small>用户手机：</small></label>
											 <input type="text" id="doc-vld-name-2" name="mobile" placeholder="请输入手机号" datatype="m" errormsg="请输入正确的手机号" sucmsg="输入正确" nullmsg="请输入手机号"  class="Validform_error am-field-valid" value="${curr_login_user.mobile}">
										</div>
										<div class="am-form-group" ><br></div>
										<div class="am-form-group" >
											<button type="submit" name="" class="am-btn am-btn-success am-btn-xs">
											&nbsp;保 存&nbsp;
										</button>
										</div>
									</fieldset>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../base/foot.jsp" />
	<jsp:include page="../base/js.jsp" />
</body>
<script>
	$("#dataform").Validform({
		label : ".lable",
		showAllError : false,
		postonce : true,
		tiptype : function(msg, o, cssctl) {
			var objtip = $("#msg");
			cssctl(objtip, o.type);
			objtip.text(msg);
		},
		beforeSubmit : function(curform) {
			submitForm();
			return false;
		}
	});
	function submitForm() {
		$.ajax({
			type : "POST",
			dataType : 'json',
			data : $("#dataform").serialize(),
			url : 'saveUserInfo.${defSuffix}',
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
