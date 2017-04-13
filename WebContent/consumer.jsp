<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="import.jsp" flush="true"/>
<script src="js/d3.v3.min.js"></script>
<script type="text/javascript" src="js/jquery-migrate-1.4.1.min.js"></script>
<script type="text/javascript" src="js/jquery.validate.min.js"></script>
<script type="text/javascript" src="js/additional-methods.min.js"></script>
<script type="text/javascript" src="js/messages_zh_TW.min.js"></script>

<!--  use for Visualize -->
<link type="text/css" rel="stylesheet" href="./css/visualize.jQuery.css"/>
<script type="text/javascript" src="./js/visualize.jQuery.js"></script>
		
<!--  css for d3js -->
<style>
table.form-table{
	border-collapse: separate;
	border-spacing: 0px;
	margin-right: 30px;
	font-family: "微軟正黑體", "Microsoft JhengHei", 'LiHei Pro', Arial, Helvetica, sans-serif, \5FAE\8EDF\6B63\9ED1\9AD4,\65B0\7D30\660E\9AD4;
}
table.form-table tr td:nth-child(2n+1) {
    text-align: right;
    padding-left: 4px;
    padding-bottom: 5px;
}
table.form-table tr td:nth-child(2n) {
    text-align: left;
}
input[type=text].error{
    border: 1px solid #e92500;
    background: rgb(255, 213, 204);
}
table.accessHide {
	position: absolute;
	left: -999999px;
}

/*sample alternate styling for info block on Pie Chart */
/* .visualize-pie .visualize-info { top: -150px; border: 0; right: auto; left: 10px; padding: 0; background: none; } */
/* .visualize-pie ul.visualize-title { font-weight: bold; border: 0; } */
/* .visualize-pie ul.visualize-key li { float: none; } */
</style>

<!--<div id="msgAlert"></div>-->

<jsp:include page="header.jsp" flush="true"/>
<div class="content-wrap">
	<h2 class="page-title">消費力</h2>
	<div class="search-result-wrap">
		<div id='div_step1' style='background:#f8f8f8;padding:20px;border: 3px solid #666;margin:20px auto;width:860px;	border-radius: 8px;box-shadow: 10px 10px 5px #999;'>
			<form style='margin:20px;'>
				<table class='form-table'>
					<tr>
						<td><p>城市：</p></td>
						<td>
							<div id="city">
							</div>
						</td>
					</tr>
				</table>
				
				<div align='center'>
					<a id='btn_step1_next' class='btn btn-gray'>下一頁</a>
					<a class='btn_reset btn btn-darkblue'>重設</a>
				</div>
			</form>
		</div>
		
		<div id='div_step2' style='background:#f8f8f8;padding:20px;border: 3px solid #666;margin:20px auto;width:860px;	border-radius: 8px;box-shadow: 10px 10px 5px #999;'>
			<form style='margin:20px;'>
				<table class='form-table'>
					<tr>
						<td><p>層：</p></td>
						<td>
							<select id="layer" name="layer"></select>
						</td>
					</tr>
					<tr>
						<td><p>類別：</p></td>
						<td>
							<select id="type" name="type"></select>
						</td>
					</tr>
					<tr>
						<td><p>項目：</p></td>
						<td>
							<select id="item" name="item"></select>
						</td>
					</tr>
					<tr>
						<td><p>子項目：</p></td>
						<td>
							<select id="subitem" name="subitem"></select>
						</td>
					</tr>
					<tr>
						<td><p>變數名稱：</p></td>
						<td>
							<div id="variable_name">
							</div>
						</td>
					</tr>
				</table>
				
				<div align='center'>
					<a id='btn_step2_prev' class='btn btn-gray'>上一頁</a>
					<a id='btn_step2_next' class='btn btn-gray'>下一頁</a>

					<a class='btn_reset btn btn-darkblue'>重設</a>
				</div>
			</form>
		</div>
		
		
		<div id='div_step3' style='background:#f8f8f8;padding:20px;border: 3px solid #666;margin:20px auto;width:860px;	border-radius: 8px;box-shadow: 10px 10px 5px #999;'>
			<form id='statistics' style='margin:20px;'>
				<table class='form-table'>
					<tr>
						<td><p>年份：</p></td>
						<td>
							<select id="year" name="year"></select>
						</td>
					</tr>
					<tr>
						<td><p>產生圖形選擇：</p></td>
						<td>
						</td>
					</tr>
				</table>
				
				<div id="chart" style="padding-top: 30px;padding-left: 70px;">
					<table id="resultTable" class="result-table">
						<th>產品名稱</th>
						<th></th>
					</table>
				</div>

				<div align='center'>
				
					<a id='btn_step3_prev' class='btn btn-gray'>上一頁</a>
					
					<a id='chart_vertical_bar' class='btn btn-primary'>長條圖</a>
					<a id='chart_pie' class='btn btn-primary'>圓餅圖</a>
					<a id='chart_data' class='btn btn-primary'>數據資料</a>

					<a class='btn_reset btn btn-darkblue'>重設</a>
				</div>
			</form>
		</div>
	</div>
