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
<title>競爭力決策管理</title>

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

		var div_list = ['div_main','div_detail'];
		
		var competition_id = '<%= request.getParameter("competition_id") %>';
		var decision_proposal = "";

		$(document).keypress(function(e) {
			if(e.which == 13) {
		    	event.preventDefault();
		    }
		});
		
		$( document ).ready(function() {
			mainLoad();
			
			User();
		});
		
		$('#btn_detail_return').click(function(e){
			e.preventDefault();
			show_hide([true, false]);
		});
		
		function show_hide(show_hide_list) {
			for (var i = 0; i < div_list.length; i++) {
				if (show_hide_list[i]) {
					$("#" + div_list[i]).show();
				} else {
					$("#" + div_list[i]).hide();
				}
			}
		}
		
		function mainLoad() {
			$("#tbl_main").find('tbody').remove();
			$("#tbl_main").append('<tbody></tbody>');

			$("#tbl_main").html(
					'<tr>' + 
						'<th style="width:40px;"><label>項次</label></th>' + 
						'<th><label>國家</label></th>' + 
						'<th><label>城市</label></th>' + 
						'<th><label>群體決策商圈</label></th>' + 
						'<th><label>截止時間</label></th>' + 
						'<th><label>狀態</label></th>' + 
					'</tr>'
				);
			
			$.ajax({
				type : "POST",
				url : "caseCompetition.do",
				data : {
					action : "getCaseById",
					competition_id : competition_id
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					console.log(json_obj);
					
					$.each(json_obj, function(i, item) {

						country = item.country_country_name;
						city = item.city_city_name;
						var result = item.result;
						var temp = result.split(';');
						var bd_arr = [];
						var group_decision = "";
						
						if(result.length!=0){
							for (var j = 0; j < temp.length - 1; j++){
								bd_arr.push(temp[j].split(',')[0]);
							}
							
							var bd_list = "";
							for (var j = 0; j < bd_arr.length; j++){
								bd_list += (j + 1) + "." + bd_arr[j] + "&nbsp";
							};
							
							group_decision = bd_arr[0];
							$('#bd_list').html("商圈決策優先順序：" + bd_list);
						}
						var finish = ""
						if (item.isfinish == '1') {
							finish = '完成';
						} else {
							finish = '<span style="color:red;">決策中</span>';
						}
						
						$("#tbl_main").append('<tr>' + 
								'<td>' + (i + 1) + '</td>' + 
								'<td>' + country + '</td>' + 
								'<td>' + city + '</td>' + 
								'<td>' + group_decision + '</td>' + 
								'<td>' + item.ending_time + '</td>' + 
								'<td>' + finish + 
									'<input type="hidden" id="city_id_' + i + '" value="' + item.city_id + '">' + 
									'<input type="hidden" id="decision_proposal_' + i + '" value="' + item.v_decision_proposal + '">' + 
								'</td>' + 
								'</tr>');
						
					})
					
					$('[id^=checkbox-r]').click(function(e) {
						$("[id^=checkbox-r]").prop( "checked", false );
						$(this).prop( "checked", true );
					});
					
					var decision_proposal;
					
					$('#tbl_main').find('tr').each(function () {
						var row = $(this);
						var city_id = row.find('[id^=city_id_]').val();
						
						decision_proposal = row.find('[id^=decision_proposal_]').val();
						
					});
					
					if (decision_proposal != undefined) {
						$('#div_main .btn-row').prepend('<a href="' + decision_proposal + '" class="btn btn-exec btn-wide" id="detailspdfDoc" target="_blank">' + 
							'決策建議' +
							'</a>&nbsp' + 
							'<a class="btn btn-exec btn-wide" onclick="window.close();">' + 
							'返回清單' +
							'</a>');
					}else{
						$('#div_main .btn-row').prepend('<a class="btn btn-exec btn-wide" onclick="window.close();">返回清單</a>');							
					}
				}
			});
			show_hide([true, false]);
			
		}
		
		function User() {
			
			console.log('user');
			
			$("#div_detail > form > div > div:first").find('h4').remove();
			
			$("#tbl_user").find('tbody').remove();
			$("#tbl_user").append('<tbody></tbody>');
			
			$("#tbl_user").append(
					'<tr>' + 
					'<th><label>人員</label></th>' + 
					'<th><label>重要性</label></th>' + 
					'<th><label>查看成員評估</label></th>' + 
					'<th><label>評估內容</label></th>' + 
					'</tr>'					
			);
		
			$.ajax({
				type : "POST",
				url : "caseCompetition.do",
				data : {
					action : "getEvaluate",
					competition_id : competition_id
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					console.log(json_obj);

					var findUser = false;
					var auth = 0;

					user_count = json_obj.length;

					$.each(json_obj, function(i, item) {
						var content = ['可', '不可'];
						var privilege = content[item.user_authority - 1] == undefined? "無":content[item.user_authority - 1];
						
						$("#tbl_user").append('<tr><td><label>' + json_obj[i].user_name + '</label></td>' + 
								'<td>' + (item.weight * 20) + '%</td>' +
								'<td>' + privilege + '</td>' +
								'<td><button name="' + item.competition_id + '" value="'+ item.user_id + '" class="btn-chkevaluate btn btn-wide btn-primary">查看評估內容</button></td>' + 
								'</tr>');
						

						if (item.user_id == '<%=user_id%>'){
							console.log("authority:" + item.user_authority);
							
							findUser = true;
							auth = item.user_authority;
						}
					});
					
					if ('1' != '<%=role%>') {
						if (findUser) {
							if (auth != 1) {
								$('#tbl_user button')
									.prop('disabled', true)
									.removeClass("btn-primary")
									.addClass("btn-gray");
							}
						} else {
							$('#tbl_user button')
								.prop('disabled', true)
								.removeClass("btn-primary")
								.addClass("btn-gray");
						}					
					}
					
					$(".btn-chkevaluate").click(function(e){
						e.preventDefault();
						
						var comp_id = $(this).prop("name");
						var user_id = $(this).prop("value");
						showEvaluate(comp_id, user_id);

						show_hide([false, true]);
					});

				}
			});
		}
		
		function showEvaluate(comp_id, user_id) {
			console.log("comp_id:" + comp_id);
			
			$("#div_detail > form > div > div:first").find('div').remove();
			$("#div_detail > form > div > div:first").find('h4').remove();
			
			$.ajax({
				type : "POST",
				url : "caseCompetition.do",
				data : {
					action : "getEvaluateDetail",
					competition_id : comp_id,
					user_id : user_id
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					console.log('detail');
					console.log(json_obj);
					
					var level1_count = 0;
					var level2_count_arr = [];
					var level1_content_arr = [];
					var level2_content_arr = [];
					var level2_point_arr = [];
 					var user_name = "";

					$.each(json_obj, function(i, item) {
						level1_count = item.evaluate_no;
						level2_count_arr = item.evaluate_1_no.split(','); 
						level1_content_arr = item.evaluate.split(',');
						
						var temp = item.evaluate_1.split(';');
						for (var j = 0; j < temp.length; j++){
							level2_content_arr.push(temp[j].split(','));
						}
						
						var temp = item.evaluate_1_point.split(';');
						for (var j = 0; j < temp.length; j++){
							level2_point_arr.push(temp[j].split(','));
						}
						console.log(level2_point_arr);
						user_name = item.user_name;
					});
					
					$("#div_detail > form > div > div:first").append('<h4>參與人員：' + user_name + '</h4>');	
					
					for (var i = 1; i <= level1_count; i++) {
						var temp = "";
						
						for (var j = 0; j < level2_count_arr[i-1]; j++) {
							var radio_list = "";
							for (var k = 1; k <= 5; k++) {
								radio_list += '<input type="radio" id="rdo_eval_' + i + '_' + j + '_' + k + '" name="eval_' + i + '_' + j + '" value="' + k + '" disabled>' + 
									'<label for="rdo_eval_' + i + '_' + j + '_' + k + '">' + 
									'<span class="form-label">' + k + '</span>' + 
									'</label>';
							}
							temp += '<tr><td style="width:300px">' + level2_content_arr[i-1][j] + '</td><td>' + radio_list + '</td></tr>';
						}
						
						var tempDiv = "";
						tempDiv = '<div id="div_evaluate_step2_' + i + '" class="result-table-wrap">' +
							'<table id="tbl_evaluate_step2_' + i + '" class="result-table">' +
							'<tbody>' + temp + '</tbody>' +
							'</table>' + 
							'</div>';
						
						$("#div_detail > form > div > div:first").append('<h4>『' + level1_content_arr[i-1] + '因子』問卷</h4>');	
						$("#div_detail > form > div > div:first").append(tempDiv);
					}
					
					for (var i = 1; i <= level1_count; i++) {
						for (var j = 0; j < level2_count_arr[i-1]; j++) {
							console.log(level2_point_arr[i-1][j]);
							var temp = level2_point_arr[i-1][j];
							$('#rdo_eval_' + i + '_' + j + '_' + temp).prop('checked', true);
						}
						
					}
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
							<h2>競爭力決策管理</h2>
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

			<div id="div_detail" class="form-row" >
				<form class="form-row customDivMain">
					<div class="search-result-wrap">
						<div class="form-row">
						</div>
						
						<div class="result-table-wrap">
							<table id="tbl_evaluate" class="result-table">
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