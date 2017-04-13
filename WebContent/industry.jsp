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
	<h2 class="page-title">目標產業</h2>
	<div class="search-result-wrap">
		<div id='view' style='background:#f8f8f8;padding:20px;border: 3px solid #666;margin:20px auto;width:860px;	border-radius: 8px;box-shadow: 10px 10px 5px #999;'>
			<form id='statistics' style='margin:20px;'>
				<table class='form-table'>
					<tr>
						<td><p>國家別：</p></td>
						<td>
							<select id="country" name="country"></select>
						</td>
					</tr>
					<tr>
						<td><p>產業類別：</p></td>
						<td>
							<select id="industry_type" name="industry_type"></select>
						</td>
					</tr>
					<tr>
						<td><p>構面：</p></td>
						<td>
							<select id="source" name="source"></select>
						</td>
					</tr>
					<tr>
						<td><p>子構面：</p></td>
						<td>
							<select id="subsource" name="subsource"></select>
						</td>
					</tr>
					<tr>
						<td><p>指標：</p></td>
						<td>
							<div id="categories">
							</div>
						</td>
					</tr>
					<tr>
						<td><p>年份：</p></td>
						<td>
							<div id="categories_year">
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
			url : "industry.do",
			data : {
				action : "getCountry"
			},
			success : function(result) {
				var json_obj = $.parseJSON(result);
				console.log(json_obj);
				$("#country").find('option').remove();
				$("#country").append($('<option></option>').val('').html(defaultValue));
				$.each(json_obj, function(i, item) {
					$("#country").append($('<option></option>').val(item.country).html(item.country));	
				});	
			}
		});
		
		$("#btn_reset").click(function(){
			$("#country").val('');
			$("#industry_type").find('option').remove();
			$("#source").find('option').remove();
			$("#subsource").find('option').remove();
			$("#categories").find('input').remove();
			$("#categories").find('label').remove();
			$("#categories").find('br').remove();
			$("#categories_year").find('input').remove();
			$("#categories_year").find('label').remove();
			$("#categories_year").find('br').remove();
		});
		
		$("#country").change(function(){
			
			$("#industry_type").find('option').remove();
			$("#source").find('option').remove();
			$("#subsource").find('option').remove();
			$("#categories").find('input').remove();
			$("#categories").find('label').remove();
			$("#categories").find('br').remove();
			$("#categories_year").find('input').remove();
			$("#categories_year").find('label').remove();
			$("#categories_year").find('br').remove();
			
			$.ajax({
				type : "POST",
				url : "industry.do",
				data : {
					action : "getType",
					country : $("#country").val()
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					console.log("Country Change");
					console.log(json_obj);
					$("#industry_type").find('option').remove();
					$("#industry_type").append($('<option></option>').val('').html(defaultValue));
					$.each(json_obj, function(i, item) {
						$("#industry_type").append($('<option></option>').val(item.industryType).html(item.industryType));	
					});	
				}
			});
		});		

		$("#industry_type").change(function(){
			
			$("#source").find('option').remove();
			$("#subsource").find('option').remove();
			$("#categories").find('input').remove();
			$("#categories").find('label').remove();
			$("#categories").find('br').remove();
			$("#categories_year").find('input').remove();
			$("#categories_year").find('label').remove();
			$("#categories_year").find('br').remove();

			$.ajax({
				type : "POST",
				url : "industry.do",
				data : {
					action : "getSource",
					country : $("#country").val(),
					industry_type : $("#industry_type").val()
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					console.log(json_obj);
					$("#source").find('option').remove();
					$("#source").append($('<option></option>').val('').html(defaultValue));
					$.each(json_obj, function(i, item) {
						$("#source").append($('<option></option>').val(item.source).html(item.source));
					});	
				}
			});
		});		

		$("#source").change(function(){

			$("#subsource").find('option').remove();
			$("#categories").find('input').remove();
			$("#categories").find('label').remove();
			$("#categories").find('br').remove();
			$("#categories_year").find('input').remove();
			$("#categories_year").find('label').remove();
			$("#categories_year").find('br').remove();

			$.ajax({
				type : "POST",
				url : "industry.do",
				data : {
					action : "getSubsource",
					country : $("#country").val(),
					industry_type : $("#industry_type").val(),
					source : $("#source").val()
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					console.log(json_obj);
					$("#subsource").find('option').remove();
					$("#subsource").append($('<option></option>').val('').html(defaultValue));
					$.each(json_obj, function(i, item) {
						$("#subsource").append($('<option></option>').val(item.subsource).html(item.subsource));	
					});	
				}
			});
		});		

		$("#subsource").change(function(){
			
			$("#categories").find('input').remove();
			$("#categories").find('label').remove();
			$("#categories").find('br').remove();
			$("#categories_year").find('input').remove();
			$("#categories_year").find('label').remove();
			$("#categories_year").find('br').remove();

			$.ajax({
				type : "POST",
				url : "industry.do",
				data : {
					action : "getCategories",
					country : $("#country").val(),
					industry_type : $("#industry_type").val(),
					source : $("#source").val(),
					subsource : $("#subsource").val()
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					console.log(json_obj);
					

					$("#categories").find('input').remove();
					$("#categories").find('label').remove();
					$("#categories").find('br').remove();
					$.each(json_obj, function(i, item) {
						$("#categories").append('<input type="checkbox" id="' + item.categories + '" name="categories" value="' + item.categories + '">' +
						'<label for="' + item.categories + '"><span class="form-label">' + item.categories + '</span></label>');
						if ((i+1) % 2 == 0) {
							$("#categories").append('<br/><br/>');
						}
						
					});	
				}
			});
		});
		
		$("#categories").change(function(){
			
			$("#categories_year").find('input').remove();
			$("#categories_year").find('label').remove();
			$("#categories_year").find('br').remove();
			
			var categories_list = get_categories_list();
			
			$.ajax({
				type : "POST",
				url : "industry.do",
				data : {
					action : "getCategoriesYear",
					country : $("#country").val(),
					industry_type : $("#industry_type").val(),
					source : $("#source").val(),
					subsource : $("#subsource").val(),
					categories : categories_list
				},
				success : function(result) {
					var json_obj = $.parseJSON(result);
					console.log(json_obj);
					

					$("#categories_year").find('input').remove();
					$("#categories_year").find('label').remove();
					$("#categories_year").find('br').remove();
					$.each(json_obj, function(i, item) {
						$("#categories_year").append('<input type="checkbox" id="' + item.categoriesYear + '" name="categories_year" value="' + item.categoriesYear + '">' +
						'<label for="' + item.categoriesYear + '"><span class="form-label">' + item.categoriesYear + '</span></label>');
						if ((i+1) % 5 == 0) {
							$("#categories_year").append('<br/><br/>');
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
         	
			if (get_categories_year_list() == '') {
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
			
			if (get_categories_year_list() == '') {
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
			
			if (get_categories_year_list() == '') {
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
	
	function get_categories_list() {
		var categories_list = "";
		$('input[name="categories"]').each(function() {
	         if($(this).is(":checked")) {
	        	 categories_list += "'" + $(this).val() + "',";
	         }
    	});
		
		categories_list = categories_list.substring(0, categories_list.length - 1);
		
		console.log("Function: categories_list");
		console.log(categories_list);
		return categories_list;
	}

	function get_categories_year_list() {
		var categories_year_list = "";
		$('input[name="categories_year"]').each(function() {
	         if($(this).is(":checked")) {
	        	 categories_year_list += "'" + $(this).val() + "',";
	         }
    	});
		
		categories_year_list = categories_year_list.substring(0, categories_year_list.length - 1);
		console.log("Function: get_categories_year_list");
		console.log(categories_year_list);
		
		return categories_year_list;
	}
	
	function show_chart(chartOptions, isChart) {
		var categories_list = get_categories_list();
		var categories_year_list = get_categories_year_list();

		$.ajax({
			type : "POST",
			url : "industry.do",
			data : {
				action : "getChart",
				country : $("#country").val(),
				industry_type : $("#industry_type").val(),
				source : $("#source").val(),
				subsource : $("#subsource").val(),
				categories : categories_list,
				categories_year : categories_year_list
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
				
				$('input[name="categories"]').each(function() {
			         if($(this).is(":checked")) {
			        	 row_count++;
			        	 categories_list += "<th>" + $(this).val() + "</th>";
			        	 row_title_arr.push($(this).val());
			         }
		    	});
				
				$('input[name="categories_year"]').each(function() {
			         if($(this).is(":checked")) {
			        	 column_count++;
			        	 categories_year_list += "<th>" + $(this).val() + "</th>";
			        	 column_title_arr.push($(this).val());
			         }
		    	});
				
				
				
				$("#resultTable").html('<thead><td>指標 &#92; 年份</td>' + categories_year_list + '</thead>');
				
				$("#resultTable").append('<tbody>');
				
				
				for (var row = 0; row < row_count; row++) {
					var row_temp = "";
					for (var column = 0; column < column_count; column++) {
						
						var column_temp = "";
						$.each(json_obj, function(i, item) {
							if (row_title_arr[row] == item.categories && column_title_arr[column] == item.categoriesYear) {
								column_temp = '<td>' + item.categoriesData + '</td>';
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
