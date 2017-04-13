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
	<h2 class="page-title">目標城市</h2>
	<div class="search-result-wrap">
		<div id='view' style='background:#f8f8f8;padding:20px;border: 3px solid #666;margin:20px auto;width:860px;	border-radius: 8px;box-shadow: 10px 10px 5px #999;'>
			<form id='statistics' style='margin:20px;'>
				<table class='form-table'>
					<tr>
						<td><p>城市別：</p></td>
						<td>
							<select id="city" name="city"></select>
						</td>
					</tr>
					<tr>
						<td><p>架構：</p></td>
						<td>
							<select id="structure" name="structure"></select>
						</td>
					</tr>
					<tr>
						<td><p>Dimensions：</p></td>
						<td>
							<select id="dimensions" name="dimensions"></select>
						</td>
					</tr>
					<tr>
						<td><p>Target：</p></td>
						<td>
							<select id="target" name="target"></select>
						</td>
					</tr>
					<tr>
						<td><p>Second Target：</p></td>
						<td>
							<div id="second_target">
							</div>
						</td>
					</tr>
					<tr>
						<td><p>Type：</p></td>
						<td>
							<div id="type">
							</div>
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
					<a id='chart_vertical_bar' class='btn btn-primary'>長條圖</a>
					<a id='chart_pie' class='btn btn-primary'>圓餅圖</a>
					<a id='chart_data' class='btn btn-primary'>數據資料</a>
