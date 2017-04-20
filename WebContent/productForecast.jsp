<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF8">

	<link rel="Shortcut Icon" type="image/x-icon" href="./images/cdri-logo.gif" />

	<link rel="stylesheet" href="css/jquery.dataTables.min.css">
	<link rel="stylesheet" href="css/jquery-ui.min.css">
	<link rel="stylesheet" href="css/font-awesome.min.css">
	<link rel="stylesheet" href="css/styles.css">

	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<script type="text/javascript" src="js/jquery-ui.min.js"></script>
	<script type="text/javascript" src="js/jquery.dataTables.min.js"></script>
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
<title>新產品風向評估</title>

<script>
	
	$(function() {

		var user_count = 0;
		
		$(document).keypress(function(e) {
			if(e.which == 13) {
		    	event.preventDefault();
		    }
		});
		
		$( document ).ready(function() {
			mainLoad();
		});
		
		$("#create").click(function(event) {
			event.preventDefault();
			$("#tbl1").html('');
			
			$(".content-wrap > div").hide();
// 		    $("#divMain").hide();
		    $("#div1").show();
// 			$("#div3").hide();
// 			$("#divTest").hide();
		});
		
		$("[id^=back2List-a]").click(function() {
			event.preventDefault();
			$( ":input" ).val('');
			$("#point").html('');

			$(".content-wrap > div").hide();
			$("#divMain").show();
// 		    $("#div1").hide();
// 			$("#div3").hide();
// 			$("#divTest").hide();
		});
		
		$("#backPage-a3").click(function() {
			event.preventDefault();
			
			$(".content-wrap > div").hide();
// 			$("#divMain").hide();
		    $("#div1").show();
// 			$("#div3").hide();
// 			$("#divTest").hide();
		});
		
		$("#next1").click(function(event) {
			event.preventDefault();
			
			if ( !$(".customDiv1").valid() ) {
				return;
			}
			
			if ( checkDiv1("eq") ) {
				$.ajax({
					type : "POST",
					url : "user.do",
					data : {
						action : "selectAll"
					},
					success : function(result) {
						var json_obj = $.parseJSON(result);
						var result_table = "";
						var str = "";
						
						user_count = json_obj.length;
						$("#point").html('<tr>' + 
								'<th><label>使用者名稱</label></th>' +
								'<th><label>權重</label></th>' + 
								'<th hidden="true">userid</th>' + 
							'</tr>');
						$.each(json_obj, function(i, item) {
							$("#point").append('<tr><td><label>' + json_obj[i].user_name + '</label></td>' + 
									'<td><input id="rdo-0-' + i + '" type="radio" name="rdoweight-' + i + '" value="0"><label for="rdo-0-' + i + '"><span class="form-label">0</span></label>' +
									'<input id="rdo-1-' + i + '" type="radio" name="rdoweight-' + i + '" value="1" checked><label for="rdo-1-' + i + '"><span class="form-label">1</span></label>' +
									'<input id="rdo-2-' + i + '" type="radio" name="rdoweight-' + i + '" value="2"><label for="rdo-2-' + i + '"><span class="form-label">2</span></label>' + 
									'<input id="rdo-3-' + i + '" type="radio" name="rdoweight-' + i + '" value="3"><label for="rdo-3-' + i + '"><span class="form-label">3</span></label>' + 
									'<input id="rdo-4-' + i + '" type="radio" name="rdoweight-' + i + '" value="4"><label for="rdo-4-' + i + '"><span class="form-label">4</span></label>' +
									'<input id="rdo-5-' + i + '" type="radio" name="rdoweight-' + i + '" value="5"><label for="rdo-5-' + i + '"><span class="form-label">5</span></label></td>' + 
									'<td><input type="hidden" id="user-' + i + '" name="user-' + i + '" value="' + json_obj[i].user_id + '"></td></tr>');
						});

						$(".content-wrap > div").hide();
// 						$("#divMain").hide();
// 						$("#div1").hide();
						$("#div3")
							.data("kind", "normal")
							.show();
// 						$("#divTest").hide();
					}
				});
			}
		});
		
		$("#confirm").click(function() {
			event.preventDefault();
			
			if ($("#div3").data("kind") === "normal") {
				console.log("normal"); 
				
				if ( !$(".customDiv3").valid() ) {
					return;
				}
				
				var 
				cost = $("#cost").val(),
				temp = '',
				func_no = 0,
				nfunc_no = 0,
				serv_no = 0,
				func_name_list = "", nfunc_name_list = "", service_name_list = "",
				func_score_list = "", nfunc_score_list = "", service_score_list = "";
			
				var count = 1;
				$('#tbl1').find('tr').each(function () {
					var row = $(this);
					
					var data1 = row.find('[id^=cmb-1-r]').val();
					var data2 = row.find('[id^=cmb-2-r]').val();
					var data3 = row.find('[id^=text3-r]').val();
					var data4 = row.find('[id^=text4-r]').val();
					
					switch (data1) {
						case "func":
							func_no++;
							func_name_list += data3 + ',';
							func_score_list += data4 + ',';
							break;
						case "nfunc":
							nfunc_no++;
							nfunc_name_list += data3 + ',';
							nfunc_score_list += data4 + ',';
							break;
						case "service":
							serv_no++;
							service_name_list += data3 + ',';
							service_score_list += data4 + ',';
							break;
						default:
			       	 		
					}

					count++;
				});
				func_name_list = func_name_list.substr(0, func_name_list.length - 1);
				func_score_list = func_score_list.substr(0, func_score_list.length - 1);
				
				nfunc_name_list = nfunc_name_list.substr(0, nfunc_name_list.length - 1);
				nfunc_score_list = nfunc_score_list.substr(0, nfunc_score_list.length - 1);
				
				service_name_list = service_name_list.substr(0, service_name_list.length - 1);
				service_score_list = service_score_list.substr(0, service_score_list.length - 1);
				
				$.ajax({
					type : "POST",
					url : "productForecast.do",
					data : {
						action : "insert",
						group_id : '<%=group_id%>',
						product_name : $("#product_name").val(),
						cost : $("#cost").val(),
						function_no : func_no,
						function_name : func_name_list,
						function_score : func_score_list,
						nfunction_no : nfunc_no,
						nfunction_name : nfunc_name_list,
						nfunction_score : nfunc_score_list,
						service_no : serv_no,
						service_name : service_name_list,
						service_score : service_score_list,
						score_time : '',
						result : '',
						isfinish : 0,
						ref_prod : $("#ref_prod").val()
					},
					success : function(result) {
						var json_obj = $.parseJSON(result);
						var len=json_obj.length;

						point(json_obj);
					}
				});
			} else if ($("#div3").data("kind") === "wizard") {
				console.log("wizard"); 
				
				var div = $(".divFormStep1")
				var div2 = $(".divFormStep2")
				var table = div2.find(".result-table").DataTable();
				
				var func = [], nfunc = [], service = [];
				var func_p = [], nfunc_p = [], service_p = [];
				
				//push data into seperate array
				table.rows().every( function ( rowIdx, tableLoop, rowLoop ) {
				    var data = this.data();
				    var node = this.node();
				    console.log("rowIdx:" + rowIdx);
				    
				    var item_name = data.item_name;
				    var portion = $(node).find("input[name=portion]").val();
				    
				    if (data.kind_code == 'func'){
				    	func.push(item_name);
				    	func_p.push(portion);
				    } else if (data.kind_code == 'nfunc'){
				    	nfunc.push(item_name);
				    	nfunc_p.push(portion);
				    } else if (data.kind_code == 'service'){
				    	service.push(item_name);
				    	service_p.push(portion);
				    } 
				} );
				
				$.ajax({
					type : "POST",
					url : "productForecast.do",
					data : {
						action : "insert",
						group_id : '<%=group_id%>',
						product_name : div.find('input[name=product_name]').val(),
						cost : div.find('input[name=cost]').val(),
						function_no : func.length,
						function_name : func.join(','),
						function_score : func_p.join(','),
						nfunction_no : nfunc.length,
						nfunction_name : nfunc.join(','),
						nfunction_score : nfunc_p.join(','),
						service_no : service.length,
						service_name : service.join(','),
						service_score : service_p.join(','),
						score_time : '',
						result : '',
						isfinish : 0,
						ref_prod : div.find('input[name=ref_prod]').val()
					},
					success : function(result) {
						var json_obj = $.parseJSON(result);
						var len=json_obj.length;

						pointWizard(json_obj);
					}
				});
			}
		});
		
		$("#create2").click(function(event) {
			event.preventDefault();
			var isChecked = $('.maincheck').attr('checked')?true:false;
			
			$('#main').find('tr').each(function () {
				var row = $(this);
				
				if ( row.find('input[type="checkbox"]').is(':checked') ) {
					var forecast_id = row.find('.forecast_id_main').html();
					
		        	$.ajax({
						type : "POST",
						url : "productForecast.do",
						data : {
							action : "selectByForecastId",
							forecast_id : forecast_id
						},
						success : function(result) {
							var json_obj = $.parseJSON(result);
							
							$.each(json_obj, function(i, item) {
								
								$('#forecast_id_test').val(json_obj[i].forecast_id);
								$('#user_id_test').val('<%=user_id%>');
								
								$("#product_name_test").html("產品名稱：" + json_obj[i].product_name);
								
								var function_name = json_obj[i].function_name.split(',');
								
								$.each( function_name, function( index, value ){
									$("#function-test").append('<tr><td>' + value + '</td><td>' + '<input type="text" id="function-test-' + index + '" name="function-test-' + index + '">' + '</td></tr>');
								});
								
								var nfunction_name = json_obj[i].nfunction_name.split(',');
								
								$.each( nfunction_name, function( index, value ){
									$("#nfunction-test").append('<tr><td>' + value + '</td><td>' + '<input type="text" id="nfunction-test-' + index + '" name="nfunction-test-' + index + '">' + '</td></tr>');
								});
								
								var service_name = json_obj[i].service_name.split(',');
								
								$.each( service_name, function( index, value ){
									$("#service-test").append('<tr><td>' + value + '</td><td>' + '<input type="text" id="service-test-' + index + '" name="service-test-' + index + '">' + '</td></tr>');
								});
								
								//========== validate rules (dynamic) ==========
								$( ".customDivTest" ).validate();
								
								$("[name^=function-test-]").each(function(){
									$(this).rules("add", {
									  	required: true,
		                                number: true,
		                                max: 5,
		                                min: 1,
		                                customWeight: true
									});
							   	});
								
								$("[name^=nfunction-test-]").each(function(){
									$(this).rules("add", {
									  	required: true,
		                                number: true,
		                                max: 5,
		                                min: 1,
		                                customWeight: true
									});
							   	});

								$("[name^=service-test-]").each(function(){
									$(this).rules("add", {
									  	required: true,
		                                number: true,
		                                max: 5,
		                                min: 1,
		                                customWeight: true
									});
							   	});
								
								$.validator.addMethod('customWeight',function(value, element, param) {
	                             	var regEx = /^\d(\.\d{1})?\d{0}$/;
	                             	
									if(regEx.test(value)){
										return true ;
									} else {
										return false ;
									}

		                           	return isValid; // return bool here if valid or not.
		                       	}, '請輸入數值介於1~5，小數點後1位!' );

								$(".content-wrap > div").hide();
// 								$("#divMain").hide();
// 								$("#div1").hide();
// 								$("#div3").hide();
								$("#divTest").show();
							});
							
							$('input.maincheck').on('change', function() {
							    $('input.maincheck').not(this).prop('checked', false);  
							});
						}
					});
		            
		        }
		    });
		});
		
		$("#confirmTest").click(function(event) {
			event.preventDefault();
			if ( !$(".customDivTest").valid() ) {
				return;
			}
			
			var 
			forecast_id = "", user_id = "";
			func_point_list = "", nfunc_point_list = "", service_point_list = "";
			
			forecast_id = $("#forecast_id_test").val();
			user_id	= '<%=user_id%>';
			
			$('#function-test').find('tr').each(function () {
				var row = $(this);
				if ( row.find('input[type="text"]').val()  ) {
					func_point_list = func_point_list + row.find('[name^=function-test-]').val() + ',';
				}
				
			});
			
			func_point_list = func_point_list.substr(0, func_point_list.length - 1);
			
			$('#nfunction-test').find('tr').each(function () {
				var row = $(this);
				if ( row.find('input[type="text"]').val() ) {
					nfunc_point_list = nfunc_point_list + row.find('[name^=nfunction-test-]').val() + ',';
				}
			});
			
			nfunc_point_list = nfunc_point_list.substr(0, nfunc_point_list.length - 1);
			
			$('#service-test').find('tr').each(function () {
				var row = $(this);
				if (  row.find('input[type="text"]').val() ) {
					service_point_list = service_point_list + row.find('[name^=service-test-]').val() + ',';
				}
			});
			
			service_point_list = service_point_list.substr(0, service_point_list.length - 1);
			
			$.ajax({
				type : "POST",
				url : "productForecastPoint.do",
				data : {
					action : "update",
					forecast_id : forecast_id,
					user_id : user_id,
					function_point : func_point_list,
					nfunction_point : nfunc_point_list,
					service_point : service_point_list
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					var len=json_obj.length;
					
				}
			});
			
			$("#function-test").html('');
			$("#nfunction-test").html('');
			$("#service-test").html('');
			
			$(".content-wrap > div").hide();
			$("#divMain").show();
// 		    $("#div1").hide();
// 			$("#div3").hide();
// 			$("#divTest").hide();
		});
		
		$("#addRow").click(function() {
			event.preventDefault();
			var rowCount = $('#tbl1 tr').length;
			
			$("#tbl1").append('<tr><td><select id="cmb-1-r' + rowCount + '" name="cmb-1-r' + rowCount + '"></select></td>' + 
					'<td><select id="cmb-2-r' + rowCount + '" name="cmb-2-r' + rowCount + '"></select></td>' +
					'<td><input type="text" id="text3-r' + rowCount + '" name="text3-r' + rowCount +'">' +
					'</td><td>成本比例(%)</td><td><input type="text" id="text4-r' + rowCount + '" name="text4-r' + rowCount + '"></td></tr>');
						
			$("[id^=cmb-1-r" + rowCount + "]")
				.append($('<option></option>').val("func").html("功能或產品性項目"))
				.append($('<option></option>').val("nfunc").html("非功能或產品性項目"))
				.append($('<option></option>').val("service").html("服務性項目"));
			
			$( "[id^=text4-r" + rowCount + "]" ).blur(function() {
				checkDiv1("gt");
			});
			
			$.ajax({
				type : "POST",
				url : "ProductForecastItem.do",
				data : {
					action : "getGroupAndKind",
					group_id : "<%=group_id%>",
					item_kind : "func"
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					$("[id^=cmb-2-r" + rowCount + "]").append($('<option></option>').val("").html("請選擇"));				
					$.each(json_obj, function(i, item) {
						$("[id^=cmb-2-r" + rowCount + "]").append($('<option></option>').val(json_obj[i].item_name).html(json_obj[i].item_name));	
					});
				},
				error:function(e){
					
				}
			});
			
			$("[id^=cmb-1-r]").change(function() {
				var $this = $(this);
				var row = $this.closest("tr");
				
				
				$.ajax({
					type : "POST",
					url : "ProductForecastItem.do",
					data : {
						action : "getGroupAndKind",
						group_id : "<%=group_id%>",
						item_kind : $(this).val()
					},
					success : function(result) {
						var json_obj = $.parseJSON(result);
						row.find('[id^=cmb-2-r]').html('');
						row.find('[id^=cmb-2-r]').append($('<option></option>').val("").html("請選擇"));
						row.find('[id^=text3-r]').val('');
						$.each(json_obj, function(i, item) {
							row.find('[id^=cmb-2-r]').append($('<option></option>').val(json_obj[i].item_name).html(json_obj[i].item_name));	
						});
					},
					error:function(e){
						
					}
				});				
			});
			
			$("[id^=cmb-2-r]").change(function() {
				var $this = $(this);
				var row = $this.closest("tr");
				
				row.find('[id^=text3-r]').val( $(this).val() );
			});

			
			//========== validate rules (dynamic) ==========
			$( ".customDiv1" ).validate();

			$("[id^=text4-r" + rowCount + "]").rules("add", {
			  	required: true,
			    messages: {
			        required: "必填"
		      	}
			});
			
			$("[id^=text3-r" + rowCount + "]").rules("add", {
			  	required: true,
			    messages: {
			        required: "必填"
		      	}
			});

		});
		
		$(".btn-wizard").click(function(e) {
			e.preventDefault();
			
			$(".content-wrap > div").hide();
			$(".divFormStep1").show();
		});
		
		$(".btn-2step2").click(function(e) {
			e.preventDefault();
			
			$("#tbl_wizard").DataTable({
				destroy: true,
				dom: "fr<t>i",
				paging: false,
				scrollY: "350px",
				language: {"url": "js/dataTables_zh-tw.txt"},
				columns: [
					null,
		        	{"data": "item_kind", "defaultContent":""},
		        	{"data": "item_name", "defaultContent":""},
		        	{"data": "portion", "defaultContent":""}
		        ],
		        columnDefs: [{
					//勾選
		        	targets: 0,
					render: function ( data, type, row, meta ) {
						//產生checkbox
						var result = $("<div/>") //fake tag
							.append( 
								$("<input/>", {
									"type": "checkbox",
									"class": "chkdetail",
									"id": "chkdetail-" + meta.row
								})
							)
							.append( 
								$("<label/>", {
									"for": "chkdetail-" + meta.row
								})
								.text("選取")
							);
						return result.html();
					}
		        }, {
		        	//成本比例
		        	targets: 3,
					render: function ( data, type, row, meta ) {
						//產生text
						var result = $("<div/>") //fake tag
							.append( 
								$("<input/>", {
									"type": "text",
									"name": "portion",
									"value": data
								})
							);
						return result.html();
					}
	            }]
			});
			
			//remove all rows of data
			$("#tbl_wizard")
				.DataTable()
				.clear();
			
			$(".content-wrap > div").hide();
			$(".divFormStep2").show();
		});
		
		$(".btn-2User").click(function(e) {
			e.preventDefault();
			
			$("#point").DataTable({
				destroy: true,
				dom: "<t>",
				paging: false,
				ordering: false,
				scrollY: "200px",
				language: {"url": "js/dataTables_zh-tw.txt"},
				ajax: {
					url : "user.do",
					dataSrc: "",
					type : "POST",
					data : {
						action : "selectAll"
					}
				},
		        columns: [
		        	{"data": "user_name", "defaultContent":""},
		        	null,
		        	{"data": "user_id", "defaultContent":"", "visible": false}
		        ],
		        columnDefs: [{
					//權重
		        	targets: 1,
					render: function ( data, type, row, meta ) {
						//產生radio button
						var result = $("<div/>") //fake tag
						for (var i = 0; i < 6; i++) {
							result
								.append( 
									$("<input/>", {
										"type": "radio",
										"name": "rdoweight-" + meta.row,
										"id": "rdo-" + meta.row + "-" + i,
										"value": i,
										"checked": i == 1? true:false
									})
								)
								.append( 
									$("<label/>", {
										"for": "rdo-" + meta.row + "-" + i
									})
									.append(
										$("<span/>", {
											"class": "form-label"
										})
										.text(i)
									)
								);
						}
						
						return result.html();
					}
		        }]
			});
			
			$(".content-wrap > div").hide();
			$("#div3")
				.data("kind", "wizard")
				.show();
		});
		
		
		$(".btn-back2List").click(function(e) {
			e.preventDefault();
			
			$(".content-wrap > div").hide();
			$("#divMain").show();
		});
		
		$(".btn_add_evaluate").click(function(e){
			e.preventDefault();
			
			$("[name=tbl_type]").DataTable({
				destroy: true,
				dom: "fr<t>i",
				paging: false,
				scrollY: "200px",
				language: {"url": "js/dataTables_zh-tw.txt"},
				ajax: {
					url : "ProductForecastItem.do",
					dataSrc: "",
					type : "POST",
					data : {
						action : "getType"
					}
				},
		        columns: [
		        	null,
		        	{"data": "industryKind", "defaultContent":""},
		        	{"data": "productKind", "defaultContent":""},
		        	{"data": "itemKind", "defaultContent":""},
		        	{"data": "itemName", "defaultContent":""}
		        ],
		        columnDefs: [{
					//勾選
		        	targets: 0,
					render: function ( data, type, row, meta ) {
						//產生checkbox
						var result = $("<div/>") //fake tag
							.append( 
								$("<input/>", {
									"type": "checkbox",
									"class": "chktype",
									"id": "chktype-" + meta.row
								})
							)
							.append( 
								$("<label/>", {
									"for": "chktype-" + meta.row
								})
								.text("選取")
							);
						return result.html();
					}
	            }]
			});
			
			$("[name=tbl_type]").delegate("input.chktype", "click", function(e) {
			    //single check
				$('input.chktype')
			    	.not(this)
			    	.prop('checked', false);  
			});
			
			$("#dialog-type").dialog({
				modal : true,
				buttons : [{
					text : "確認",
					click : function() {
						var chk = false;
						var data = null;
						
						$('[name=tbl_type]>tbody').find('tr').each(function (i, item) {
							var row = $(this);

							if ( row.find('input[type="checkbox"]').is(':checked') ) {
								data = $("[name=tbl_type]").DataTable().row(this).data();
							    chk = true;
							}
						});
						
						if (!chk) {
							warningMsg("提醒", "請選擇一筆資料");
							return;
						}
						
						//新增資料列
						var tblWizard = $("#tbl_wizard").DataTable();
						
						tblWizard.row
							.add({
								kind_code: data.kindCode, 
								item_kind: data.itemKind, 
								item_name: data.itemName, 
								portion: 10
							})
							.draw();
						
						$(this).dialog("close");
					}
				}, {
					text : "取消",
					click : function() {
						$(this).dialog("close");
					}
				}]
			});
			
		});
		
		function point(productForecast) {
			var user = "", weight = "";
			
			for (var i = 0; i < user_count; i++) {
				user = $("#user-" + i).val();
				weight = $("input[name^=rdoweight-" + i + "]:checked").val();
				
				if (weight === "0") {
					continue;
				}
				
				$.ajax({
					type : "POST",
					url : "productForecastPoint.do",
					data : {
						action : "insert",
						forecast_id : productForecast[0].forecast_id,
						user_id : user,
						weight : weight,
						function_point : '',
						nfunction_point : '',
						service_point : '',
						score_seq : ''
					},
					success : function(result) {
						var json_obj = $.parseJSON(result);
						var len=json_obj.length;
						
						$( ":input" ).val('');
						$("#point").html('');
					}
				});
			}
			
			mainLoad();
			
			$(".content-wrap > div").hide();
			$("#divMain").show();
		}
		
		function pointWizard(productForecast) {
			var tbl = $("#point").DataTable();
			
			tbl.rows().every( function ( rowIdx, tableLoop, rowLoop ) {
			    var data = this.data();
			    var node = this.node();
			    
				var weight = $(node).find("input[name^=rdoweight-]:checked").val();
				
				if (weight === "0") {
					return false;
				}
			    
				$.ajax({
					type : "POST",
					url : "productForecastPoint.do",
					data : {
						action : "insert",
						forecast_id : productForecast[0].forecast_id,
						user_id : data.user_id,
						weight : weight,
						function_point : '',
						nfunction_point : '',
						service_point : '',
						score_seq : ''
					},
					success : function(result) {
						var json_obj = $.parseJSON(result);
						var len=json_obj.length;
					}
				});
			} );
			
			mainLoad();
			
			$(".content-wrap > div").hide();
			$("#divMain").show();
		}
		
		function validateDecimal(value)    {
		    var RE = /^\d(\.\d{1})?\d{0}$/;
		    if(RE.test(value)){
		       return true;
		    }else{
		       return false;
		    }
		}
		
		function roundDecimal(val, precision) {
  			return Math.round(Math.round(val * Math.pow(10, (precision || 0) + 1)) / 10) / Math.pow(10, (precision || 0));
		}
		
		function mainLoad() {
			
			var h_str_checkbox = "", str_checkbox = "", str_button = "";
			
			if ('<%=role%>' == '0') {
				$('#create').hide();
				$('#btn_main_view').hide();
				$('#create2').show();
				h_str_checkbox = '<th><label>選擇</label></th>';
			} else if ('<%=role%>' == '1') {
				$('#create').show();
				$('#btn_main_view').show();
				$('#create2').hide();
				h_str_checkbox = '<th><label>選擇</label></th>';
			}
			
			$("#main").html(
				'<tr>' + 
					h_str_checkbox +
					'<th><label>產品名稱</label></th>' +
					'<th><label>總成本</label></th>' + 
					'<th>結果</th>' + 
				'</tr>'
			);
			
			$.ajax({
				type : "POST",
				url : "productForecast.do",
				data : {
					action : "selectByGroupId",
					group_id : '<%=group_id%>'
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					
					$.each(json_obj, function(i, item) {
						
						if ('<%=role%>' == '0') {
							str_checkbox = '<td><input type="checkbox" class="maincheck" id="checkbox-r' + i + '"/><label for="checkbox-r' + i + '"><span class="form-label">選取</span></label></td>';
						} else if ('<%=role%>' == '1') {
							str_checkbox = '<td><input type="checkbox" class="maincheck" id="checkbox-r' + i + '"/><label for="checkbox-r' + i + '"><span class="form-label"></span></label></td>';
						}
						
						if (json_obj[i].isfinish === 1) {
							str_button = "<u>評估結果</u>";
						} else {
							str_button = '';
						}
						
						$("#main").append('<tr>' + 
							str_checkbox +
							'<td class="product_name_main">' + json_obj[i].product_name + '</td>' +
							'<td class="cost_main">' + json_obj[i].cost + '</td>' + 
							'<td>' + str_button + '</td>' +
							'<td class="forecast_id_main" hidden="true">' + json_obj[i].forecast_id + '</td>' +
							'</tr>'
						);
					});
					
					$('input.maincheck').on('change', function() {
					    $('input.maincheck').not(this).prop('checked', false);  
					});
					
					$(".content-wrap > div").hide();
					$("#divMain").show();
// 					$("#div1").hide();
// 					$("#div3").hide();
// 					$("#divTest").hide();
					
					$('#main td').click(function () {
						var $this = $(this);
						var row = $this.closest("tr");
						var column_num = parseInt( $(this).index() ) + 1;
						var test_column_index = "${sessionScope.role}" == "1"? 4:4;
						
						if ( column_num == test_column_index && row.find('u').val() == '' ) {
							var forecast_id = row.find('.forecast_id_main').html();
							var cost = row.find('.cost_main').html();
							$("#resultModal").html('');
							
							$("#resultModal").append('<h2>總成本：' + cost + '</h2>');
							
				        	$.ajax({
								type : "POST",
								url : "productForecast.do",
								data : {
									action : "selectByForecastId",
									forecast_id : forecast_id
								},
								success : function(result) {
									var json_obj = $.parseJSON(result);
									
									$.each(json_obj, function(i, item) {
										var result_list = json_obj[i].result.split(',');
										
										$("#resultModal").append('<table id="tblResult" class="result-table"></table>');
										
										$("#tblResult").append('<tr>' + 
													'<th>優先次序</th>' + 
													'<th>名稱</th>' +
													'<th>比例</th>' +
												'</tr>');
										
										$.each( result_list, function(index, value){
											var temp = value.split("$");
											$("#tblResult").append('<tr><td>' + index + '</td><td><label>' + temp[0] + '</label><td><label>' + temp[1] + '</td></td></tr>');
										});

				 						$("#resultModal").dialog({
				 							title: "結果",
				 							draggable : true,
				 							resizable : false, //防止縮放
				 							autoOpen : false,
				 							height : "auto",
				 							modal : true,
				 							buttons : {
				 								"確認" : function() {
				 									$("#tblResult").html('');
				 									
				 									$(this).dialog("close");
				 								}
				 							}
				 						});
											
				 						$("#resultModal").dialog("open");
									});
									
								}
							});
				        }
					});
				}
			});
		}
		
		function checkDiv1(type) {
			var sum = 0, cost = 100;
			
			$('#tbl1').find('tr').each(function () {
				var row = $(this);
				var data4 = row.find('[id^=text4-r]').val();
				if(data4){
					sum += parseInt( data4 );
				}
			});
			
			if ((type == "eq" && cost != sum) || (type == "gt" && sum > cost)) {
				$("#productAlert").html("您輸入成本比例不符合100%，請重新輸入。成本總和為 " + sum + "% 。");
				
				$("#productAlert").dialog({
					title: "警告",
					draggable : true,
					resizable : false, //防止縮放
					autoOpen : false,
					height : "auto",
					modal : true,
					buttons : {
						"確認" : function() {
							$(this).dialog("close");
						}
					}
				});
					
				$("#productAlert").dialog("open");
					
				return false;
			}
			
			return true;
		}
		
		//========== validate rules ==========
		$( ".customDiv1" ).validate({
			rules: {
				product_name: {
					required: true
				},
				cost: {
					required: true,
					digits: true
				},
				ref_prod: {
					required: true
				}
			},
			messages: {
				product_name: {
					required : "必填"
				},
				cost: {
					required : "必填",
					digits : "請輸入整數"
				},
				ref_prod: {
					required : "必填"
				}
			}
		});
		
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
		
		$("#btn_main_view").click(function(e){
			e.preventDefault();
			
			var chk = false;
			
			$('#main').find('tr').each(function () {
				var row = $(this);

				if ( row.find('input[type="checkbox"]').is(':checked') ) {
					var forecast_id = row.find('.forecast_id_main').html();
					window.open('productForecastUserDetail.jsp?forecast_id=' + forecast_id, '', 'width=700,height=500,directories=no,location=no,menubar=no,scrollbars=yes,status=no,toolbar=no,resizable=no,left=250,top=150,screenX=0,screenY=0');
					chk = true;
				}
			});
			
			if (!chk) {
				warningMsg("提醒", "請選擇一筆資料");
			}
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

	<div id="msgAlert"></div>
	
	<div class="page-wrapper" >
	
		<div class="header">
			<div class="userinfo">
				<p>使用者<span><%= (request.getSession().getAttribute("user_name")==null)?"":request.getSession().getAttribute("user_name").toString() %></span></p>
				<a href="#" id="logout" class="btn-logout">登出</a>
			</div>
		</div>
	
		<jsp:include page="menu.jsp"></jsp:include>
				
	 	<h2 id="title" class="page-title">新產品風向評估</h2>
		
		<div class="content-wrap">
			<div id="productAlert"></div>
			<div id="resultModal" class="result-table-wrap"></div>
		
			<div id="divMain" class="form-row" hidden="true">
				<form class="form-row customDivMain">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>新產品風向評估</h2>
						</div>
						
						<div class="result-table-wrap">
							<table id="main" class="result-table">
							</table>
						</div>
						
						<div class="btn-row">
							<button id="create" class="btn btn-exec btn-wide" hidden="true">建立量表</button>
							<button id="btn_main_view" class="btn btn-exec btn-wide" >查看結果</button>
							<button id="create2" class="btn btn-exec btn-wide" hidden="true">開始評分</button>
							<button class="btn btn-exec btn-wide btn-wizard" hidden="true">評估精靈</button>
						</div>
					</div>
				</form>
			</div>
		
			<div id="div1" class="form-row" hidden="true">
				<form class="form-row customDiv1">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>新產品風向評估</h2>
						</div>
						
						<div class="result-table-wrap">
							<table class="result-table">
								<tr>
									<th><label>產品名稱</label></th>
									<th><input type="text" id="product_name" name="product_name"
										placeholder="輸入產品名稱"></th>
									<th><label>總成本</label></th>
									<th><input type="text" id="cost" name="cost"
										placeholder="輸入總成本"></th>
									<th><label>參考產品</label></th>
									<th><input type="text" id="ref_prod" name="ref_prod"
										placeholder="輸入參考產品"></th>
								</tr>
							</table>
							
							<table id="tbl1" class="result-table">
							</table>
						</div>
						
						<div class="btn-row">
							<button id="back2List-a1" class="btn btn-exec btn-wide">回列表頁</button>
							<button id="addRow" class="btn btn-exec btn-wide">新增項目</button>
							<button id="next1" class="btn btn-exec btn-wide">下一步</button>
						</div>						
					</div>
				</form>
			</div>
	
			<div id="div3" class="form-row" hidden="true">
				<form class="form-row customDiv3">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2>受測者權重設定</h2>
						</div>
						<div class="result-table-wrap">
							<table id="point" class="result-table">
								<thead>
									<tr>
										<th>使用者名稱</th>
										<th>權重</th>
										<th hidden="true">userid</th>
									</tr>
								</thead>
							</table>
						</div>
						<div class="btn-row">
							<button id="back2List-a3" class="btn btn-exec btn-wide">回列表頁</button>
							<button id="backPage-a3" class="btn btn-exec btn-wide">回上一頁</button>
							<button id="confirm" class="btn btn-exec btn-wide">建立量表</button>
						</div>
					</div>
				</form>
			</div>
			
			<div id="divTest" class="form-row" hidden="true">
				<form class="form-row customDivTest">
					<div class="search-result-wrap">
						<div class="form-row">
							<h2 id="product_name_test"></h2>
							<input type="hidden" id="forecast_id_test"></input>
							<input type="hidden" id="user_id_test"></input>
						</div>
						
						<table id="function-test" class="result-table">
							<div class="form-row">
								<h2>功能或產品性項目</h2>
							</div>
							<tr>
								<th>名稱</th>
								<th>分數</th>
							</tr>
						</table>
			
						<div class="form-row">
							<h2>非功能或產品性項目</h2>
						</div>
			
						<table id="nfunction-test" class="result-table">
							<tr>
								<th>名稱</th>
								<th>分數</th>
							</tr>
						</table>
			
						<div class="form-row">
							<h2>服務性項目</h2>
						</div>
			
						<table id="service-test" class="result-table">
							<tr>
								<th>名稱</th>
								<th>分數</th>
							</tr>
						</table>
						
						<div class="btn-row">
							<button id="confirmTest" class="btn btn-exec btn-wide">完成</button>
						</div>
					</div>
				</form>
			</div>
			
			<div class="input-field-wrap divFormStep1" hidden="true">
				<div class="form-wrap">
					<div class="form-row">
						<label>產品名稱</label>
						<input type="text" name="product_name"
								placeholder="輸入產品名稱">
					</div>
					<div class="form-row">
						<label>總成本</label>
						<input type="text" name="cost"
								placeholder="輸入總成本">
					</div>
					<div class="form-row">
						<label>參考產品</label>
						<input type="text" name="ref_prod"
								placeholder="輸入參考產品">
					</div>
					<div class="btn-row">
						<button class="btn btn-exec btn-wide btn-back2List">回列表頁</button>
						<button class="btn btn-exec btn-wide btn-2step2">下一步</button>
					</div>
				</div>
			</div>
			
			<div class="input-field-wrap divFormStep2" hidden="true">
				<div class="form-wrap">
					<div class="btn-row">
						<button class="btn btn-exec btn-wide btn_add_evaluate">新增評估產品項目</button>
					</div>
					
					<table id="tbl_wizard" class="result-table">
						<thead>
							<tr>
								<th>勾選</th>
								<th>項目類別</th>
								<th>項目名稱</th>
								<th>成本比例</th>
							</tr>
						</thead>
					</table>
					
					<div class="btn-row">
						<button class="btn btn-exec btn-wide btn-back2List">回列表頁</button>
						<button class="btn btn-exec btn-wide btn-2User">下一步</button>
					</div>
				</div>
			</div>
		</div>
		
		<script src="js/sbi/menu.js"></script>
		<footer class="footer">
			財團法人商業發展研究院  <span>電話(02)7707-4800 | 傳真(02)7713-3366</span> 
		</footer>
	</div>

	<!-- 資料選取表 -->
	<div id="dialog-type" title="項目" style="display:none;">
		<form name="dialog-type-form" id="dialog-type-form">
			<table name="tbl_type" class='result-table'>
				<thead>
					<tr>
						<th>勾選</th>
						<th>產業類別</th>
						<th>產品類別</th>
						<th>項目類別</th>
						<th>項目名稱</th>
					</tr>
				</thead>
			</table>
		</form>
	</div>
	
</body>
</html>