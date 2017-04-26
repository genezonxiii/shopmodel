<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF8">

	<link rel="Shortcut Icon" type="image/x-icon" href="./images/cdri-logo.gif" />

	<link rel="stylesheet" href="css/jquery-ui.min.css">
	<link rel="stylesheet" href="css/font-awesome.min.css">
	<link rel="stylesheet" href="css/styles.css">

	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<script type="text/javascript" src="js/jquery-ui.min.js"></script>
	<script type="text/javascript" src="js/jquery.validate.min.js"></script>
	<script type="text/javascript" src="js/additional-methods.min.js"></script>
	<script type="text/javascript" src="js/messages_zh_TW.min.js"></script>
<%
	String group_id = (String) session.getAttribute("group_id");
	String user_id = (String) session.getAttribute("user_id");
	Integer role = (Integer) session.getAttribute("role");
%>
<title>新產品風向評估</title>

<style>
.content-wrap {
    /*background: #D6F6FF;*/
    background-image: linear-gradient(#fff,#ccc);
    box-sizing: border-box;
    float: left;
    margin-top: 15px;
    padding-bottom: 60px;
    height: calc(100vh - 15px);
    width: 100%;
    overflow: scroll;
}
.search-result-wrap {
    padding: 0px 30px 20px 20px;
    margin-bottom: 60px;
}
.form-row {
    margin: 5px 0;
    zoom: 1;
}
</style>

<script>
	
	$(function() {

		var forecast_id = '<%= request.getParameter("forecast_id") %>';
		
		$(document).keypress(function(e) {
			if(e.which == 13) {
		    	event.preventDefault();
		    }
		});
		
		$( document ).ready(function() {
			User();
		});
		
		$('#btn_detail_return').click(function(e){
			e.preventDefault();
			
			$('#div_main').show();
			$('#div_detail').hide();
		});
		
		function User() {
			$("#div_detail > form > div > div:first").find('h4').remove();
			
			$("#tbl_user").find('tbody').remove();
			$("#tbl_user").append('<tbody></tbody>');
			
			$("#tbl_user").append(
					'<tr>' + 
					'<th><label>人員</label></th>' + 
					'<th><label>重要性</label></th>' + 
					'<th><label>評估內容</label></th>' + 
					'</tr>'					
			);
		
			$.ajax({
				type : "POST",
				url : "productForecastPoint.do",
				data : {
					action : "getPoint",
					forecast_id : forecast_id
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					
					user_count = json_obj.length;

					$.each(json_obj, function(i, item) {
						$("#tbl_user").append('<tr><td><label>' + json_obj[i].v_user_name + '</label></td>' + 
								'<td>' + (json_obj[i].weight * 10) + '%</td>' +
								'<td><button name="' + json_obj[i].forecast_id + '" value="'+ json_obj[i].user_id + '" class="btn-chkpoint btn btn-wide btn-primary">查看評估內容</button></td>' + 
								'</tr>');
					});
					
					$('#div_main .btn-row').prepend('<a class="btn btn-exec btn-wide" onclick="window.close();">' + 
							'返回清單' +
							'</a>');
					
					$(".btn-chkpoint").click(function(e){
						e.preventDefault();
						
						var forecast_id = $(this).prop("name");
						var user_id = $(this).prop("value");
						
						showForecast(forecast_id, user_id);
						
						$('#div_main').hide();
						$('#div_detail').show();
					});

				}
			});
		}
		
		function showForecast(forecast_id, user_id) {
			$("#div_detail > form > div > div:first").find('div').remove();
			$("#div_detail > form > div > div:first").find('h4').remove();
			
			$("#div_detail > form > div > div:first").find('tbody').remove();
			
			$.ajax({
				type : "POST",
				url : "productForecastPoint.do",
				data : {
					action : "getPointDetail",
					forecast_id : forecast_id,
					user_id : user_id
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					
					$("#div_detail > form > div > div:first").prepend('<h4>參與人員：' + json_obj[0].v_user_name + '</h4>');
					
					$.each(json_obj, function(i, item) {
						var function_name_arr = [];
						var nfunction_name_arr = [];
						var service_name_arr = [];
						
						var function_point_arr = [];
						var nfunction_point_arr = [];
						var service_point_arr = [];
						
						function_name_arr = item.v_function_name == ""? []:item.v_function_name.split(',');
						nfunction_name_arr = item.v_nfunction_name == ""? []:item.v_nfunction_name.split(',');
						service_name_arr = item.v_service_name == ""? []:item.v_service_name.split(',');
						
						function_point_arr = item.function_point.split(',');
						nfunction_point_arr = item.nfunction_point.split(',');
						service_point_arr = item.service_point.split(',');
						
						$("#function-test").append('<tbody><tr><th>名稱</th><th>分數</th></tr></tbody>');
						$.each( function_name_arr, function( index, value ){
							var temp = "";
							if (function_point_arr[index] != undefined ) {
								temp = function_point_arr[index];
							}
						
							$("#function-test").append('<tr><td>' + value + '</td><td>' + '<input type="text" name="function-test-' + index + '" value="' + temp + '" readonly>' + '</td></tr>');
						});
						
						$("#nfunction-test").append('<tbody><tr><th>名稱</th><th>分數</th></tr></tbody>');
						$.each( nfunction_name_arr, function( index, value ){
							var temp = "";
							if (nfunction_point_arr[index] != undefined ) {
								temp = nfunction_point_arr[index];
							}
							$("#nfunction-test").append('<tr><td>' + value + '</td><td>' + '<input type="text" name="nfunction-test-' + index + '" value="' + temp + '" readonly>' + '</td></tr>');
						});
						
						$("#service-test").append('<tbody><tr><th>名稱</th><th>分數</th></tr></tbody>');
						$.each( service_name_arr, function( index, value ){
							var temp = "";
							if (service_point_arr[index] != undefined ) {
								temp = service_point_arr[index];
							}
							$("#service-test").append('<tr><td>' + value + '</td><td>' + '<input type="text" name="serivce-test-' + index + '" value="' + temp + '" readonly>' + '</td></tr>');
						});
					});
					
				}
			});
		}
	});
</script>
</head>
<body>
	<div class="page-wrapper" >

		<!-- content-wrap -->
		<div class="content-wrap">
			<div id="caseAlert"></div>
			<div id="resultModal" class="result-table-wrap"></div>
		
			<div id="div_main" class="form-row" >
				<form class="form-row customDivMain">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>新產品風向評估</h2>
						</div>
						
						<div class="result-table-wrap">
							<table id="tbl_main" class="result-table">
								<tbody></tbody>
							</table>
							<br/>
							<h2 id="bd_list"></h2>
							<table id="tbl_user" class="result-table">
								<tbody></tbody>
							</table>
						</div>
												
						<div class="btn-row">
						</div>
					</div>
				</form>
			</div>

			<div id="div_detail" class="form-row" hidden="true">
				<form class="form-row customDivTest">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2 id="product_name_test"></h2>
							<input type="hidden" id="forecast_id_test"></input>
							<input type="hidden" id="user_id_test"></input>
						
						
							<table id="function-test" class="result-table">
								<div class="form-row">
									<h2>功能或產品性項目</h2>
								</div>
								<tr>
									<th>名稱</th>
									<th>分數</th>
								</tr>
								<tbody></tbody>
							</table>
				
							<div class="form-row">
								<h2>非功能或產品性項目</h2>
							</div>
				
							<table id="nfunction-test" class="result-table">
								<tr>
									<th>名稱</th>
									<th>分數</th>
								</tr>
								<tbody></tbody>
							</table>
				
							<div class="form-row">
								<h2>服務性項目</h2>
							</div>
				
							<table id="service-test" class="result-table">
								<tr>
									<th>名稱</th>
									<th>分數</th>
								</tr>
								<tbody></tbody>
							</table>
						</div>
						
						<div class="btn-row">
							<button id="btn_detail_return" class="btn btn-exec btn-wide" >返回</button>
						</div>
					</div>
					
					
				</form>
			</div>
		
		</div>
		<!-- content-wrap -->
	</div>
</body>
</html>