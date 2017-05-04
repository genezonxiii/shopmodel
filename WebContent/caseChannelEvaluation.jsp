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
	<script type="text/javascript" src="js/common.js"></script>
<%
	String group_id = (String) session.getAttribute("group_id");
	String user_id = (String) session.getAttribute("user_id");
	Integer role = (Integer) session.getAttribute("role");
	String menu = (String) request.getSession().getAttribute("menu"); 
	String privilege = (String) request.getSession().getAttribute("privilege"); 
%>
<title>通路決策評估</title>

<script>
	
	$(function() {
		
		var div_list = ['div_list','div_main','div_evaluate_step1','div_evaluate_step2','div_evaluate_step3'];
		var user_count = 0;
		var channel_name_arr_count = 0;
		var level1_count = 0;
		var level2_count_arr = [];
		var level1_content_arr = [];
		var level2_content_arr = [];
		var country = "", city = "", bcircle_name="";
		var channel_name_arr = [];
		
		var show_table_title = false;
		var show_table_title_count = 0;
		
		var step2_index = 1;
		var step2_arr = [];
		
		$(document).keypress(function(e) {
			if(e.which == 13) {
		    	event.preventDefault();
		    }
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
		

		$("#btn_list_view").click(function(e){
			e.preventDefault();

			var channel_id = "";
			var auth = "";
			$('#tbl_list>tbody').find('tr').each(function () {
				var row = $(this);
				console.log(row);
				if ( row.find('input[type="checkbox"]').is(':checked') ) {
					console.log("checked");
					console.log(row.data("evaluate"));
					
					var evaluate = row.data("evaluate");
					if (evaluate) {
						auth = evaluate.user_authority;
					} else {
						auth = "";
					}
					
					channel_id = row.find('[id^=channel_id_]').val();
				}
			});
			
			if (channel_id){
				console.log(auth);
				if (auth == "1" || auth == "2" || "1" == '<%=role%>'){
					window.open('caseChannelUserDetail.jsp?channel_id=' + channel_id, '', 'width=700,height=500,directories=no,location=no,menubar=no,scrollbars=yes,status=no,toolbar=no,resizable=no,left=250,top=150,screenX=0,screenY=0');					
				} else {
					warningMsg('提醒', '請確認您的權限');
				}
			} else {
				warningMsg('提醒', '請選擇一筆資料');
			}
		});
		
		$("#btn_list_evaluate").click(function(e) {
			e.preventDefault();
			
			getCaseNotFinish();

			show_hide([false, true, false, false, false]);
		});
		
		$("#btn_main_evaluate").click(function(e) {
			e.preventDefault();
			$('#div_evaluate_step1_1').remove();
			var temp = "";
			for (var i = 1; i <= level1_count; i++) {
				var temp_text = "";
				
				
				temp += '<tr><td>' + level1_content_arr[i-1] + '：' + 
				'<input type="text" id="txt_eval_' + i + '_point" name="txt_eval_' + i + '_point">' + 
				'</td><td>' + 
				'理由：<input type="text" id="txt_eval_' + i + '_reason" name="txt_eval_' + i + '_reason">' + 
				'</td></tr>';
			}
			
			var tempDiv = "";
			tempDiv = '<div id="div_evaluate_step1_1" class="result-table-wrap">' +
				'<table id="tbl_evaluate_step1_1" class="result-table">' +
				'<tbody>' + temp + '</tbody>' +
				'</table>' + 
				'</div>';
			
			$("#div_evaluate_step1 > form > div > div:first").append(tempDiv);
			
			$( ".custom_step1" ).validate();
			$("[name^=txt_eval_]").each(function(){
				$(this).rules("add", {
				  	required: true
				});
		   	});
			show_hide([false, false, true, false, false]);
		});
		
		$("#btn_step1_default").click(function(e) {
			e.preventDefault();
			var number = 1;
			for (var i = 1; i <= level1_count; i++) {
				number = 1 + Math.floor(Math.random() * 5);
				$('#txt_eval_' + i + '_point').val(number);
				$('#txt_eval_' + i + '_reason').val("理由"+number);
			}
			
		});
		
		$("#btn_step2_default").click(function(e) {
			e.preventDefault();
			
			var number = 1;
				
			for (var i = 0; i < level2_count_arr[step2_index-1]; i++) {
				number = 1 + Math.floor(Math.random() * 5);

				$('#rdo_eval_' + step2_index + '_' + i + '_' + number ).prop('checked', true);
				
			}
		});
		
		$("#btn_step1_next").click(function(e) {
			e.preventDefault();

 			if (!$('.custom_step1').valid()) {
 				warningMsg('警告', '尚有資料未填寫完畢');
				return;
 			}
 			
			$("#div_evaluate_step2 > form > div > div:first").find('div').remove();
			$("#div_evaluate_step2 > form > div > div:first").find('h4').remove();
			
			step2_arr = [];
			
			step2_arr.push('div_step1');
			for (var i = 1; i <= level1_count; i++) {
				var temp = "";
				
				for (var j = 0; j < level2_count_arr[i-1]; j++) {
					var radio_list = "";
					for (var k = 1; k <= 5; k++) {
						radio_list += '<input type="radio" id="rdo_eval_' + i + '_' + j + '_' + k + '" name="eval_' + i + '_' + j + '" value="' + k + '">' + 
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
				
				$("#div_evaluate_step2 > form > div > div:first").append('<h4 class="div_evaluate_step2_' + i + '">' + i + '、請填寫『' + level1_content_arr[i-1] + '』重要性質(1至5)</h4>');	
				$("#div_evaluate_step2 > form > div > div:first").append(tempDiv);
				
				step2_arr.push('evaluate_step2_' + i);
			}
			
			step2_index = 1;
			
			$("[id^=div_evaluate_step2_]").hide();
			$('#div_' + step2_arr[step2_index]).show();
			$('*[class^="div_evaluate_step2_"]').hide();
			$('.div_evaluate_step2_' + step2_index).show();

			$( ".custom_step2" ).validate({
			    errorPlacement: function(error, element) {
			        element.before(error);
			  	}
		  	});
			
			$("[name^=eval_]").each(function(){
				$(this).rules("add", {
				  	required: true
				});
		   	});
			
			show_hide([false, false, false, true, false]);
		});
		
		$("#btn_step2_prev").click(function(e) {
			e.preventDefault();
			
			step2_index--;
			
			if (step2_index != 0) {
				// div_evaluate_step2_1
				// "[id^=cmb-1-r" + rowCount + "]"
				console.log('#tbl_' + step2_arr[step2_index]);
				$("[id^=div_evaluate_step2_]").hide();
				$('#div_' + step2_arr[step2_index]).show();
				$('*[class^="div_evaluate_step2_"]').hide();
				$('.div_evaluate_step2_' + step2_index).show();
			} else {
				show_hide([false, false, true, false, false]); 
			}
		});
		
		$("#btn_step2_next").click(function(e) {
			e.preventDefault();
			
 			if (!$('.custom_step2').valid()) {
 				warningMsg('警告', '尚有資料未填寫完畢');
				return;
 			}			
			step2_index++;
			
			if (step2_index < step2_arr.length ) {
				$("[id^=div_evaluate_step2_]").hide();
				$('#div_' + step2_arr[step2_index]).show();
				$('*[class^="div_evaluate_step2_"]').hide();
				$('.div_evaluate_step2_' + step2_index).show();
			} else {
				
				var titleSize = channel_name_arr.length + 1;
				titleSize = 100/titleSize;
				
				var tempDiv = "";
				var temp_text = "";
				
				for (var k = 0; k < channel_name_arr_count; k++) {
					temp_text += '<th style="width:'+titleSize+'%">' + channel_name_arr[k] + '</th>';
				}
				
				if(temp_text.length!=0){
					show_table_title = true;
				}
				
				if(show_table_title){
					
					tempDiv = '<div id="div_evaluate_step3" class="result-table-wrap">' +
					'<table id="tbl_evaluate_step3" class="result-table">' +
					'<tbody>' + 
					'<tr>' + 
					'<th style="width:'+titleSize+'%">因子</th>' +
					temp_text + 
					'</tr>' +
					'</tbody>' +
					'</table>' + 
					'</div>';					
				}
				if(show_table_title_count === 0){
					$("#div_evaluate_step3 > form > div > div:first").append(tempDiv);
				}
				
				for (var i = 1; i <= level1_count; i++) {
					var temp = "";
					
					for (var j = 0; j < level2_count_arr[i-1]; j++) {
						var temp_text = "";
						for (var k = 0; k < channel_name_arr_count; k++) {
							$('#txt_eval_ratio_' + i + '_' + j + '_' + k).remove();
							
							temp_text += '<td style="width:'+titleSize+'%"><input type="text" id="txt_eval_ratio_' + i + '_' + j + '_' + k + '" name="txt_eval_ratio_' + i + '_' + j + '_' + k + '"></td>'
						}
						
						temp += '<tr>' + 
							'<td style="width:'+titleSize+'%">' + i + '.' + (j + 1) + ' ' + level2_content_arr[i-1][j] + '</td>' +
							temp_text + 
							'</tr>';
					}
					
					var tempDiv = "";
					tempDiv = '<div id="div_evaluate_step2_' + i + '" class="result-table-wrap">' +
						'<table id="tbl_evaluate_step2_' + i + '" class="result-table">' +
						'<tbody>' + temp + '</tbody>' +
						'</table>' + 
						'</div>';
						
					$("#div_evaluate_step3 > form > div > div:first").append(tempDiv);
				}
				$( ".custom_step3" ).validate({
				    errorPlacement: function(error, element) {
				        element.before(error);
				  	}
			  	});
				
				$("[name^=txt_eval_ratio_]").each(function(){
					$(this).rules("add", {
					  	required: true
					});
			   	});				
				show_hide([false, false, false, false, true]);  
			}
		});
		
		$("#btn_step3_default").click(function(e) {
			e.preventDefault();
			var number = 1;
			for (var i = 1; i <= level1_count; i++) {
				for (var j = 0; j < level2_count_arr[i-1]; j++) {
					number = 1 + Math.floor(Math.random() * 5);
					for (var k = 0; k < channel_name_arr_count; k++) {
						$('#txt_eval_ratio_' + i + '_' + j + '_' + k).val(number);
					}
					
				}
			}
		});
				
		$("#btn_step3_send").click(function(e) {
			e.preventDefault();

 			if (!$('.custom_step3').valid()) {
 				warningMsg('警告', '尚有資料未填寫完畢');
				return;
 			}
 			
			confirm();
		});
		
		$("#btn_step3_reset").click(function(e) {
			e.preventDefault();
			
			show_table_title_count = 1;
			show_hide([false, true, false, false, false]);
		});
		
		$( document ).ready(function() {
			mainLoad();
		});
		
		function mainLoad() {
			setTblList();
			
			show_hide([true, false, false, false, false]);
		}
		

		function setTblList() {
			$("#tbl_list").find('tbody').remove();
			$("#tbl_list").append('<tbody></tbody>');

			$("#tbl_list").html(
					'<tr>' + 
						'<th style="width:40px;"><label>選取</label></th>' +
						'<th style="width:40px;"><label>項次</label></th>' + 
						'<th><label>國家</label></th>' + 
						'<th><label>城市</label></th>' + 
						'<th><label>最高分通路</label></th>' + 
						'<th><label>完成時間</label></th>' + 
						'<th><label>狀態</label></th>' + 
					'</tr>'
				);
			
			$.ajax({
				type : "POST",
				url : "caseChannel.do",
				data : {
					action : "getCase"
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					
					$.each(json_obj, function(i, item) {

						country = item.v_country;
						city = item.v_city_name;
						
						var finish = ""
						if (item.isfinish == '1') {
							finish = '完成';
						} else {
							finish = '<span style="color:red;">決策中</span>';
						}
						
						$("#tbl_list").append('<tr>' + 
								'<td><input type="checkbox" name="tbl_main_checkbox" id="checkbox-r' + i + '"/><label for="checkbox-r' + i + '"></label></td>' + 
								'<td>' + (i + 1) + '</td>' + 
								'<td>' + item.country_country_name + '</td>' + 
								'<td>' + item.city_city_name + '</td>' + 
								'<td>' + item.result + '</td>' + 
								'<td>' + item.ending_time + '</td>' + 
								'<td>' + finish + 
									'<input type="hidden" id="city_id_' + i + '" value="' + item.city_id + '">' + 
									'<input type="hidden" id="channel_id_' + i + '" value="' + item.channel_id + '">' + 
								'</td>' + 
								'</tr>');
						


						//取得權限
						$.ajax({
							type : "POST",
							url : "caseChannel.do",
							data : {
								action : "getEvaluate",
								channel_id : item.channel_id
							},
							success : function(result) {
								var evaluate_obj = $.parseJSON(result);
								console.log("getEvaluate:" + item.case_id);
								console.log('<%=user_id%>');
								console.log(evaluate_obj);
								$.each(evaluate_obj, function(j, evaluate_item) {
									if (evaluate_item.user_id == '<%=user_id%>'){
										$("#tbl_list>tbody").find("tr:eq(" + (i+1) + ")").data("evaluate", evaluate_item);
									}
								});
							}
						});
						
						
						$("#tbl_list").find("tr:eq(" + i + ")").data("case", item);
						
						
					})
					
					$('[id^=checkbox-r]').click(function(e) {
						$("[id^=checkbox-r]").prop( "checked", false );
						$(this).prop( "checked", true );
					});
					
					$('#tbl_list').find('tr').each(function () {
						var row = $(this);
						var city_id = row.find('[id^=city_id_]').val();
						
					});
				}
			});						
		}
		
		
		function getCaseNotFinish() {
			$.ajax({
				type : "POST",
				url : "caseChannelEvaluation.do",
				data : {
					action : "getCaseChannelNotFinish"
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					console.log(json_obj);
					
					$.each(json_obj, function(i, item) {
						country = item.country_country_name;
						city = item.city_city_name;
						bcircle_name = item.bcircle_bcircle_name;
						channel_name_arr = item.channel_name.split(",");;
						channel_name_arr_count = channel_name_arr.length
						console.log("channel_name_arr:");
						console.log(channel_name_arr);
						
						level1_count = item.evaluate_no;
						level2_count_arr = item.evaluate_1_no.split(',');
						level1_content_arr = item.evaluate.split(',');
						
						var temp = item.evaluate_1.split(';');
						for (var j = 0; j < temp.length; j++){
							level2_content_arr.push(temp[j].split(','));
						}
						
						$('#channel_id').val(item.channel_id);
						console.log("Channel ID set :" + item.channel_id);
						console.log("Channel ID get :" + $('#channel_id').val());
						
						console.log("level1_count: "+level1_count);
						console.log("level2_count_arr: "+level2_count_arr);
						console.log("level1_content_arr: "+level1_content_arr);
						console.log(level2_content_arr);
						
						$("#tbl_main").html(
								'<tr><td style="width:150px">國家：</td><td>' + country + '</td></tr>' + 
								'<tr><td style="width:150px">城市：</td><td>' + city + '</td></tr>' + 
								'<tr><td style="width:150px">商圈：</td><td>' + bcircle_name + '</td></tr>'
						);
					})
					
				}
			});
		}
		
		function confirm() {
			
			var eval_point = "", 
			eval_reason = "", 
			eval_1_point = "",
			eval_ratio = "";
		
			for (var i = 1; i <= level1_count; i++) {
				console.log('point:' + i + ' - ' + $('#txt_eval_' + i + '_point').val());
				console.log('reason:' + i + ' - ' + $('#txt_eval_' + i + '_reason').val());
				
				eval_point += $('#txt_eval_' + i + '_point').val() + ',';
				eval_reason += $('#txt_eval_' + i + '_reason').val() + ',';
			}
			
			eval_point = eval_point.substring(0, eval_point.length - 1);
			eval_reason = eval_reason.substring(0, eval_reason.length - 1);
			
			for (var i = 1; i <= level1_count; i++) {
				for (var j = 0; j < level2_count_arr[i-1]; j++) {
					eval_1_point += $('input[name="eval_' + i + '_' + j + '"]:checked').val() + ',';
					console.log('input[name="eval_' + i + '_' + j + '"]:checked');
					console.log($('input[name="eval_' + i + '_' + j + '"]:checked').val());
					
				}
				eval_1_point = eval_1_point.substring(0, eval_1_point.length - 1) + ';';
			}
			
			for (var k = 0; k <channel_name_arr_count; k++) {
				
				eval_ratio += channel_name_arr[k] + ',';
				for (var i = 1; i <= level1_count; i++) {
					
					for (var j = 0; j < level2_count_arr[i-1]; j++) {
					
						eval_ratio += i + '.' + (j + 1 ) + ',' + $("#txt_eval_ratio_" + i + "_" + j + "_" + k).val() + ',';
						console.log(i + '-' + j + '-' + k);
					}
					
				}
				eval_ratio = eval_ratio.substring(0, eval_ratio.length - 1) + ';';
			}
			
			
			console.log("eval_point:" + eval_point);
			console.log("eval_reason:" + eval_reason);
			console.log("eval_1_point:" + eval_1_point);
			console.log("eval_ratio:" + eval_ratio);
			
			$.ajax({
				type : "POST",
				url : "caseChannelEvaluation.do",
				data : {
					action : "update",
					channel_id : $('#channel_id').val(),
					evaluate_point : eval_point,
					evaluate_reason : eval_reason,
					evaluate_1_point : eval_1_point,
					evaluate_seq : eval_ratio
				},
				success : function(result) {
					mainLoad();
				}
			});
		}
		
		$("#logout").click(function(e) {
			$.ajax({
				type : "POST",
				url : "login.do",
				data : {
					action : "logout"
				},
				success : function(result) {
					top.location.href = "login.jsp";
				}
			});
		});
		
		$("#back").click(function(e) {
			top.location.href = "main.jsp";
		});
		
	});
</script>
</head>
<body>
<input type="hidden" id="glb_menu" value='<%= menu %>' />
<input type="hidden" id="glb_privilege" value="<%= privilege %>" />

	<div class="page-wrapper" >
	
		<div class="header">
			<div class="userinfo">
				<p>使用者<span><%= (request.getSession().getAttribute("user_name")==null)?"":request.getSession().getAttribute("user_name").toString() %></span></p>
				<a href="#" id="logout" class="btn-logout">登出</a>
			</div>
		</div>
	
		<jsp:include page="menu.jsp"></jsp:include>
				
		<div id="msgAlert"></div>
				
	 	<h2 id="title" class="page-title">通路決策評估</h2>
		
		<!-- content-wrap -->
		<div class="content-wrap">
			<div id="caseAlert"></div>
			<div id="resultModal" class="result-table-wrap"></div>
		
			<div id="div_list" class="form-row" >
				<form class="form-row customDivMain">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>通路決策評估</h2>
						</div>
						
						<div class="result-table-wrap">
							<table id="tbl_list" class="result-table">
								<tbody></tbody>
							</table>
						</div>
						
						<div class="btn-row">
							<button id="btn_list_evaluate" class="btn btn-exec btn-wide" >開始通路決策</button>
							<button id="btn_list_view" class="btn btn-exec btn-wide" >查看通路決策</button>
						</div>
					</div>
				</form>
			</div>		
		
			<div id="div_main" class="form-row" >
				<form class="form-row customDivMain">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>通路決策評估</h2>
							<h4>本次評估欲觀察之國家城市範圍</h4>
						</div>
						
						<div class="result-table-wrap">
							<input type="hidden" id="channel_id" name="channel_id">
							<table id="tbl_main" class="result-table">
								<tbody></tbody>
							</table>
						</div>
						
						<div class="btn-row">
							<button id="btn_main_evaluate" class="btn btn-exec btn-wide" >開始評估</button>
						</div>
					</div>
				</form>
			</div>
		
			<div id="div_evaluate_step1" class="form-row" >
				<form class="form-row custom_step1">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>通路決策評估(第一步)</h2>
							<h4>一、填寫下列評估因子之重要性質(1至5)</h4>
						</div>
						
						<div class="btn-row">
							<button id="btn_step1_cancel" class="btn btn-exec btn-wide">取消</button>
							<button id="btn_step1_next" class="btn btn-exec btn-wide">下一步</button>
							<button id="btn_step1_default" class="btn btn-exec btn-wide">使用預設</button>
						</div>						
					</div>
				</form>
			</div>
			
			<!-- 政策偏好 -->
			<div id="div_evaluate_step2" class="form-row" >
				<form class="form-row custom_step2">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>通路決策評估(第二步)</h2>
							<h4>政策偏好</h4>
						</div>

						<div class="btn-row">
							<button id="btn_step2_prev" class="btn btn-exec btn-wide">上一步</button>
							<button id="btn_step2_next" class="btn btn-exec btn-wide">下一步</button>
							<button id="btn_step2_default" class="btn btn-exec btn-wide">使用預設</button>
						</div>
					</div>
				</form>
			</div>
	
			<div id="div_evaluate_step3" class="form-row" >
				<form class="form-row custom_step3">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>通路決策評估(第三步)</h2>
							<h4>五、請填寫各商圈決策因子比序重要性質(1至5)</h4>
						</div>
						
						<div class="btn-row">
							<button id="btn_step3_reset" class="btn btn-exec btn-wide">重新填寫</button>
							<button id="btn_step3_send" class="btn btn-exec btn-wide">送出</button>
							<button id="btn_step3_default" class="btn btn-exec btn-wide">使用預設</button>
						</div>
					</div>
				</form>
			</div>
			

		</div>
		<!-- content-wrap -->
		
		<script src="js/sbi/menu.js"></script>
		<footer class="footer">
			財團法人商業發展研究院  <span>電話(02)7707-4800 | 傳真(02)7713-3366</span> 
		</footer>
	</div>
	
</body>
</html>