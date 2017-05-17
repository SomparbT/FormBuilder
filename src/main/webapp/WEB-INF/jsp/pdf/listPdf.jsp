
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>


<h1 align=center>PDF Management</h1>


<div class="col-md-6 col-md-offset-3">
	<div class="panel panel-success" style="">
		<div class="panel-heading">
			<h4 align=center class="panel-title">Select or Drop a New File</h4>
		</div>

		<div class="panel-body">
			<form method="post" action="uploadPdf.html" class="dropzone"
				enctype="multipart/form-data" id="my-awesome-dropzone">
				<div>
					<div class="form-group">
						<input type="file" name="uploadFile"
							onchange="this.form.submit()"> <input
							type="text" class="form-control"
							placeholder="Browse or Drag your PDF here to upload" readonly>
					</div>
					${message }
				</div>
			</form>
		</div>
	</div>
</div>


<div class="container">
	<table id="pdfTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>PDF Name</th>
				<th style="text-align:center">Operations</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${pdfs}" var="pdf">
				<tr>
					<td style="vertical-align: middle;">${pdf.name}</td>
					<td>
						<a class="btn" href="viewPdf.html?fileId=${pdf.id}" data-toggle="tooltip" title="View PDF" target="_blank"><i class="glyphicon glyphicon-eye-open"></i></a>
						<a class="btn" href="downloadPdf.html?fileId=${pdf.id}" data-toggle="tooltip" title="Download PDF"><i class="glyphicon glyphicon-floppy-save"></i></a>
						<a class="btn" href="deletePdf.html?fileId=${pdf.id}" data-toggle="tooltip" title="Delete PDf"><i class="glyphicon glyphicon-trash"></i></a>
						<a class="btn" href="renamePdf.html?fileId=${pdf.id}" data-toggle="tooltip" title="Rename PDF"><i class="glyphicon glyphicon-pencil"></i></a>
						<a class="btn" href="" data-toggle="tooltip" title="Mapping Form"><i class="glyphicon glyphicon-text-background"></i></a>						
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>


<script src="<c:url value='/assets/vendors/DataTables-1.10.13/js/jquery.dataTables.min.js' />"></script>
<script src="<c:url value='/assets/vendors/DataTables-1.10.13/js/dataTables.bootstrap.min.js' />"></script>
<script src="<c:url value='/assets/dropzone/dropzone.js' />"></script>

<script>
	$(document).ready(function() {
		$('#pdfTable').DataTable();
		$('#pdfTable_filter').addClass('form-group');
	});
</script>



	