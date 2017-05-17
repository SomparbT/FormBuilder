<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags"%>

<security:authentication var="principal" property="principal" />
<nav class="navbar navbar-default navbar-fixed-top">
	<div class="container">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
				<span class="sr-only">Toggle navigation</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="/formbuilder/">Formbuilder</a>
		</div>
		<div id="navbar" class="navbar-collapse collapse">
			<ul class="nav navbar-nav">
				
				<security:authorize access="hasAnyRole('ROLE_ADMIN', 'ROLE_STAFF')">
				  <li><a href="/formbuilder/staffHome.html">Home</a></li>
				  <li><a href="/formbuilder/user/list.html">Users</a></li>
			  	  <li><a href="/formbuilder/form/listForm.html">Forms</a></li>
			  	  <li><a href="/formbuilder/pdf/listPdf.html">PDFs</a></li>
			  	  <li><a href="/formbuilder/formToPdf/listForm.html">Form To PDF</a></li>
				</security:authorize>
				
				<security:authorize access="hasRole('ROLE_USER')">
				  <li><a href="/formbuilder/userHome.html">Home</a></li>
			  	  <li><a href="/formbuilder/userForm/listForm.html?id=${principal.id}">My Forms</a></li>
		  	      <li><a href="#">Download PDFs</a></li>
				  <li><a href="#">Help</a></li>
				</security:authorize>
				
			</ul>

			<ul class="nav navbar-nav navbar-right">
	            <li class="dropdown">
	              <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><span class="glyphicon glyphicon-user"></span> ${principal.username}  's Profile <span class="caret"></span></a>
	              <ul class="dropdown-menu">
	                <li><a href="/formbuilder/user/edit.html?id= ${principal.id}">Your Account</a></li>
	                <li class="disabled"><a href="#">Settings</a></li>
	                <li role="separator" class="divider"></li>
	                <li id="logoutDropdownLink" onclick="$('#logout').submit()"><a>Sign Out</a></li>
	              </ul>
	            </li>
          	</ul>
			
			<form action="<c:url value='/logout'/>" method="POST" id="logout">
			  <!-- Form is submitted when User clicks dropdown link to 'Sign Out' -->
			</form>
		</div>
	</div>
</nav>

<script>
$(document).ready(function() {
	// get current URL path and assign 'active' class
	var pathname = window.location.pathname;
	$('.nav > li > a[href="'+pathname+'"]').parent().addClass('active');
})
</script>
