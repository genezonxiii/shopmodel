<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="import.jsp" flush="true"/>
	
	<link rel="stylesheet" href="css/jquery-ui.min.css">
	<link rel="stylesheet" href="css/font-awesome.min.css">
	<link rel="stylesheet" href="css/styles.css">
	
	<link rel="stylesheet" href="css/jquery.dataTables.min.css" />
	<link rel="stylesheet" href="css/buttons.dataTables.min.css"/>
	
	<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
	<script type="text/javascript" src="js/jquery-ui.min.js"></script>
	
	<script type="text/javascript" src="js/jquery.dataTables.min.js"></script>
	<script type="text/javascript" src="js/dataTables.buttons.min.js"></script>
	
	<script type="text/javascript" src="js/jquery.validate.min.js"></script>
	<script type="text/javascript" src="js/additional-methods.min.js"></script>
	<script type="text/javascript" src="js/messages_zh_TW.min.js"></script>
	<script type="text/javascript" src="js/common.js"></script>
	<script type="text/javascript" src="./js/jquery.form.js"></script>
	 
<style>
.search-result-wrap {
    margin-bottom: 20px;
}
.result-table{
	text-align: center;
	margin-top:20px;
}
.table1 td{
	padding: 5px 20px;
}
.table1 td:nth-child(1){
	text-align:right;
}
</style>
<script>
var timer =0;
	$(function(){
		$("#message").dialog({
			draggable : true, resizable : false, autoOpen : false,
			height : "auto", width : 400, modal : true,
			show : {effect : "size",duration : 300},
			hide : {effect : "fade",duration : 300},
			buttons : [{
						text : "確定",
						click : function() {
							$("#message").dialog("close");
						}
					}],
			close : function() {
				$("#message").dialog("close");
			}
		});
		draw_uploaddocs({"action": "select_all_uploaddoc"});
		$("#group-backstage-table").show();
		$("#group-backstage-table").delegate(".btn_delete", "click", function(e) {
			e.preventDefault();
			var id = $(this).attr("id");
			draw_uploaddocs({ action : "sp_del_upload_doc", id : id });
		});
		
		$('#form1').ajaxForm(function(result) {
			clearTimeout(timer);
			$("#submitbtn").removeAttr("disabled");
			$("#submitbtn").removeClass("btn-gray");
			var str = result;
			console.log(result);
			if(str!="fall"&& str.length>20){
				draw_uploaddocs({
					action :"sp_insert_upload_doc",
					title :$("#title").val(),
					summary :$("#summary").val(),
					show_name :$("#file").val().replace('C:\\fakepath\\',''),
					store_name :result
				});
			}else{
				$("#message").html("上傳失敗");
				$("#message").dialog("open");
			}
	    });
	});
	
	function draw_uploaddocs(parameter){
		var count=1;
		$("#group-backstage-table").hide();
		$("#group-backstage-table").DataTable({
// 	 		dom: "lfr<t>ip",
// 			dom: "<t>p",
			destroy: true,
			language: {
				"search" : "搜尋:",
				"paginate": { 
			        "previous": "←",
			        "next":     "→",
			    }
			},
			"order": [],
			ajax: {
					url : "uploaddoc.do",
					dataSrc: "",
					type : "POST",
					data : parameter
			},
	        columnDefs: [{
					targets: -1,
					searchable: false,
					orderable: false,
					render: function ( data, type, row ) {
						//fadeIn位置不對 之後再說
						var options =
							"<div class='table-row-func btn-in-table btn-gray'><i class='fa fa-ellipsis-h'></i>"+
							"	<div class='table-function-list' >"+
							"		<button class='btn-in-table btn-alert btn_delete' title='刪除' id = '" + row.id + "'>" +
							"		<i class='fa fa-trash'></i></button>"+
							"	</div>"+
							"</div>";
						return options;
					}
				}],columns: [
					{"data": "id" ,"defaultContent":""},
					{"data": "title" ,"defaultContent":""},
					{"data": "summary" ,"defaultContent":""},
					{"data": "show_name" ,"defaultContent":""},
					{"data": "store_name" ,"defaultContent":""},
					{"data": "upload_time" ,"defaultContent":""},
					{"data": null ,"defaultContent":""}
				],"initComplete": function(settings, json) {
					if(parameter["action"]=="sp_insert_upload_doc"){
						var tmp = $("#file").val();
						$("#title").val('');
						$("#summary").val('');
						$("#file").val('');
						$("#insert").slideToggle("slow");
						$("#message").html("上傳檔案: <br>"+tmp+"<br><br><div style='text-align:center;'>成功</div>");
						$("#message").dialog("open");
					}
					setTimeout(function(){
						$("#group-backstage-table").fadeIn();
					}, 200);

				  }
		});	
		
	}
	
	function uploaddoc(){
		
		var errormsg="";
		if($("#title").val()<1){errormsg+="<div style='text-align:center;'>請輸入標題<br>";}
		if($("#summary").val()<1){errormsg+="請輸入概述<br>";}
		if($("#file").val()<1){errormsg+="未選擇檔案<br></div>";}
		if(document.getElementById("file").files.item(0)!=null && document.getElementById("file").files.item(0).size>50*1024*1024){
			errormsg+="檔案大小超出上限!! 無法上傳。";
		}
		
		var tmp = $("#file").val().replace('C:\\fakepath\\','');
		$("#file").val(tmp);
		if(errormsg.length>2){
			$("#message").html(errormsg);
			$("#message").dialog("open");
			return false;
		}
		
		$("#submitbtn").attr("disabled","true");
		$("#submitbtn").addClass("btn-gray");
		$("#form1").attr("action","uploaddoc.do?action=upload_doc&file_name="+$("#file").val().replace('C:\\fakepath\\',''));
		timer = setTimeout(function(){ 
			$("#message").html("上傳逾時。");
			$("#message").dialog("open");
			timer=-1;
		},30*1000);
		return true;
	}
