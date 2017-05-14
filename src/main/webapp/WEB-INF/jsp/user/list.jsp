<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>


<div class="container">
	<table id="userTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>First Name</th>
				<th>Last Name</th>
				<th>Username</th>
				<th>Role</th>
				<th>Operations</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${users}" var="user">
				<tr>
					<td>${user.firstName}</td>
					<td>${user.lastName}</td>
					<td>${user.username }</td>
					<td>${user.role }</td>
					<td><a class="btn" href="view.html?id=${user.id}" data-toggle="tooltip" title="View User"><i class="glyphicon glyphicon-eye-open"></i></a> 
					<security:authorize access="hasRole('ROLE_ADMIN')">
						<a class="btn" href="edit.html?id=${user.id}" data-toggle="tooltip" title="Edit User Information"><i class="glyphicon glyphicon-pencil"></i></a>
						<a class="btn" href="delete.html?id=${user.id}" data-toggle="tooltip" title="Delete User"><i class="glyphicon glyphicon-trash"></i></a>
					</security:authorize></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>

	<div class="col-md-offset-10">
		<security:authorize access="hasRole('ROLE_ADMIN')">
			<a href="add.html" id="popupAddUser"><button type="button" class="btn btn-success btn-sm btn-raised"><span class="glyphicon glyphicon-plus"></span> ADD NEW USER</button></a>
		</security:authorize>
	</div>
</div>


<script src="<c:url value='/assets/vendors/DataTables-1.10.13/js/jquery.dataTables.min.js' />"></script>
<script src="<c:url value='/assets/vendors/DataTables-1.10.13/js/dataTables.bootstrap.min.js' />"></script>

<script>
	$(document).ready(function() {
		$('#userTable').DataTable();
		$('#userTable_filter').addClass('form-group');
	});
</script>