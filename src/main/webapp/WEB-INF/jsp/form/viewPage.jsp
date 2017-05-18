<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="formbuilder" uri="http://formbuilder.com/formbuilder"%>

<div class="row">
<div class="col-md-offset-3 col-md-6">

	<formbuilder:pagination href_path="viewPage.html" href_staticParameter="id=${param.id}" href_dynamicParameter="pageNum" currentPage="${param.pageNum}" totalPages="${form.totalPages}"></formbuilder:pagination>


	<H2>FORM : ${form.name}</H2>
	<div class="panel panel-primary">
		<div class="panel-heading">
			<h4 class="panel-title">PAGE ${param.pageNum}</h4>
		</div>
		<div class="panel-body">
			<c:choose>
				<c:when test="${empty questionsPage}">
					<h3 class="text-center">There is no question on this page.</h3>
				</c:when>
				<c:otherwise>
					<c:forEach items="${questionsPage}" var="question">
						<formbuilder:fieldDisplay question="${question }"></formbuilder:fieldDisplay>
						<hr />
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<formbuilder:pagination href_path="viewPage.html" href_staticParameter="id=${param.id}" href_dynamicParameter="pageNum" currentPage="${param.pageNum}" totalPages="${form.totalPages}"></formbuilder:pagination>


</div>
</div>