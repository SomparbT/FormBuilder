
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
				enctype="multipart/form-data" id="dropzonePdf">
				<div>
					<div class="form-group">
						<input type="file" name="uploadFile"
							onchange="this.form.submit()"> <input
							type="text" class="form-control"
							placeholder="Browse or Drop your PDF here to upload" readonly>
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
					<td style="vertical-align: middle;" data-pdf-id="${pdf.id }">${pdf.name}</td>
					<td>
						<a class="btn" href="viewPdf.html?fileId=${pdf.id}" data-toggle="tooltip" title="View PDF" target="_blank"><i class="glyphicon glyphicon-eye-open"></i></a>
						<a class="btn" href="downloadPdf.html?fileId=${pdf.id}" data-toggle="tooltip" title="Download PDF"><i class="glyphicon glyphicon-floppy-save"></i></a>
						<a class="btn" href="deletePdf.html?fileId=${pdf.id}" data-toggle="tooltip" title="Delete PDf"><i class="glyphicon glyphicon-trash"></i></a>
						<button class="btn renameBtn" data-toggle="tooltip" title="Rename PDF" onclick="this.blur()"><i class="glyphicon glyphicon-pencil"></i></button>					
						<button class="btn autoBuildFormBtn" data-toggle="tooltip" title="Auto Build Form" data-pdf-id="${pdf.id }" onclick="this.blur()"><i class="glyphicon glyphicon-flash"></i></button>										
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
	$(function() {
		$('#pdfTable').DataTable();
		$('#pdfTable_filter').addClass('form-group');
		
		
		$('.renameBtn').on("click", function () {
			var $renameBtn = $(this);
			var $td_pdf = $renameBtn.closest("td").prev();
			var pdfId = $td_pdf.attr("data-pdf-id");
			var pdfName = $td_pdf.html().slice(0,-4);
			
			var $renameForm = $("<form class='form-inline' method='get' action='renamePdf.html'>" 
					+ "<div class='input-group'>"
					+ "<input type='text' id='inputName' class='form-control' name='newFileName' placeholder='Type name here'>"
					+ "<span class='input-group-btn'>"
					+ "<button type='submit' id='submitBtn' class='btn btn-default btn-raised btn-sm'>Rename</button>"
					+ "</span>"
					+ "</div>"
					+ "<input type='hidden' name='fileId' value=" + pdfId +">"
					+ "</form>");

			$td_pdf.html("");
			$td_pdf.append($renameForm);
			$("#inputName").val(pdfName);
			$("#inputName").focus().blur(function() {
				var setTimer = { timer: null }
				setTimer.timer = setTimeout(function () {
					$renameBtn.prop("disabled", false);
					$renameForm.remove();
					$td_pdf.html(pdfName+".pdf");
		            }, 1000);
			});
			$renameBtn.prop("disabled", true);
	    });
		
		$(".autoBuildFormBtn").on("click", function () {
	        var pdfId = $(this).attr("data-pdf-id");
	        $.ajax({
		        url: "/formbuilder/service/autoBuildForm/" + pdfId,
		        method: "GET",
		        dataType: "json",
		        success: function(data) {
		        	
		        }
		    });
	    });		
		
	});
</script>



	