</div>
<script>
	$(function(){
		var defaultValue = "請選擇";
		var color_array = ['#e9e744','#666699','#92d5ea','#ee8310','#8d10ee',
			'#5a3b16','#26a4ed','#f45a90','#be1e2d','#FA5858',
			'#F4FA58','#58FA82','#DA81F5','#00FF40','#FAAC58',
			'#013ADF','#DF3A01','#8181F7','#F5A9BC','#04B45F',];
		
		main_load();
		
		
		
		$(".btn_reset").click(function(){
			
			$('input[name="city"]').each(function() {
		         if($(this).is(":checked")) {
		        	 $(this).prop('checked', false);
		         }
	    	});
			$("#layer").find('option').remove();
			$("#type").find('option').remove();
			$("#item").find('option').remove();
			$("#subitem").find('option').remove();
			$("#variable_name").find('input').remove();
			$("#variable_name").find('label').remove();
			$("#variable_name").find('br').remove();
			$("#year").find('option').remove();
			
			$('#div_step1').show();
			$('#div_step2').hide();
			$('#div_step3').hide();
		});
		
		$("#city").change(function(){
			
			$("#layer").find('option').remove();
			$("#type").find('option').remove();
			$("#item").find('option').remove();
			$("#subitem").find('option').remove();
			$("#variable_name").find('input').remove();
			$("#variable_name").find('label').remove();
			$("#variable_name").find('br').remove();
			$("#year").find('option').remove();

			var city_list = get_city_list();
			
			$.ajax({
				type : "POST",
				url : "consumer.do",
				data : {
					action : "getLayer",
					city : city_list
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					console.log("Layer Change");
					console.log(json_obj);
					$("#layer").find('option').remove();
					$("#layer").append($('<option></option>').val('').html(defaultValue));
					$.each(json_obj, function(i, item) {
						$("#layer").append($('<option></option>').val(item.layer).html(item.layer));	
					});	
				}
			});
		});	
		
		$("#layer").change(function(){
			
			$("#type").find('option').remove();
			$("#item").find('option').remove();
			$("#subitem").find('option').remove();
			$("#variable_name").find('input').remove();
			$("#variable_name").find('label').remove();
			$("#variable_name").find('br').remove();
			$("#year").find('option').remove();

			var city_list = get_city_list();

			$.ajax({
				type : "POST",
				url : "consumer.do",
				data : {
					action : "getType",
					city : city_list,
					layer : $("#layer").val()
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					console.log(json_obj);
					$("#type").find('option').remove();
					$("#type").append($('<option></option>').val('').html(defaultValue));
					$.each(json_obj, function(i, item) {
						$("#type").append($('<option></option>').val(item.type).html(item.type));
					});	
				}
			});
		});

		$("#type").change(function(){
			
			$("#item").find('option').remove();
			$("#subitem").find('option').remove();
			$("#variable_name").find('input').remove();
			$("#variable_name").find('label').remove();
			$("#variable_name").find('br').remove();
			$("#year").find('option').remove();

			var city_list = get_city_list();

			$.ajax({
				type : "POST",
				url : "consumer.do",
				data : {
					action : "getItem",
					city : city_list,
					layer : $("#layer").val(),
					type : $("#type").val()
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					console.log(json_obj);
					$("#item").find('option').remove();
					$("#item").append($('<option></option>').val('').html(defaultValue));
					$.each(json_obj, function(i, item) {
						$("#item").append($('<option></option>').val(item.item).html(item.item));
					});	
				}
			});
		});		

		$("#item").change(function(){

			$("#subitem").find('option').remove();
			$("#variable_name").find('input').remove();
			$("#variable_name").find('label').remove();
			$("#variable_name").find('br').remove();
			$("#year").find('option').remove();

			var city_list = get_city_list();

			$.ajax({
				type : "POST",
				url : "consumer.do",
				data : {
					action : "getSubItem",
					city : city_list,
					layer : $("#layer").val(),
					type : $("#type").val(),
					item : $("#item").val()
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					var flag = false;
					console.log(json_obj);
					$("#subitem").find('option').remove();
					$("#subitem").append($('<option></option>').val('').html(defaultValue));
					$.each(json_obj, function(i, item) {
						if (item.subItem == "") {
							flag = true;
						} else {
							$("#subitem").append($('<option></option>').val(item.subItem).html(item.subItem));
						}
					});	
					
					if (flag) {
						generate_variable_name('item');
					}
				}
			});
		});		

		$("#subitem").change(function(){
			
			$("#variable_name").find('input').remove();
			$("#variable_name").find('label').remove();
			$("#variable_name").find('br').remove();
			$("#year").find('option').remove();

			
			generate_variable_name('subitem');
			
		});
		
		$("#variable_name").change(function(){
			
			$("#year").find('option').remove();
			
			var city_list = get_city_list();
			var variable_name_list = get_variable_name_list();
			
			$.ajax({
				type : "POST",
				url : "consumer.do",
				data : {
					action : "getYear",
					city : city_list,
					layer : $("#layer").val(),
					type : $("#type").val(),
					item : $("#item").val(),
					subitem : $("#subitem").val(),
					variable_name : variable_name_list
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					console.log(json_obj);

					$("#year").find('option').remove();
					$("#year").append($('<option></option>').val('').html(defaultValue));
					$.each(json_obj, function(i, item) {
						$("#year").append($('<option></option>').val(item.year).html(item.year));	
					});
				}
			});
		});
		
		$("#chart_vertical_bar").click(function(){
			var chartOptions = "";
				
			chartOptions = {
				'width':'700',
				'height':'300',
				'type':'bar',
				'barMargin':'1',
				'barGroupMargin':'20',
				'appendTitle':'true',
				'appendKey':'true',
				'textColors':'',
				'parseDirection':'x',
				'colors': color_array
			};
         	
			if (get_city_list() == '' || get_variable_name_list() == '' || $("#year").val() == '') {
				warningMsg("警告", "尚有資料未填寫完畢");
				return;
			}
			
			show_chart(chartOptions, true);
		});

		$("#chart_data").click(function(){
			var chartOptions = "";
				
			chartOptions = {
				'width':'700',
				'height':'350',
				'type':'area',
				'lineWeight':'4',
				'appendTitle':'true',
				'appendKey':'true',
				'textColors':'',
				'parseDirection':'x',
				'colors': color_array
			};
			
			if (get_city_list() == '' || get_variable_name_list() == '' || $("#year").val() == '') {
				warningMsg("警告", "尚有資料未填寫完畢");
				return;
			}
			
			show_chart(chartOptions, false);
		});

		$("#chart_pie").click(function(){
			var chartOptions = "";
				
			chartOptions = {
				'width':'700',
				'height':'350',
				'type':'pie',
				'pieMargin':'20',
				'pieLabelPos':'outside',
				'lineWeight':'4',
				'appendTitle':'true',
				'appendKey':'true',
				'textColors':'',
				'parseDirection':'x',
				'colors': color_array
			};
			
			if (get_city_list() == '' || get_variable_name_list() == '' || $("#year").val() == '') {
				warningMsg("警告", "尚有資料未填寫完畢");
				return;
			}
			
			show_chart(chartOptions, true);
		});
		
		chart = $("#chart").dialog({
			title: '結果圖表',
			draggable : false,//防止拖曳
			resizable : false,//防止縮放
			autoOpen : false,
			width : 800,
			height : 600,
			modal : true,
			buttons : [{
				text : "關閉",
				className: 'save',
				click : function() {
					chart.dialog("close");
				}
			}]
		});
		
		$("#btn_step1_next").click(function(event){
			event.preventDefault();
			
			$('#div_step1').hide();
			$('#div_step2').show();
			$('#div_step3').hide();
		});
		
		$("#btn_step2_next").click(function(event){
			event.preventDefault();
			
			$('#div_step1').hide();
			$('#div_step2').hide();
			$('#div_step3').show();
		});
		
		$("#btn_step2_prev").click(function(event){
			event.preventDefault();
			
			$('#div_step1').show();
			$('#div_step2').hide();
			$('#div_step3').hide();
		});
		
		$("#btn_step3_prev").click(function(event){
			event.preventDefault();
			
			$('#div_step1').hide();
			$('#div_step2').show();
			$('#div_step3').hide();
		});
	});
	
	function main_load() {
		$.ajax({
			type : "POST",
			url : "consumer.do",
			data : {
				action : "getCity"
			},
			success : function(result) {
				var json_obj = $.parseJSON(result);
				console.log(json_obj);

				$("#city").find('input').remove();
				$("#city").find('label').remove();
				$("#city").find('br').remove();
				$.each(json_obj, function(i, item) {
					
					$("#city").append('<input type="checkbox" id="city_' + i + '" name="city" value="' + item.city + '">' +
					'<label for="city_' + i + '"><span class="form-label">' + item.city + '</span></label>');
					if ((i+1) % 7 == 0) {
						$("#city").append('<br/>');
					}
				});	
			}
		});
		
		$('#div_step1').show();
		$('#div_step2').hide();
		$('#div_step3').hide();
	}
	
	function generate_variable_name(kind) {
		
		var city_list = get_city_list();
		var variable_name_list = get_variable_name_list();
		
		var data;
		if (kind == 'item') {
			data = {
					action : "getVariableName",
					city : city_list,
					layer : $("#layer").val(),
					type : $("#type").val(),
					item : $("#item").val()
			};
		} else if (kind == 'subitem') {
			data = {
					action : "getSubItemVariableName",
					city : city_list,
					layer : $("#layer").val(),
					type : $("#type").val(),
					item : $("#item").val(),
					subitem : $("#subitem").val()
			};
		}
		
		$.ajax({
			type : "POST",
			url : "consumer.do",
			data : data,
			success : function(result) {
				var json_obj = $.parseJSON(result);
				console.log(json_obj);

				$("#variable_name").find('input').remove();
				$("#variable_name").find('label').remove();
				$("#variable_name").find('br').remove();
				$.each(json_obj, function(i, item) {
					
					$("#variable_name").append('<input type="checkbox" id="variable_name_' + i + '" name="variable_name" value="' + item.variableName + '">' +
						'<label for="variable_name_' + i + '"><span class="form-label">' + item.variableName + '</span></label>');
					if ((i+1) % 2 == 0) {
						$("#variable_name").append('<br/><br/>');
					}
					
				});	
			}
		});
	}
	
	function get_city_list() {
		var city_list = "";
		$('input[name="city"]').each(function() {
	         if($(this).is(":checked")) {
	        	 city_list += "'" + $(this).val() + "',";
	         }
    	});
		
		city_list = city_list.substring(0, city_list.length - 1);
		
		console.log("Function: city_list");
		console.log(city_list);
		return city_list;
	}

	function get_variable_name_list() {
		var variable_name_list = "";
		$('input[name="variable_name"]').each(function() {
	         if($(this).is(":checked")) {
	        	 variable_name_list += "'" + $(this).val() + "',";
	         }
    	});
		
		variable_name_list = variable_name_list.substring(0, variable_name_list.length - 1);
		console.log("Function: get_variable_name_list");
		console.log(variable_name_list);
		
		return variable_name_list;
	}
	
	function show_chart(chartOptions, isChart) {
		var city_list = get_city_list();
		var variable_name_list = get_variable_name_list();
		
		$.ajax({
			type : "POST",
			url : "consumer.do",
			data : {
				action : "getChart",
				city : city_list,
				variable_name : variable_name_list,
				year : $("#year").val()
			},
			success : function(result) {
				var json_obj = $.parseJSON(result);
				console.log(json_obj);
				
				chart.dialog("open");
				
				var row_count = 0;
				var row_title_list = "";
				var row_title_arr = [];
				
				var column_count = 0;
				var column_title_list = "";
				var column_title_arr = [];
				
				var row_data = [];
				
				$('input[name="variable_name"]').each(function() {
			         if($(this).is(":checked")) {
			        	 row_count++;
			        	 variable_name_list += "<th>" + $(this).val() + "</th>";
			        	 row_title_arr.push($(this).val());
			         }
		    	});
				
				$('input[name="city"]').each(function() {
			         if($(this).is(":checked")) {
			        	 column_count++;
			        	 city_list += "<th>" + $(this).val() + "</th>";
			        	 column_title_arr.push($(this).val());
			         }
		    	});
				
				
				
				$("#resultTable").html('<thead><td>指標 &#92; 城市</td>' + city_list + '</thead>');
				
				$("#resultTable").append('<tbody>');
				
				
				for (var row = 0; row < row_count; row++) {
					var row_temp = "";
					for (var column = 0; column < column_count; column++) {
						
						var column_temp = "";
						$.each(json_obj, function(i, item) {
							if (row_title_arr[row] == item.variableName && column_title_arr[column] == item.city) {
								column_temp = '<td>' + item.data + '</td>';
							}
						});
						
						if (column_temp == "") {
							console.log("No Data");
							column_temp = '<td>0</td>';
						}
						
						row_temp += column_temp;

					}
					
					$("#resultTable").append('<tr><th>' + row_title_arr[row] + '</th>' + row_temp + '</tr>');

				}
				
				$("#resultTable").append('</tbody>');
				
				if (isChart) {
					$('#resultTable').visualize();
					
					//hide table
					$('#resultTable').addClass('accessHide');
					
					$('.visualize').remove();
					$('#resultTable').visualize(chartOptions);					
				} else {
					//show table
					$('#resultTable').removeClass('accessHide');
					
					$('.visualize').remove();

					var top = ($("#chart").height() - $("#resultTable").height()) / 2;
					$("#chart")
						.css("padding-top", top + "px")
						.css("padding-left", "50px");
				}

			}
		});
	}
</script>
<jsp:include page="footer.jsp" flush="true"/>
