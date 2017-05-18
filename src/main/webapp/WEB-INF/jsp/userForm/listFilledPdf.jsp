<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<div class="container">
	<c:set var="count" value="0" scope="page" />
	<c:forEach items="${filledForms}" var="filledForm">
			
		<c:if test="${count % 3 == 0}">
			<div class="row">	
		</c:if>

	   	<div class="col-md-4" style="text-align: center;">
			<a href="viewFilledPdf.html?uId=${user.id}&filename=${filledForm}" target="_blank"><img src="<c:url value='/assets/resources/img/pdf.png' />" style="width: 25%;"></a>
			<div><strong><a href="viewFilledPdf.html?uId=${user.id}&filename=${filledForm}" target="_blank">${filledForm}</a></strong></div>
			<div class="btn-group btn-group-sm" role="group" aria-label="..." style="margin-left: 10px;">
				<a href="downloadFilledPdf.html?uId=${user.id}&filename=${filledForm}" class="btn btn-success btn-raised" data-toggle="tooltip" data-placement="bottom" title="Duplicate this question">
				<span class="glyphicon glyphicon-cloud-download"></span></a> 
				<a href="deletefilledPdf.html?uId=${user.id}&filename=${filledForm}" class="btn btn-danger btn-raised" data-toggle="tooltip" data-placement="bottom" title="Delete question">
				<span class="glyphicon glyphicon-trash"></span></a> 
				<a href="#" class="btn btn-default btn-raised" data-toggle="tooltip" data-placement="bottom" title="Edit this question">
				<span class="glyphicon glyphicon-pencil"></span></a> 
			</div>
		</div>
		
		<c:choose>
		    <c:when test="${count % 3 == 2}">
				</div>
				<c:set var="count" value="${0}" scope="page"/>
		    </c:when>
		    <c:otherwise>
		        <c:set var="count" value="${count + 1}" scope="page"/>
		    </c:otherwise>
		</c:choose>
		
	</c:forEach>
	
	</div>

</div>