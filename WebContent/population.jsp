<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="import.jsp" flush="true"/>

<link rel="stylesheet" href="css/jquery.dataTables.min.css">
<script src="js/jquery.dataTables.min.js"></script>

<script>
	$( function() {	 
		
		
	    $(".tbl_xml").DataTable({
	    	dom : "lfr<t>i",
	    	"paging": false,
			destroy : true,
			language : {
				"url" : "js/dataTables_zh-tw.txt"
			},
			ajax : {
				url : "js/sbi/SBI_Data.xml",
				dataType: "xml",
				type: "GET",
				dataSrc : function ( xml, status ) {
					console.log("DataTable dataSrc");
			      	
			      	var list = [];
			      	
			      	$(xml).find('ROW').each(function(){
			      		var data_kind = $(this).find('data_kind').text();
			      		var date = $(this).find('date').text();
			      		var city = $(this).find('city').text();
			      		var description = $(this).find('description').text();
			      		var data_type = $(this).find('data_type').text();
			      		var url = $(this).find('url').text();
			      		var city = $(this).find('city').text();
			      		
			      		list.push({
			      			data_kind: data_kind,
			      			date: date,
			      			city: city,
			      			description: description,
							data_type: data_type,
							url: url
						});
			      		
			      	});
			      	
			      	result = $.map(list, function(item, i){
			      		return {
			      			data_kind: item.data_kind,
			      			date: item.date,
			      			city: item.city,
			      			description: item.description,
							data_type: item.data_type,
							url: item.url
		      			};
			      	});
			      	
			      	return result;
		      	}
			},
			columns : [ 
				{"data": "city", "defaultContent": ""},
				{"data": "description", "defaultContent": ""},
				{"data": null, "defaultContent": ""}
			],
			columnDefs: [{
				targets: 2,
			   	searchable: false,
			   	orderable: false,
			   	render: function ( data, type, row ) {
			   		var options = $("<div/>") //fake tag
				   		.append( $("<div/>", {"class": "table-row-func btn-in-table btn-gray"}) 
							.append( $("<i/>", {"class": "fa fa-ellipsis-h"}) )
							.append( 
								$("<div/>", {"class": "table-function-list"})
						   			.append( 
										$("<button/>", {
											"class": "btn-in-table btn-darkblue btn_update",
											"title": "更新資料庫"
										})
										.append( $("<i/>", {"class": "fa fa-database"}) )
									)
									.append( 
										$("<button/>", {
											"class": "btn-in-table btn-alert btn_download",
											"title": "下載資料"
										})
										.append( $("<i/>", {"class": "fa fa-download"}) )
									)
							)
						);
					
					return options.html();
			   	}
			}]
	    });
	    
	    $(".tbl_xml").on("click", ".btn_update", function(){
	    	//更新資料庫
	    	var row = $(this).closest("tr");
		    var data = $(".tbl_xml").DataTable().row(row).data();
		    var kind = "";
		    
		    switch (data.data_kind) {
				case "a":
					kind = "sex_age";
					break;
				case "k":
					kind = "sex_age_edu";
					break;
				case "l":
					kind = "sex_marriage";
					break;
				case "i":
					kind = "pop_index";
					break;
		    };
		    
	    	$.ajax({
				type : "POST",
				url : "population.do",
				data : {
					action : "update_db",
					url : data.url,
					kind : kind,
					type : data.data_type
				},
				success : function(result) {
					alert(result);
				}
			});
	    })
	    
	    $(".tbl_xml").on("click", ".btn_download", function(){
	    	//下載資料
	    	var row = $(this).closest("tr");
		    var data = $(".tbl_xml").DataTable().row(row).data();
		    
		    var filename = data.city + "_" + data.description + ".json";
		    
	    	$.getJSON(data.url, function(data){
		  		var jsonData = JSON.stringify(data);
		  		var link = document.createElement('a');
		  		
			    link.download = filename;
			    link.href = 'data:text/json;charset=utf8,' + jsonData;
			    link.click();
		  	});
	    });
	    
	    $("#btn_update_all").on("click", function(){
	    	//全部更新
	    	var table = $(".tbl_xml").DataTable();
			
			table.rows().every( function ( rowIdx, tableLoop, rowLoop ) {
			    var data = this.data();
			    var node = this.node();
			    
			    if (data.data_kind != 'a' && data.data_kind != 'k' && data.data_kind != 'l'){
			    	console.log("not in a, k, l");
			    	return;
			    }
			    
			    var kind = "";
			    
			    switch (data.data_kind) {
					case "a":
						kind = "sex_age";
						break;
					case "k":
						kind = "sex_age_edu";
						break;
					case "l":
						kind = "sex_marriage";
						break;
			    };
			    
			    console.log("rowIdx:" + rowIdx);
			    console.log(data.url);
			    console.log(kind);
			    console.log(data.data_type);
			    
			    setTimeout(function(){ 
			    	$.ajax({
						type : "POST",
						url : "population.do",
						data : {
							action : "update_db",
							url : data.url,
							kind : kind,
							type : data.data_type
						},
						success : function(result) {
							console.log(result);
						}
					});
			    }, 3000);
			});
	    });
	});
</script>
<jsp:include page="header.jsp" flush="true"/>
	<div class="content-wrap">
		<h2 class="page-title">台灣人口社經</h2>
		<div class="search-result-wrap">
			<div id="dialog" title="更新資料庫" style='display: none;'>
			  <div class="progress-label">準備更新</div>
			  <div id="progressbar"></div>
			</div>
			<div id="progress" class="progress" style='display: none;'>
			    <div id="progress_bar" class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width:0%">
			      0%
			    </div>
		 	</div>
			<div>		   
				<table class="tbl_option">
					<thead>
						<tr style='display: none;'>
							<td align="right"><h4>選擇類別：</h4></td>
							<td align="center">
								<input type="radio" name="data_kind" id="sex_age" value="sex_age" onclick="showSexAge();" checked>
								<label for="sex_age"><span class="form-label">性別人口統計</span></label>
							</td>
							<td align="center">
								<input type="radio" name="data_kind" id="sex_age_edu" value="sex_age_edu" onclick="showSexAgeEdu();">
								<label for="sex_age_edu"><span class="form-label">年齡組與性別與教育程度人口統計</span></label>
							</td>
							<td align="center">
								<input type="radio" name="data_kind" id="sex_marriage" value="sex_marriage" onclick="showSexMarriage();">
								<label for="sex_marriage"><span class="form-label">性別與婚姻狀況統計</span></label>							
							</td>
						</tr>
						<tr>
							<td align="right"><h4>全部更新：</h4></td>
							<td>
								<button id="btn_update_all" class="btn btn-exec">確認更新</button>
							</td>
						</tr>
					</thead>
				</table>
				
				<table class="tbl_xml">
					<thead>
						<tr>
							<th>縣市資料</th>
							<th>資料內容</th>
							<th>更新資料庫</th>
						</tr>
					</thead>
				</table>
		    </div>
		</div>
	</div>
<jsp:include page="footer.jsp" flush="true"/>