<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<div class="container">
	<table id="formTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>Form Name</th>
				<th>Description</th>
				<th style="text-align:center">Enabled</th>
				<th style="text-align:center">Total Pages</th>
				<th style="text-align:center">Operations</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${forms}" var="form">
				<tr>
					<td style="vertical-align: middle;">${form.name}</td>
					<td style="vertical-align: middle;">${form.description}</td>
					<td style="vertical-align: middle; text-align:center;">${form.enabled}</td>
					<td style="vertical-align: middle; text-align:center;">${form.totalPages}</td>
					<td>
						<a class="btn" href="mappingForm.html?id=${form.id}&pageNum=1" data-toggle="tooltip" title="Mapping Form"><i class="glyphicon glyphicon-transfer"></i></a>						
						<a class="btn" href="listPrintForm.html?id=${form.id}" data-toggle="tooltip" title="Print Form"><i class="glyphicon glyphicon-open-file"></i></a>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>


<script src="<c:url value='/assets/vendors/DataTables-1.10.13/js/jquery.dataTables.min.js' />"></script>
<script src="<c:url value='/assets/vendors/DataTables-1.10.13/js/dataTables.bootstrap.min.js' />"></script>

<script>
	$(document).ready(function() {
		$('#formTable').DataTable();
		$('#formTable_filter').addClass('form-group');
	});
</script>