<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="tilesx" uri="http://tiles.apache.org/tags-tiles-extras"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><tiles:insertAttribute name="title" defaultValue="FormBuilder" defaultValueType="string" /></title>
<link rel="stylesheet" href="<c:url value='/assets/vendors/bootstrap-3.3.7-dist/css/bootstrap.min.css' />">
<link rel="stylesheet" href="<c:url value='/assets/vendors/bootstrap-material-design/css/bootstrap-material-design.min.css' />">
<link rel="stylesheet" href="<c:url value='/assets/vendors/bootstrap-material-design/css/ripples.min.css' />">
<link rel="stylesheet" href="<c:url value='/assets/vendors/DataTables-1.10.13/css/dataTables.bootstrap.css' />">
<link rel="stylesheet" href="<c:url value='/assets/vendors/jquery-ui-themes-1.12.1/jquery-ui.css' />">
<link rel="stylesheet" href="<c:url value='/assets/resources/css/formbuilder.css' />">

<script src="<c:url value='/assets/vendors/jquery/jquery-3.2.0.min.js' />"></script>
<script src="<c:url value='/assets/vendors/jquery-ui-1.12.1/jquery-ui.min.js' />"></script>
<script src="<c:url value='/assets/vendors/bootstrap-3.3.7-dist/js/bootstrap.min.js' />"></script>

<!-- Material Design for Bootstrap -->
<script src="<c:url value='/assets/vendors/bootstrap-material-design/js/material.js' />"></script>
<script src="<c:url value='/assets/vendors/bootstrap-material-design/js/ripples.min.js' />"></script>

</head>
<body>

	<tiles:insertAttribute name="header"/>
	<div id="content">
		<tiles:insertAttribute name="content" />
	</div>
	<tiles:insertAttribute name="footer"/>

	<script>
		$.material.init();
	</script>

</body>

</html>
