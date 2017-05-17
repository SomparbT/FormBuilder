<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<div class="container">
	<h2>Form assignment of : ${form.name }</h2>
	<table id="userTable" class="table table-striped table-bordered">
		<thead>
			<tr>
				<th>Username</th>
				<th>First Name</th>
				<th>Last Name</th>
				<th style="text-align:center">Operations</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${users}" var="user">
				<c:set var="contains" value="false" />
				<c:forEach items="${user.forms}" var="item">
					<c:if test="${item eq form}">
						<c:set var="contains" value="true" />
					</c:if>
				</c:forEach>
				<c:if test="${contains }">
					<tr>
						<td style="vertical-align: middle;">${user.username}</td>
						<td style="vertical-align: middle;">${user.firstName}</td>
						<td style="vertical-align: middle;">${user.lastName}</td>
						<td>
							<a class="btn" href="/formbuilder/userForm/fillForm.html?uId=${user.id}&fId=${form.id}&pageNum=1" data-toggle="tooltip" title="Edit Answer">
							<i class="glyphicon glyphicon-pencil"></i></a>
							<a class="btn" href="printForm.html?fId=${form.id}&uId=${user.id}" data-toggle="tooltip" title="Print Form">
							<i class="glyphicon glyphicon-print"></i></a>
						</td>
					</tr>
				</c:if>
			</c:forEach>
		</tbody>
	</table>
</div>

<!-- Modal -->
<div id="successModal" class="modal fade" tabindex="-1" role="dialog">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<!--                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>-->
				<h4 class="modal-title">Success</h4>
			</div>
			<div class="modal-body">
				<p>Your information is successfully added.</p>
			</div>
			<div class="modal-footer">
				<button id="closeSuccessModal" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>


<script src="<c:url value='/assets/vendors/DataTables-1.10.13/js/jquery.dataTables.min.js' />"></script>
<script src="<c:url value='/assets/vendors/DataTables-1.10.13/js/dataTables.bootstrap.min.js' />"></script>

<script>
	$(document).ready(function() {
		$('#userTable').DataTable({
			  "search": {
				    "search": "User"
				  }
				});
		$('#userTable_filter').addClass('form-group');
	});
</script>
