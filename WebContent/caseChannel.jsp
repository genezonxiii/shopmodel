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
<title>通路決策管理</title>
<style>
.td-checkbox {
    text-align: center; /* center checkbox horizontally */
    vertical-align: middle; /* center checkbox vertically */
}
</style>

<script>
	
	$(function() {
		var div_list = ['div_main','div_create_step1','div_create_step2','div_create_step3','div_create_step4','div_create_step5','div_create_step6','div_create_step7'];
		var decision_case_finish_json_params = "";
		var user_count = 0;
		var defaultValue = "請選擇";
		var pref_count = 0;
		var tbl_evaluation_group_select_arr = [];
		var choose_count = 0;
		
		var channel_count_default = 5;
		var channel_count = 10;
		var evaluation_count_default = 5;
		var evaluation_count = 10;
		
		var channel_details_text_arr_default = ["無店鋪或自動販賣", "直營店", "加盟店", "超級市場、便利商店", "百貨公司、大型購物中心、量販店"];

		var evaluation_details_select_arr_default = [4, 3, 4, 7, 7];
		var evaluation_details_text_arr_default = ["供應商議價能力", "購買者議價能力", "新進入者威脅", "替代品威脅", "同業競爭者競爭程度"];
		var evaluation_show_all_group_default =  [["商品品牌價值", "商品通路普及程度", "商品功能差異化程度", "商品銷售獲利能力"],
		                                              ["消費族群購買力", "市場飽和度影響", "商品運用外部影響"],
		                                              ["經營型態", "商品類型", "消費者認知", "技術成熟度"],
		                                              ["主要提供者", "替代品特點", "通路佈局", "商品價格", "商品外部效應", "消費者認知", "技術成熟度"],
		                                              ["經營型態", "商品特點", "通路佈局", "商品價格", "商品外部效應", "消費者認知", "技術成熟度"]];
				
		$(document).keypress(function(e) {
			if(e.which == 13) {
		    	event.preventDefault();
		    }
		});
		
		$( document ).ready(function() {
			mainLoad();
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
		
		$("#btn_main_create").click(function(e) {
			e.preventDefault();
			
			setTblDecisionCaseFinish();
			
			show_hide([false, true, false, false, false, false, false, false]);
		});
		
		function setTblDecisionCaseFinish() {
			
			$("#tbl_decision_case_finish").find('tbody').remove();
			$("#tbl_decision_case_finish").append('<tbody></tbody>');

			$("#tbl_decision_case_finish").html(
					'<tr>' + 
						'<th style="width:40px;"><label>選取</label></th>' +
						'<th style="width:40px;"><label>項次</label></th>' + 
						'<th><label>國家</label></th>' + 
						'<th><label>城市</label></th>' + 
						'<th><label>最高分商圈</label></th>' + 
					'</tr>'
				);
			
			
			$.ajax({
				type : "POST",
				url : "caseChannel.do",
				data : {
					action : "getDecisionCaseFinish"
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					
					$.each(json_obj, function(i, item) {
						
						$("#tbl_decision_case_finish").append('<tr>' +
								'<td><input type="checkbox" name= "tbl_decision_case_finish_checkbox" id="checkbox_decision_case_finish_' + i + '"/><label for="checkbox_decision_case_finish_' + i + '"></label></td>' + 
								'<td>' + (i + 1) + '</td>' + 
								'<td>' + item.v_country + '</td>' + 
								'<td>' + item.v_city_name + '</td>' +  
								'<td>' + item.result + 
								'<input type="hidden" id="hidden_decision_case_finish_params_' + i + '" value="' + JSON.stringify(item).replace(/"/g,'$') + '">'+
								'</td>' + 
								'</tr>');
						
					});
					
					$('[id^=checkbox_decision_case_finish]').click(function(e) {
						$("[id^=checkbox_decision_case_finish]").prop( "checked", false );
						$(this).prop( "checked", true );
						
						var chooseId = "hidden_decision_case_finish_params_"+$('[id^=checkbox_decision_case_finish]').index(this);
						decision_case_finish_json_params = $('input[id='+chooseId+']').val();
					});
				}
			});
		}

		$("#btn_step1_next").click(function(e) {
			e.preventDefault();
			
			if($("input:checkbox[name='tbl_decision_case_finish_checkbox']:checked").length === 0){
				warningMsg('警告', '請勾選一筆欲觀察之商圈，方能進行流程!');
				return;
			}
			
			var length = $('#salesChannelNum').children('option').length;
			if(length!=channel_count){
				$("#salesChannelNum option").remove();
				$("#salesChannelNum").append($('<option></option>').val(defaultValue).html(defaultValue));
				for (var i=1;i<=channel_count;i++) {
					$("#salesChannelNum").append($('<option></option>').val(i).html(i));	
				}				
			}
			
			show_hide([false, false, true, false, false, false, false, false]);
		});
		
		$("#btn_step2_next").click(function(e) {
			e.preventDefault();
			
			var count = $('#salesChannelNum').val();
			
			if(count==='請選擇'){
				warningMsg('警告', '請選擇銷售通路!');
				return;
			}
			
			choose_count = count;
			
			$("#tbl_sales_channels_group").find('tbody').remove();
			$("#tbl_sales_channels_group").append('<tbody></tbody>');
			
			for (var i = 0; i < count; i++){
				$('#tbl_sales_channels_group > tbody:last-child')
					.append('<tr>'
						+ '<td>' + (i + 1)
						+ '.<input type="text" id="tbl_sales_channels_group_text_' + i + '" name="tbl_sales_channels_group_text_' + i + '"></td>'
						+ '</tr>');
			}
			
			//========== validate rules (dynamic) ==========
			$( ".custom_step3" ).validate();
			
			$("[name^=tbl_sales_channels_group_text_]").each(function(){
				$(this).rules("add", {
				  	required: true
				});
		   	});
			
			show_hide([false, false, false, true, false, false, false, false]);

		});

		function channels_text_validate() {
			var valid = false;
			var validate_array = [];
			$("input[name^='tbl_sales_channels_group_text_']").each(function(index){
			 if(($.trim($(this).val())).length === 0){
				 validate_array.push(index+1);
			    return valid = true;
			 }
			});
			validate_array.push(valid);
			
			return validate_array;
		}
		
		$("#btn_step3_next").click(function(e) {
			e.preventDefault();
			
			if (!$('.custom_step3').valid()) {
				warningMsg('警告', '尚有資料未填寫完畢');
				return;
			}
			
			var validate_array = channels_text_validate();
			
			var result = validate_array.pop();
			
			var length = $('#evaluationNum').children('option').length;
			if(length!=evaluation_count){			
				$("#evaluationNum option").remove();
				$("#evaluationNum").append($('<option></option>').val(defaultValue).html(defaultValue));
				for (var i=1;i<=evaluation_count;i++) {
					$("#evaluationNum").append($('<option></option>').val(i).html(i));	
				}				
			}
			
			show_hide([false, false, false, false, true, false, false, false]);

		});
		
		$("#btn_step4_next").click(function(e) {
			e.preventDefault();
			
			var count = $('#evaluationNum ').val();

			if(count==='請選擇'){
				warningMsg('警告', '請選擇評估因子!');
				return;
			}
			
			choose_count = count;
			
			$("#tbl_evaluation_group").find('tbody').remove();
			$("#tbl_evaluation_group").append('<tbody></tbody>');
			
			for (var i = 0; i < count; i++){
				$('#tbl_evaluation_group > tbody:last-child')
					.append('<tr>'
						+ '<td>' + (i + 1)
						+ '.<input type="text" id="tbl_evaluation_group_text_' + i + '" name="tbl_evaluation_group_text_' + i + '">'
						+'</td><td>'
						+' <select id="tbl_evaluation_group_select_' + i +'" name="tbl_evaluation_group_select_' + i + '"></select><label>項評估子因子</label>'
						+'</td>'
						+ '</tr>');
			}
			for (var j=0;j<=count;j++) {
				$("#tbl_evaluation_group_select_"+j).append($('<option></option>').val('').html(defaultValue));
				for (var k=1;k<=evaluation_count;k++) {
					$("#tbl_evaluation_group_select_"+j).append($('<option></option>').val(k).html(k));	
				}
			}
			$( ".custom_step5" ).validate({
			    errorPlacement: function(error, element) {
			        element.before(error);
			  	}
		  	});
			$("[name^=tbl_evaluation_group_text_]").each(function(){
				$(this).rules("add", {
				  	required: true
				});
		   	});
			$("[name^=tbl_evaluation_group_select_]").each(function(){
				$(this).rules("add", {
				  	required: true
				});
		   	});			
			show_hide([false, false, false, false, false, true, false, false]);

		});		
		
		$("#btn_step5_next").click(function(e) {
			e.preventDefault();
			
 			if (!$('.custom_step5').valid()) {
 				warningMsg('警告', '尚有資料未填寫完畢');
				return;
 			}
 			
			$("#tbl_evaluation_show_all_group").find('tbody').remove();
			$("#tbl_evaluation_show_all_group").append('<tbody></tbody>');			
			
			tbl_evaluation_group_select_arr =[];
			for (var i = 0; i < choose_count; i++) {
				tbl_evaluation_group_select_arr.push($('#tbl_evaluation_group_select_' + i).val());
			}
			
			for (var i = 0; i < choose_count; i++) {
				var text_list = "";
				
				text_list += '<td style="min-width:200px;">' + (i + 1) + '.' + $("#tbl_evaluation_group_text_"+i).val() + '</td>';
				for (var j = 0; j < tbl_evaluation_group_select_arr[i]; j++) {
					text_list += '<td><input type="text" id="tbl_evaluation_show_all_group_text_' + i + '_' + j + '" name="tbl_evaluation_show_all_group_text_' + i + '_' + j + '"></td>';
				}
				$('#tbl_evaluation_show_all_group').append('<tr>' + text_list + '</tr>');
			}
			$( ".custom_step6" ).validate();
			$("[name^=tbl_evaluation_show_all_group_text_]").each(function(){
				$(this).rules("add", {
				  	required: true
				});
		   	});			
			show_hide([false, false, false, false, false, false, true, false]);
			
		});
		
		$("#btn_step6_next").click(function(e) {
			e.preventDefault();
			
 			if (!$('.custom_step6').valid()) {
 				warningMsg('警告', '尚有資料未填寫完畢');
				return;
 			}
 			
			$("#tbl_evaluation_final").find('tbody').remove();
			$("#tbl_evaluation_final").append('<tbody></tbody>');
			
			$.ajax({
				type : "POST",
				url : "caseChannel.do",
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
								'</label>'+
								'<input type="hidden" id="hidden_user_rdo_' + i + '_' + j + '" value="' + json_obj[i].user_id + '">';
						}

						$("#tbl_evaluation_final").append('<tr><td><label>' + json_obj[i].user_name + '</label></td>' + 
								'<td><input type="text" id="tbl_evaluation_final_text_' + i + '" name="tbl_evaluation_final_text_' + i + '"></td>' +
								'<td>' + radio_list + '</td>'+
								'<td><input type="hidden" id="hidden_user_text_' + i + '" value="' + json_obj[i].user_id + '"></td></tr>');
					
						//========== validate rules (dynamic) ==========
						$( ".custom_step7" ).validate({
						    errorPlacement: function(error, element) {
						        element.before(error);
						  	}
					  	});
						
						$("[name^=user_]").each(function(){
							$(this).rules("add", {
							  	required: true
							});
					   	});
						
						$("[name^=tbl_evaluation_final_text_]").each(function(){
							$(this).rules("add", {
								required: true
							});
					   	});
					});

				}
			});

			
			show_hide([false, false, false, false, false, false, false, true]);

		});
		
		$("#btn_step1_cancel").click(function(e) {
			e.preventDefault();

			show_hide([true, false, false, false, false, false, false, false]);			

		});

		$("#btn_step2_prev").click(function(e) {
			e.preventDefault();
			
			show_hide([false, true, false, false, false, false, false, false]);
			
		});

		$("#btn_step3_prev").click(function(e) {
			e.preventDefault();
			
			show_hide([false, false, true, false, false, false, false, false]);

		});

		$("#btn_step4_prev").click(function(e) {
			e.preventDefault();

			show_hide([false, false, false, true, false, false, false, false]);			

		});

		$("#btn_step5_prev").click(function(e) {
			e.preventDefault();

			show_hide([false, false, false, false, true, false, false, false]);			

		});

		$("#btn_step6_prev").click(function(e) {
			e.preventDefault();
			
			show_hide([false, false, false, false, false, true, false, false]);
			
		});

		$("#btn_step7_prev").click(function(e) {
			e.preventDefault();
			
			show_hide([false, false, false, false, false, false, true, false]);		

		});
				
		$("#btn_step2_default").click(function(e) {
			e.preventDefault();
			$('#salesChannelNum').val(channel_count_default);
			choose_count = channel_count_default;
		});
		
		$("#btn_step3_default").click(function(e) {
			e.preventDefault();
			for (var i = 0; i < choose_count; i++) {
				$("#tbl_sales_channels_group_text_" + i).val(channel_details_text_arr_default[i]);
			}
		});
		
		$("#btn_step4_default").click(function(e) {
			e.preventDefault();
			$("#evaluationNum").val(evaluation_count_default);
			choose_count = evaluation_count_default;
		});
		
		$("#btn_step5_default").click(function(e) {
			e.preventDefault();
			
			for (var i = 0; i < choose_count; i++) {
				$("#tbl_evaluation_group_text_" + i).val(evaluation_details_text_arr_default[i]);
			}
			for (var j = 0; j < choose_count; j++) {
				$("#tbl_evaluation_group_select_" + j).val(evaluation_details_select_arr_default[j]);
			}
		});
		
		$("#btn_step6_default").click(function(e) {
			e.preventDefault();
			
			for (var i = 0; i < choose_count; i++) {
				for (var j = 0; j < tbl_evaluation_group_select_arr[i]; j++) {
					$("#tbl_evaluation_show_all_group_text_" + i + "_" + j).val(evaluation_show_all_group_default[i][j]);
				}
			}
		});
		
		$("#btn_step7_default").click(function(e) {
			e.preventDefault();
			
			var number = 1;
			
			for (var i = 0; i < user_count; i++) {
				number = 1 + Math.floor(Math.random() * 5);
				$("#tbl_evaluation_final_text_" + i).val(number);
				$('#rdo_user_' + i + '_1').prop('checked', true);
			}
		});
				
		$("#btn_step7_reset").click(function(e) {
			e.preventDefault();
			
			setTimeout(mainLoad(), 1000);
		});
				
		$("#btn_step7_confirm").click(function(e) {
			e.preventDefault();
			
			if (!$('.custom_step7').valid()) {
				warningMsg('警告', '尚有資料未填寫完畢');
				return;
			}
			
			var validate_rad_array = [];
			var validate_text_array = [];
			
			for(var i= 0;i<user_count;i++){
				for (var j = 1; j <= 2; j++) {
					if(!$('#rdo_user_'+ i + '_' + j).is(':checked')) {
						validate_rad_array.push($('#rdo_user_'+ i + '_' + j).attr("id"));
					}
				}
			}
			$("input[name^='tbl_evaluation_final_text_']").each(function(index){
				 if(($.trim($(this).val())).length === 0){
					 validate_text_array.push(index+1);
				 }
			});
		

			var user_rdo_arr=[];
			var user_text_arr=[];
			var channel_name = "";
			var evaluate = "";
			var evaluate_1_no = "";
			var evaluate_1 = "";
			
			for(var i= 0;i<user_count;i++){
				for (var j = 1; j <= 2; j++) {
					if($('#rdo_user_'+ i + '_' + j).is(':checked')) {
						var rdoTmp = $('#hidden_user_rdo_'+ i + '_' + j).val()+','+$('#rdo_user_'+ i + '_' + j).val();
						user_rdo_arr.push(rdoTmp);
					}
				}
				var texTmp = $('#hidden_user_text_'+ i).val()+','+$('#tbl_evaluation_final_text_'+ i).val();
				user_text_arr.push(texTmp);
				
			}
			for(var j= 0;j<$('#salesChannelNum').val();j++){
				channel_name += $("#tbl_sales_channels_group_text_"+j).val()+',';
			}
			for(var j= 0;j<$('#evaluationNum').val();j++){
				evaluate += $("#tbl_evaluation_group_text_"+j).val()+',';
				evaluate_1_no += $("#tbl_evaluation_group_select_"+j).val()+',';
				for (var k = 0; k < tbl_evaluation_group_select_arr[j]; k++) {
					evaluate_1 += $("#tbl_evaluation_show_all_group_text_" + j + "_" + k).val() + ',';
				}
				evaluate_1 = evaluate_1.substring(0, evaluate_1.length - 1) + ';';
			}
			channel_name = channel_name.substring(0, channel_name.length - 1);
			evaluate = evaluate.substring(0, evaluate.length - 1);
			evaluate_1_no = evaluate_1_no.substring(0, evaluate_1_no.length - 1);
			
			$.ajax({
				type : "POST",
				url : "caseChannel.do",
				data : {
					action : "insert",
					user_rdo_arr: user_rdo_arr,
					user_text_arr: user_text_arr,
					decision_case_finish_json_params : decision_case_finish_json_params,
					channel_no: $("#salesChannelNum").val(),
					channel_name: channel_name,
					evaluate_no: $("#evaluationNum").val(),
					evaluate: evaluate,
					evaluate_1_no: evaluate_1_no,
					evaluate_1:evaluate_1
				},
				success : function(result) {
					setTimeout(mainLoad(), 1000);
				}
			});
		});
		
		$("#btn_main_view").click(function(e){
			e.preventDefault();
			
			if($("input:checkbox[name='tbl_main_checkbox']:checked").length === 0){
				warningMsg('警告', '查看通路決策時，請勾選一筆決策 !');
				return;
			}
			
			var channel_id = "";
			
			$('#tbl_main').find('tr').each(function () {
				var row = $(this);
				if ( row.find('input[type="checkbox"]').is(':checked') ) {
					channel_id = row.find('[id^=channel_id_]').val();
				}
			});

			window.open('caseChannelUserDetail.jsp?channel_id=' + channel_id, '', 'width=700,height=500,directories=no,location=no,menubar=no,scrollbars=yes,status=no,toolbar=no,resizable=no,left=250,top=150,screenX=0,screenY=0');

		});
		
		$("#tbl_evaluation_final").on("change", "[name^=tbl_evaluation_final_text]", function(e) {
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
			
			show_hide([true, false, false, false, false, false, false, false]);

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
						
						$("#tbl_main").append('<tr>' + 
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
						
					})
					
					$('[id^=checkbox-r]').click(function(e) {
						$("[id^=checkbox-r]").prop( "checked", false );
						$(this).prop( "checked", true );
					});
					
					$('#tbl_main').find('tr').each(function () {
						var row = $(this);
						var city_id = row.find('[id^=city_id_]').val();
						
					});
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
				
	 	<h2 id="title" class="page-title">通路決策管理</h2>
		
		<!-- content-wrap -->
		<div class="content-wrap">
			<div id="caseAlert"></div>
			<div id="resultModal" class="result-table-wrap"></div>
		
			<div id="div_main" class="form-row" >
				<form class="form-row customDivMain">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>通路決策管理</h2>
						</div>
						
						<div class="result-table-wrap">
							<table id="tbl_main" class="result-table">
								<tbody></tbody>
							</table>
						</div>
						
						<div class="btn-row">
							<button id="btn_main_create" class="btn btn-exec btn-wide" >建立通路決策</button>
							<button id="btn_main_view" class="btn btn-exec btn-wide" >查看通路決策</button>
						</div>
					</div>
				</form>
			</div>
		
			<div id="div_create_step1" class="form-row" >
				<form class="form-row custom_step1">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>建立通路決策</h2>
							<h4>本次評估欲觀察之商圈</h4>
						</div>
						
						<div class="result-table-wrap">
							<table id="tbl_decision_case_finish" class="result-table">
								<tbody></tbody>
							</table>
						</div>
						
						<div class="btn-row">
							<button id="btn_step1_cancel" class="btn btn-exec btn-wide">取消</button>
							<button id="btn_step1_next" class="btn btn-exec btn-wide">下一步</button>
						</div>						
					</div>
				</form>
			</div>
			
			<div id="div_create_step2" class="form-row" >
				<form class="form-row custom_step2">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>建立通路決策</h2>
							<h4>1.銷售通路類別數量</h4>
						</div>
						
						<div class="result-table-wrap">
							<table class="result-table">
								<tbody>
									<tr>
										<td><label>銷售通路</label></td>
										<td>
											<select id="salesChannelNum" name="salesChannelNum"></select>
											<label>項類別(一次最多10項)</label>
										</td>
									</tr>
								</tbody>
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
							<h2>建立通路決策</h2>
							<h4>2.銷售通路類別詳細</h4>
						</div>
						
						<div class="result-table-wrap">
							<table id="tbl_sales_channels_group" class="result-table" style="border:3px;">
								<tbody></tbody>
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
							<h2>建立通路決策</h2>
							<h4>3.評估因子數量</h4>
						</div>
						
						<div class="result-table-wrap">
							<table class="result-table">
								<tbody>
									<tr>
										<td><label>評估因子</label></td>
										<td>
											<select id="evaluationNum" name="evaluationNum"></select>
											<label>項(一次最多10項)</label>
										</td>
									</tr>
								</tbody>
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
							<h2>建立通路決策</h2>
							<h4>4.評估因子詳細</h4>
						</div>
						<div class="result-table-wrap">
							<table id="tbl_evaluation_group" class="result-table">
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
							<h2>建立通路決策</h2>
							<h4>5.評估子因子</h4>
						</div>
						<div class="result-table-wrap">
							<table id=tbl_evaluation_show_all_group class="result-table">
							</table>
						</div>
						<div class="btn-row">
							<button id="btn_step6_prev" class="btn btn-exec btn-wide">上一步</button>
							<button id="btn_step6_next" class="btn btn-exec btn-wide">下一步</button>
							<button id="btn_step6_default" class="btn btn-exec btn-wide">使用預設</button>
						</div>
					</div>
				</form>
			</div>

			<div id="div_create_step7" class="form-row" >
				<form class="form-row custom_step7">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>建立通路決策</h2>
							<h4>6.本次評估參與人員及重要性質設定(1至5)</h4>
						</div>
						<div class="result-table-wrap">
							<table id=tbl_evaluation_final class="result-table">
							</table>
						</div>
						<div class="btn-row">
							<button id="btn_step7_prev" class="btn btn-exec btn-wide">上一步</button>
							<button id="btn_step7_reset" class="btn btn-exec btn-wide">重新填寫</button>
							<button id="btn_step7_confirm" class="btn btn-exec btn-wide">確認送出</button>
							<button id="btn_step7_default" class="btn btn-exec btn-wide">使用預設</button>
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