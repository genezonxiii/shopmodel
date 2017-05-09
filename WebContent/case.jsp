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
<title>決策管理</title>
<style>
.td-checkbox {
    text-align: center; /* center checkbox horizontally */
    vertical-align: middle; /* center checkbox vertically */
}
</style>

<script>
	
	$(function() {
		
		var div_list = ['div_main','div_create_step1','div_create_step2','div_create_step3','div_create_step4',
			'div_create_step5','div_create_step6'];

		var user_count = 0;
		var defaultValue = "請選擇";
		var pref_count = 0;
		var level1_count = 0;
		var level2_count_arr = [];
		var level1_default = ['環境', '經營', '消費'];
		var level2_default = [['交通便利', '商圈規模', '商圈適配', '磁吸企業'],
			['潛在通路', '類似商品', '服務能力', '商品服務適配'],
			['消費能力', '生活文化層次', '消費者屬性差異', '消費者適配']];
		
		var validator_step1 = $(".custom_step1").validate({
			rules : {
				country : {
					required : true
				},
				city : {
					required : true
				},
				safety_money : {
					required : true,
					number : true
				}
			}
		});
		
		var validator_step3 = $(".custom_step3").validate({
			rules : {
				evaluate_no : {
					required : true
				}
			}
		});
				
		$(document).keypress(function(e) {
			if(e.which == 13) {
		    	event.preventDefault();
		    }
		});
		
		$( document ).ready(function() {
			mainLoad();
		});
		
		$("#btn_main_create").click(function(e) {
			e.preventDefault();
			
			$("#country").find('option').remove();
			$("#city").find('option').remove();
			$("#bcircle_list").html('');
			
			$.ajax({
				type : "POST",
				url : "case.do",
				data : {
					action : "getCountry"
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					
					$("#country").append($('<option></option>').val('').html(defaultValue));
					$.each(json_obj, function(i, item) {
						$("#country").append($('<option></option>').val(item.v_country_id).html(item.v_country));	
					});	
				}
			});
			
			show_hide([false, true, false, false, false, false, false]);
		});
		
		$("#btn_step1_next").click(function(e) {
			e.preventDefault();
			
			if (!$('.custom_step1').valid()) {
				warningMsg('警告', '尚有資料未填寫完畢');
				return;
			}

			show_hide([false, false, true, false, false, false, false]);
		});
		
		$("#btn_step2_next").click(function(e) {
			e.preventDefault();
			
			if (!$('.custom_step2').valid()) {
				warningMsg('警告', '尚有資料未填寫完畢');
				return;
			}
			
			$("#evaluate_no").find('option').remove();
			$("#evaluate_no").append($('<option></option>').val('').html(defaultValue));
			for (var i = 1; i <= 10; i++) {
				$("#evaluate_no").append($('<option></option>').val(i).html(i));	
			}
			
			show_hide([false, false, false, true, false, false, false]);
		});
		
		$("#btn_step3_next").click(function(e) {
			e.preventDefault();
			
			if (!$('.custom_step3').valid()) {
				warningMsg('警告', '尚有資料未填寫完畢');
				return;
			}
			
			var count = $('#evaluate_no').val();
			level1_count = count;
			
			$("#tbl_level2").find('tbody').remove();
			$("#tbl_level2").append('<tbody></tbody>');
			
			for (var i = 0; i < count; i++){
				$('#tbl_level2 > tbody:last-child')
					.append('<tr>'
						+ '<td>' + (i + 1) + '.</td>'
						+ '<td><input type="text" id="eval_1_text_' + i + '" name="eval_1_text_' + i + '"></td>'
						+ '<td>評估子因子<select id="eval_1_select_' + i +'" name="eval_1_select_' + i +'"></select>項</td>'
						+ '</tr>');
				
				$( "#eval_1_select_" + i ).append($('<option></option>').val('').html(defaultValue));
				for (var j = 1; j <= 10; j++) {
					$( "#eval_1_select_" + i ).append($('<option></option>').val(j).html(j));	
				}
			}
			
			//========== validate rules (dynamic) ==========
			$( ".custom_step4" ).validate();
			
			$("[name^=eval_1_text_]").each(function(){
				$(this).rules("add", {
				  	required: true
				});
		   	});
			
			$("select[name^=eval_1_select_]").each(function(){
				$(this).rules("add", {
				  	required: true
				});
		   	});
			
			show_hide([false, false, false, false, true, false, false]);
		});
		
		$("#btn_step4_next").click(function(e) {
			e.preventDefault();
			
			if (!$('.custom_step4').valid()) {
				warningMsg('警告', '尚有資料未填寫完畢');
				return;
			}
			
			$("#tbl_level3").find('tbody').remove();
			$("#tbl_level3").append('<tbody></tbody>');
			
			level2_count_arr = [];
			for (var i = 0; i < level1_count; i++) {
				level2_count_arr.push($('#eval_1_select_' + i).val());
			}
			
			for (var i = 0; i < level1_count; i++) {
				var text_list = "";

				text_list += '<td>' + (i + 1) + '.' + $('#eval_1_text_' + i).val() + '</td>';
				for (var j = 0; j < level2_count_arr[i]; j++) {
					text_list += '<td><input type="text" id="eval_2_text_' + i + '_' + j + '" name="eval_2_text_' + i + '_' + j + '"></td>';
				}
				
				$('#tbl_level3').append('<tr>' + text_list + '</tr>');
			}
			
			//========== validate rules (dynamic) ==========
			$( ".custom_step5" ).validate();
			
			$("[name^=eval_2_text_]").each(function(){
				$(this).rules("add", {
				  	required: true
				});
		   	});			
			
			show_hide([false, false, false, false, false, true, false]);
		});
		
		$("#btn_step5_next").click(function(e) {
			e.preventDefault();
			
			if (!$('.custom_step5').valid()) {
				warningMsg('警告', '尚有資料未填寫完畢');
				return;
			}
			
			$("#tbl_level4").find('tbody').remove();
			$("#tbl_level4").append('<tbody></tbody>');
			
			$.ajax({
				type : "POST",
				url : "user.do",
				data : {
					action : "selectAll"
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					
					user_count = json_obj.length;

					$.each(json_obj, function(i, item) {
						var radio_list = "";
						
						for (var j = 1; j <= 2; j++) {
							var content = ['查看成員的評估', '查看歷次決策'];
							radio_list += 
								'<input type="radio" id="rdo_user_' + i + '_' + j + '" name="user_' + i + '" value="' + j + '">' + 
								'<label for="rdo_user_' + i + '_' + j + '">' + 
								'<span class="form-label">' + content[j-1] + '</span>' + 
								'</label>';
						}

						$("#tbl_level4").append('<tr><td><label>' + json_obj[i].user_name + '</label></td>' + 
								'<td><input type="text" id="eval_3_text_' + i + '" name="eval_3_text_' + i + '"></td>' +
								'<td>' + radio_list + '</td>' + 
								'<td><input type="hidden" id="user_' + i + '" name="user_' + i + '" value="' + json_obj[i].user_id + '"></td></tr>');
					});
					
					//========== validate rules (dynamic) ==========
					$( ".custom_step6" ).validate({
					    errorPlacement: function(error, element) {
					        element.before(error);
					  	}
				  	});
					
					$("[name^=eval_3_text_]").each(function(){
						$(this).rules("add", {
						  	required: true
						});
				   	});
					
					$("[name^=user_]").each(function(){
						$(this).rules("add", {
						  	required: true
						});
				   	});
				}
			});
			
			show_hide([false, false, false, false, false, false, true]);
		});
		
// 		$("#btn_step6_next").click(function(e) {
// 			e.preventDefault();
			
// 			if (!$('.custom_step6').valid()) {
// 				warningMsg('警告', '尚有資料未填寫完畢');
// 				return;
// 			}
			
// 			$("#div_main").show();
// 			$("#div_create_step1").hide();
// 		    $("#div_create_step2").hide();
// 		    $("#div_create_step3").hide();
// 		    $("#div_create_step4").hide();
// 		    $("#div_create_step5").hide();
// 		    $("#div_create_step6").hide();
// 		});
		
		$("#btn_step1_cancel").click(function(e) {
			e.preventDefault();
			
			show_hide([true, false, false, false, false, false, false]);
		});

		$("#btn_step2_prev").click(function(e) {
			e.preventDefault();
			
			show_hide([false, true, false, false, false, false, false]);
		});

		$("#btn_step3_prev").click(function(e) {
			e.preventDefault();
			
			show_hide([false, false, true, false, false, false, false]);
		});

		$("#btn_step4_prev").click(function(e) {
			e.preventDefault();
			
			show_hide([false, false, false, true, false, false, false]);
		});

		$("#btn_step5_prev").click(function(e) {
			e.preventDefault();
			
			show_hide([false, false, false, false, true, false, false]);
		});

		$("#btn_step6_prev").click(function(e) {
			e.preventDefault();
			
			show_hide([false, false, false, false, false, true, false]);
		});
		
		$("#btn_step2_default").click(function(e) {
			e.preventDefault();
			
			for (var i = 0; i < pref_count; i++) {
				$('#rdo_pref_' + i + '_3').prop('checked', true);
			}
			
		});
		
		$("#btn_step3_default").click(function(e) {
			e.preventDefault();
			
			$("#evaluate_no").val('3');
		});
		
		$("#btn_step4_default").click(function(e) {
			e.preventDefault();
			
			for (var i = 0; i < level1_count; i++) {
				$("#eval_1_text_" + i).val(level1_default[i]);
				$("#eval_1_select_" + i).val('4');
			}
		});
		
		$("#btn_step5_default").click(function(e) {
			e.preventDefault();
			
			for (var i = 0; i < level1_count; i++) {
				for (var j = 0; j < level2_count_arr[i]; j++) {
					$("#eval_2_text_" + i + "_" + j).val(level2_default[i][j]);
				}
			}
		});
		
		$("#btn_step6_default").click(function(e) {
			e.preventDefault();
			
			for (var i = 0; i < user_count; i++) {
				$("#eval_3_text_" + i).val('3');
				$('#rdo_user_' + i + '_1').prop('checked', true);
			}
		});
		
		$("#btn_step6_confirm").click(function(e) {
			e.preventDefault();
			
			if (!$('.custom_step6').valid()) {
				warningMsg('警告', '尚有資料未填寫完畢');
				return;
			}
			
			var temp = "", temp2 = "", temp3 = "";
			var eval1_text_list = "", eval1_select_list = "";
			var eval2_text_list = "";
			var pref_list = "";
						
			for (var i = 0; i < level1_count; i++) {
				temp  += $('#eval_1_text_' + i).val() + ',';
				temp2 += $('#eval_1_select_' + i).val() + ',';
				
				for (var j = 0; j < level2_count_arr[i]; j++) {
					temp3 += $("#eval_2_text_" + i + "_" + j).val() + ',';
				}
				temp3 = temp3.substring(0, temp3.length - 1) + ';';
			}
			eval1_text_list = temp.substring(0, temp.length - 1);
			eval1_select_list = temp2.substring(0, temp2.length - 1);
			eval2_text_list = temp3.substring(0, temp3.length - 1);
			
			temp = "";
			for (var i = 0; i < pref_count; i++) {
				temp += $('input[name="pref_' + i + '"]:checked').val() + ',';
			}
			pref_list = temp.substring(0, temp.length - 1);

			var eval_3_text_list = "", rdo_user_list = "";
			temp = "", temp2 = "";
			
			for (var i = 0; i < user_count; i++) {
				temp  += $('#eval_3_text_' + i).val() + ',';
				temp2 += $('input[name="user_' + i + '"]:checked').val() + ',';
			}
			eval_3_text_list = temp.substring(0, temp.length - 1);
			rdo_user_list = temp2.substring(0, temp.length - 1);
			
			$.ajax({
				type : "POST",
				url : "case.do",
				data : {
					action : "insert",
					city_id : $('#city').val(),
					bcircle_id : $('#bcircle_id_list').html(),
					preference : pref_list,
					evaluate_no : level1_count,
					evaluate : eval1_text_list,
					evaluate_1_no : eval1_select_list,
					evaluate_1 : eval2_text_list
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					var result_table = "";
					
					evaluate(json_obj);
					
				}
			});
		});
		
		$("#btn_main_view").click(function(e){
			e.preventDefault();
			
			var case_id = "";
			
			$('#tbl_main').find('tr').each(function () {
				var row = $(this);
				if ( row.find('input[type="checkbox"]').is(':checked') ) {
					case_id = row.find('[id^=case_id_]').val();
				}
			});

			window.open('caseUserDetail.jsp?case_id=' + case_id, '', 'width=700,height=500,directories=no,location=no,menubar=no,scrollbars=yes,status=no,toolbar=no,resizable=no,left=250,top=150,screenX=0,screenY=0');

		});
		
		$("#country").change(function(){
			$.ajax({
				type : "POST",
				url : "case.do",
				data : {
					action : "getCity",
					country : $("#country").val()
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					
					$("#city").find('option').remove();
					$("#city").append($('<option></option>').val('').html(defaultValue));
					$.each(json_obj, function(i, item) {
						$("#city").append($('<option></option>').val(item.city_id).html(item.v_city_name));	
					});	
				}
			});
		});
		
		$("#city").change(function(){
			
			$.ajax({
				type : "POST",
				url : "case.do",
				data : {
					action : "getBD",
					city : $("#city").val()
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					var bcircle_id_list = "", bcircle_list = "";
					
					$("#tbl_pref").find('tbody').remove();
					$("#tbl_pref").append('<tbody></tbody>');
					
					pref_count = json_obj.length;
					
					$.each(json_obj, function(i, item) {
						bcircle_id_list += item.bcircle_id + ",";
						bcircle_list += item.v_bcircle_name + ",";
						
						var radio_list = "";
						for (var j = 1; j <= 5; j++) {
							radio_list += '<input type="radio" id="rdo_pref_' + i + '_' + j + '" name="pref_' + i + '" value="' + j + '">' + 
								'<label for="rdo_pref_' + i + '_' + j + '">' + 
								'<span class="form-label">' + j + '</span>' + 
								'</label>';
						}
						
						$('#tbl_pref').append('<tr><td>' + item.v_bcircle_name + '</td>' + 
								'<td>' + radio_list + '</td>' + 
								'</tr>');
					});	
					
					//========== validate rules (dynamic) ==========
					$( ".custom_step2" ).validate({
					    errorPlacement: function(error, element) {
				        	element.before(error);
					  	}
				  	});
					
					$("[name^=pref_]").each(function(){
						$(this).rules("add", {
						  	required: true
						});
				   	});
					
					if (bcircle_list.length > 0) {
						bcircle_id_list = bcircle_id_list.substring(0, bcircle_id_list.length - 1);
						bcircle_list = bcircle_list.substring(0, bcircle_list.length - 1);
					}
					
					$("#bcircle_id_list").html(bcircle_id_list);
					$("#bcircle_list").html(bcircle_list);
				}
			});
		});
		
		$("#tbl_level4").on("change", "[name^=eval_3_text]", function(e) {
			e.preventDefault();
			
			var radioUser = $(this).closest("tr").find("[name^=user]");
			
			if ($(this).val() == "0") {
				radioUser
					.prop('checked', false)
					.rules("remove");
			} else {
				radioUser.rules("add", {
				  	required: true
				});
			}
		});
		
		function mainLoad() {
			
			setTblMain();
			
			show_hide([true, false, false, false, false, false, false]);
		}
		
		function setTblMain() {
			$("#tbl_main").find('tbody').remove();
			$("#tbl_main").append('<tbody></tbody>');

			$("#tbl_main").html(
					'<tr>' + 
						'<th style="width:40px;"><label>選取</label></th>' +
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
				url : "case.do",
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
						
						$("#tbl_main").append('<tr>' + 
								'<td><input type="checkbox" id="checkbox-r' + i + '"/><label for="checkbox-r' + i + '"></label></td>' + 
								'<td>' + (i + 1) + '</td>' + 
								'<td>' + item.v_country + '</td>' + 
								'<td>' + item.v_city_name + '</td>' + 
								'<td><span id="bd_' + i + '"></span></td>' + 
								'<td>' + item.ending_time + '</td>' + 
								'<td>' + finish + 
									'<input type="hidden" id="city_id_' + i + '" value="' + item.city_id + '">' + 
									'<input type="hidden" id="case_id_' + i + '" value="' + item.case_id + '">' + 
								'</td>' + 
								'</tr>');
						
					})
					
					$('[id^=checkbox-r]').click(function(e) {
						$("[id^=checkbox-r]").prop( "checked", false );
						$(this).prop( "checked", true );
					});
					
					$('#tbl_main').find('tr').each(function () {
						var row = $(this);
						var city_id = row.find('[id^=city_id_]').val();
						
						getBD(city_id, row);
					});
				}
			});
			
			
		}
		
		function getBD(city_id, row) {
			var bd_arr = [];
			
			$.ajax({
				type : "POST",
				url : "case.do",
				data : {
					action : "getBD",
					city : city_id
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					
					$.each(json_obj, function(i, item) {
						bd_arr.push(item.v_bcircle_name);
					});
					
					row.find('[id^=bd_]').html(bd_arr.join());
				}
			});
		}
		
		function evaluate(evaluate) {
			
			var user = "", weight = "";
			
			for (var i = 0; i < user_count; i++) {
				user = $("#user_" + i).val();
				weight = $("input[name^=eval_3_text_" + i + "]").val();
				auth = $("input[name^=user_" + i + "]:checked").val();
				
				$.ajax({
					type : "POST",
					url : "evaluate.do",
					data : {
						action : "insert",
						evaluate_id : '',
						case_id : evaluate[0].case_id,
						user_id : user,
						weight : weight,
						user_authority : auth,
						evaluate_point : '',
						evaluate_1_point : '',
						evaluate_reason : '',
						evaluate_seq : ''
					},
					success : function(result) {
						var json_obj = $.parseJSON(result);
						
					}
				});
			}

			setTimeout(mainLoad(), 1000);
			
		}
		
		function show_hide(show_hide_list) {
			for (var i = 0; i < div_list.length; i++) {
				if (show_hide_list[i]) {
					$("#" + div_list[i]).show();
				} else {
					$("#" + div_list[i]).hide();
				}
			}
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
				
	 	<h2 id="title" class="page-title">決策管理</h2>
		
		<!-- content-wrap -->
		<div class="content-wrap">
			<div id="caseAlert"></div>
			<div id="resultModal" class="result-table-wrap"></div>
		
			<div id="div_main" class="form-row" >
				<form class="form-row customDivMain">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>決策管理</h2>
						</div>
						
						<div class="result-table-wrap">
							<table id="tbl_main" class="result-table">
								<tbody></tbody>
							</table>
						</div>
						
						<div class="btn-row">
							<button id="btn_main_create" class="btn btn-exec btn-wide" >建立決策</button>
							<button id="btn_main_view" class="btn btn-exec btn-wide" >查看決策</button>
						</div>
					</div>
				</form>
			</div>
		
			<div id="div_create_step1" class="form-row" >
				<form class="form-row custom_step1">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>建立決策(第一步)</h2>
							<h4>本次評估欲觀察之國家城市範圍</h4>
						</div>
						
						<div class="result-table-wrap">
							<table class="result-table">
								<tbody>
									<tr>
										<td><label>國家：</label></td>
										<td>
											<select id="country" name="country"></select>
										</td>
									</tr>
									<tr>
										<td><label>城市：</label></td>
										<td>
											<select id="city" name="city"></select>
										</td>
									</tr>
									<tr>
										<td><label>商圈</label></td>
										<td>
											<span id="bcircle_id_list" hidden="true"></span>
											<span id="bcircle_list"></span>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="btn-row">
							<button id="btn_step1_cancel" class="btn btn-exec btn-wide">取消</button>
							<button id="btn_step1_next" class="btn btn-exec btn-wide">下一步</button>
						</div>						
					</div>
				</form>
			</div>
			
			<!-- 政策偏好 -->
			<div id="div_create_step2" class="form-row" >
				<form class="form-row custom_step2">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>建立決策(第二步)</h2>
							<h4>政策偏好</h4>
						</div>
						<div class="result-table-wrap">
							<table id="tbl_pref" class="result-table">
								<tbody></tbody>
							</table>
						</div>
						<div class="btn-row">
							<button id="btn_step2_prev" class="btn btn-exec btn-wide">上一步</button>
							<button id="btn_step2_next" class="btn btn-exec btn-wide">下一步</button>
							<button id="btn_step2_default" class="btn btn-exec btn-wide">使用預設</button>
						</div>
					</div>
				</form>
			</div>
	
			<div id="div_create_step3" class="form-row" >
				<form class="form-row custom_step3">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>建立決策(第三步)</h2>
							<h4>1.評估因子數量</h4>
						</div>
						
						<div class="result-table-wrap">
							<table id="tbl_level1" class="result-table">
								<tbody>
									<tr>
										<td>評估因子</td>
										<td>
											<select id="evaluate_no" name="evaluate_no"></select>
										</td>
										<td>項(一次最多10項)</td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="btn-row">
							<button id="btn_step3_prev" class="btn btn-exec btn-wide">上一步</button>
							<button id="btn_step3_next" class="btn btn-exec btn-wide">下一步</button>
							<button id="btn_step3_default" class="btn btn-exec btn-wide">使用預設</button>
						</div>
					</div>
				</form>
			</div>
			
			<div id="div_create_step4" class="form-row" >
				<form class="form-row custom_step4">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>建立決策(第四步)</h2>
							<h4>2.評估因子詳細</h4>
						</div>
						
						<div class="result-table-wrap">
							<table id="tbl_level2" class="result-table" style="border:3px;">
								<tbody></tbody>
							</table>
						</div>
						
						<div class="btn-row">
							<button id="btn_step4_prev" class="btn btn-exec btn-wide">上一步</button>
							<button id="btn_step4_next" class="btn btn-exec btn-wide">下一步</button>
							<button id="btn_step4_default" class="btn btn-exec btn-wide">使用預設</button>
						</div>
					</div>
				</form>
			</div>

			<div id="div_create_step5" class="form-row" >
				<form class="form-row custom_step5">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>建立決策(第五步)</h2>
							<h4>3.評估子因子</h4>
						</div>
						<div class="result-table-wrap">
							<table id="tbl_level3" class="result-table">
								<tbody></tbody>
							</table>
						</div>
						<div class="btn-row">
							<button id="btn_step5_prev" class="btn btn-exec btn-wide">上一步</button>
							<button id="btn_step5_next" class="btn btn-exec btn-wide">下一步</button>
							<button id="btn_step5_default" class="btn btn-exec btn-wide">使用預設</button>
						</div>
					</div>
				</form>
			</div>
			
			<div id="div_create_step6" class="form-row" >
				<form class="form-row custom_step6">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>建立決策(第六步)</h2>
							<h4>4.本次評估參與人員及重要性質設定(1至5)</h4>
						</div>
						<div class="result-table-wrap">
							<table id=tbl_level4 class="result-table">
							</table>
						</div>
						<div class="btn-row">
							<button id="btn_step6_prev" class="btn btn-exec btn-wide">上一步</button>
							<button id="btn_step6_reset" class="btn btn-exec btn-wide">重新填寫</button>
							<button id="btn_step6_confirm" class="btn btn-exec btn-wide">確認送出</button>
							<button id="btn_step6_default" class="btn btn-exec btn-wide">使用預設</button>
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