</script>
<jsp:include page="header.jsp" flush="true"/>
<div class="content-wrap">
	<h2 class="page-title">商機觀測站後臺</h2>
	<div class="search-result-wrap">
		<input type='button' class='btn btn-darkblue' value='增加檔案' onclick='$("#insert").slideToggle("slow");'>
		<div id='insert'style='background-color:#eee;padding:10px;margin:0 auto;display:none;'>
			<form action="uploaddoc.do?action=upload_doc" id="form1" method="post" enctype="multipart/form-data" style="margin:0px auto;">
				<table class='table1'>
				<tr><td>標題:</td><td><input type='text' id='title' placeholder='請輸入標題' style="width:calc(60vw);"></td></tr>
				<tr><td>概述:</td><td><textarea id='summary' placeholder='請輸入概述' style="width:calc(60vw);height:200px;"></textarea></td></tr>
				<tr><td>檔案上傳:<br><font style='color:red;'>(上限50MB)</font></td><td>
					<div style='border:1px solid #ccc;padding:5px 10px;width:calc(60vw);'><input type="file" id="file" name="file" accept=".csv,.pdf,.xls,.xlsx" /></div><br>
				</td></tr>
				<tr><td></td><td></td></tr>
				</table>
				<input type="submit" id="submitbtn" onclick="return uploaddoc()" value="檔案上傳" class="btn btn-exec btn-wide" style="color: #fff;margin-left:20px"/>
<!-- 				<span id="upload_msg" style="color:red;font-size:20px;margin-left:20px;line-height:40px;vertical-align:bottom;display:none;">資料傳輸中...請稍候!</span> -->
				<br><br>
			</form>
		</div>
		<br><br>
		<div style='margin:0px 80px;'>
			<table id="group-backstage-table" class="result-table smoothbottom" style='display:none;'>
				<thead>
					<tr>
						<th>編號</th>
						<th>標題</th>
						<th>概述</th>
						<th>DB名稱</th>
						<th>上傳名稱</th>
						<th>上架時間</th>					
						<th>功能</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table><br><br>
		</div>
		<div id='message'></div>
	</div>
</div>
<jsp:include page="footer.jsp" flush="true"/>