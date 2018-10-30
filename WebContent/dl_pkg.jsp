<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="import.jsp" flush="true"/>
<link rel="stylesheet" href="css/photo/jquery.fileupload.css">
<link rel="stylesheet" href="css/jquery.dataTables.min.css" />
<script type="text/javascript" src="js/jquery-migrate-1.4.1.min.js"></script>
<script type="text/javascript" src="js/jquery.validate.min.js"></script>
<script type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="js/additional-methods.min.js"></script>
<script type="text/javascript" src="js/messages_zh_TW.min.js"></script>

<!-- The jQuery UI widget factory, can be omitted if jQuery UI is already included -->
<script src="js/photo/vendor/jquery.ui.widget.js"></script>
<!-- The Load Image plugin is included for the preview images and image resizing functionality -->
<script src="js/photo/load-image.all.min.js"></script>
<!-- The Canvas to Blob plugin is included for image resizing functionality -->
<script src="js/photo/canvas-to-blob.min.js"></script>
<!-- Bootstrap JS is not required, but included for the responsive demo navigation -->
<script src="js/photo/bootstrap.min.js"></script>

</head>
<body>
<div class="page-wrapper">
	<div class="header">

	</div><!-- /.header -->

<div class="content-wrap">
	<h2 class="page-title">App下載</h2>
	<div class="input-field-wrap">
		<div class="">
			<div class="btn-row">
				<a href="app-release.apk" class="btn btn-exec btn-wide" download>Android</a>
			</div>
			
		</div>
		<div class="">
			<div class="btn-row">

				<a href="itms-services://?action=download-manifest&url=https://dl.dropboxusercontent.com/s/v2mz4d7djh5z139/manifest.plist" class="btn btn-exec btn-wide" download>
					<img src="images/image001.png" alt="CDRI" width="150" height="150">
					iOS
				</a>
			</div>
			
		</div>
	</div>

</div>
<jsp:include page="footer.jsp" flush="true"/>