<!-- 					<a id='register2' class='btn btn-primary'>長條圖</a> -->

					<a id='btn_reset' class='btn btn-darkblue'>重設</a>
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
		
		$.ajax({
			type : "POST",
			url : "city.do",
			data : {
				action : "getCity"
			},
			success : function(result) {
				var json_obj = $.parseJSON(result);
				console.log(json_obj);
				$("#city").find('option').remove();
				$("#city").append($('<option></option>').val('').html(defaultValue));
				$.each(json_obj, function(i, item) {
					$("#city").append($('<option></option>').val(item.city).html(item.city));	
				});	
			}
		});
		
		$("#btn_reset").click(function(){
			$("#city").val('');
			$("#structure").find('option').remove();
			$("#dimensions").find('option').remove();
			$("#target").find('option').remove();
			$("#second_target").find('input').remove();
			$("#second_target").find('label').remove();
			$("#second_target").find('br').remove();
			$("#type").find('input').remove();
			$("#type").find('label').remove();
			$("#type").find('br').remove();
		});
		
		$("#city").change(function(){
			
			$("#structure").find('option').remove();
			$("#dimensions").find('option').remove();
			$("#target").find('option').remove();
			$("#second_target").find('input').remove();
			$("#second_target").find('label').remove();
			$("#second_target").find('br').remove();
			$("#type").find('input').remove();
			$("#type").find('label').remove();
			$("#type").find('br').remove();
			
			$.ajax({
				type : "POST",
				url : "city.do",
				data : {
					action : "getStructure",
					city : $("#city").val()
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					console.log("City Change");
					console.log(json_obj);
					$("#structure").find('option').remove();
					$("#structure").append($('<option></option>').val('').html(defaultValue));
					$.each(json_obj, function(i, item) {
						$("#structure").append($('<option></option>').val(item.structure).html(item.structure));	
					});	
				}
			});
		});		

		$("#structure").change(function(){
			
			$("#dimensions").find('option').remove();
			$("#target").find('option').remove();
			$("#second_target").find('input').remove();
			$("#second_target").find('label').remove();
			$("#second_target").find('br').remove();
			$("#type").find('input').remove();
			$("#type").find('label').remove();
			$("#type").find('br').remove();

			$.ajax({
				type : "POST",
				url : "city.do",
				data : {
					action : "getDimensions",
					city : $("#city").val(),
					structure : $("#structure").val()
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					console.log(json_obj);
					$("#dimensions").find('option').remove();
					$("#dimensions").append($('<option></option>').val('').html(defaultValue));
					$.each(json_obj, function(i, item) {
						$("#dimensions").append($('<option></option>').val(item.dimensions).html(item.dimensions));
					});	
				}
			});
		});		

		$("#dimensions").change(function(){

			$("#target").find('option').remove();
			$("#second_target").find('input').remove();
			$("#second_target").find('label').remove();
			$("#second_target").find('br').remove();
			$("#type").find('input').remove();
			$("#type").find('label').remove();
			$("#type").find('br').remove();

			$.ajax({
				type : "POST",
				url : "city.do",
				data : {
					action : "getTarget",
					city : $("#city").val(),
					structure : $("#structure").val(),
					dimensions : $("#dimensions").val()
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					console.log(json_obj);
					$("#target").find('option').remove();
					$("#target").append($('<option></option>').val('').html(defaultValue));
					$.each(json_obj, function(i, item) {
						$("#target").append($('<option></option>').val(item.target).html(item.target));	
					});	
				}
			});
		});		

		$("#target").change(function(){
			
			$("#second_target").find('input').remove();
			$("#second_target").find('label').remove();
			$("#second_target").find('br').remove();
			$("#type").find('input').remove();
			$("#type").find('label').remove();
			$("#type").find('br').remove();

			$.ajax({
				type : "POST",
				url : "city.do",
				data : {
					action : "getSecondTarget",
					city : $("#city").val(),
					structure : $("#structure").val(),
					dimensions : $("#dimensions").val(),
					target : $("#target").val()
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					console.log(json_obj);
					

					$("#second_target").find('input').remove();
					$("#second_target").find('label').remove();
					$("#second_target").find('br').remove();
					$.each(json_obj, function(i, item) {
						$("#second_target").append('<input type="checkbox" id="' + item.secondTarget + '" name="second_target" value="' + item.secondTarget + '">' +
						'<label for="' + item.secondTarget + '"><span class="form-label">' + item.secondTarget + '</span></label><br/><br/>');
					});	
				}
			});
		});
		
		$("#second_target").change(function(){
			
			$("#type").find('input').remove();
			$("#type").find('label').remove();
			$("#type").find('br').remove();
			
			var second_target_list = get_second_target_list();
			
			$.ajax({
				type : "POST",
				url : "city.do",
				data : {
					action : "getType",
					city : $("#city").val(),
					structure : $("#structure").val(),
					dimensions : $("#dimensions").val(),
					target : $("#target").val(),
					second_target : second_target_list
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					console.log(json_obj);
					

					$("#type").find('input').remove();
					$("#type").find('label').remove();
					$("#type").find('br').remove();
					$.each(json_obj, function(i, item) {
						$("#type").append('<input type="checkbox" id="' + item.type + '" name="type" value="' + item.type + '">' +
						'<label for="' + item.type + '"><span class="form-label">' + item.type + '</span></label>');
						if ((i+1) % 5 == 0) {
							$("#type").append('<br/><br/>');
						}
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
         	
			if (get_type_list() == '') {
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
			
			if (get_type_list() == '') {
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
			
			if (get_type_list() == '') {
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
	});
	
	function get_second_target_list() {
		var second_target_list = "";
		$('input[name="second_target"]').each(function() {
	         if($(this).is(":checked")) {
	        	 second_target_list += "'" + $(this).val() + "',";
	         }
    	});
		
		second_target_list = second_target_list.substring(0, second_target_list.length - 1);
		
		console.log("Function: second_target_list");
		console.log(second_target_list);
		return second_target_list;
	}

	function get_type_list() {
		var type_list = "";
		$('input[name="type"]').each(function() {
	         if($(this).is(":checked")) {
	        	 type_list += "'" + $(this).val() + "',";
	         }
    	});
		
		type_list = type_list.substring(0, type_list.length - 1);
		console.log("Function: get_type_list");
		console.log(type_list);
		
		return type_list;
	}
	
	function show_chart(chartOptions, isChart) {
		var second_target_list = get_second_target_list();
		var type_list = get_type_list();

		$.ajax({
			type : "POST",
			url : "city.do",
			data : {
				action : "getChart",
				city : $("#city").val(),
				structure : $("#structure").val(),
				dimensions : $("#dimensions").val(),
				target : $("#target").val(),
				second_target : second_target_list,
				type : type_list
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
				
				$('input[name="second_target"]').each(function() {
			         if($(this).is(":checked")) {
			        	 row_count++;
			        	 second_target_list += "<th>" + $(this).val() + "</th>";
			        	 row_title_arr.push($(this).val());
			         }
		    	});
				
				$('input[name="type"]').each(function() {
			         if($(this).is(":checked")) {
			        	 column_count++;
			        	 type_list += "<th>" + $(this).val() + "</th>";
			        	 column_title_arr.push($(this).val());
			         }
		    	});
				
				
				
				$("#resultTable").html('<thead><td>指標 &#92; 年份</td>' + type_list + '</thead>');
				
				$("#resultTable").append('<tbody>');
				
				
				for (var row = 0; row < row_count; row++) {
					var row_temp = "";
					for (var column = 0; column < column_count; column++) {
						
						var column_temp = "";
						$.each(json_obj, function(i, item) {
							if (row_title_arr[row] == item.secondTarget && column_title_arr[column] == item.type) {
								column_temp = '<td>' + item.data + '</td>';
							}
						});
						
						if (column_temp == "") {
							column_temp = '<td>No Data</td>';
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
