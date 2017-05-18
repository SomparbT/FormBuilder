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
			<div style="margin-top:10px;"><p><strong>${filledForm}</strong></p></div>
			<div class="btn-group btn-group-sm" role="group" aria-label="..." style="margin-left: 10px;">
				<a href="downloadFilledPdf.html?uId=${user.id}&filename=${filledForm}" class="btn btn-success btn-raised" data-toggle="tooltip" data-placement="bottom" title="Download PDF">
				<span class="glyphicon glyphicon-cloud-download"></span></a> 
				<a href="deletefilledPdf.html?uId=${user.id}&filename=${filledForm}" class="btn btn-danger btn-raised" data-toggle="tooltip" data-placement="bottom" title="Delete PDF">
				<span class="glyphicon glyphicon-trash"></span></a> 
				<button class="btn btn-default btn-raised renameBtn" data-user-id="${user.id}" data-placement="bottom" data-toggle="tooltip" title="Rename PDF" onclick="this.blur()">
				<i class="glyphicon glyphicon-pencil"></i></button> 
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


<script>
	$(function() {
				
		$('.renameBtn').on("click", function () {
			var $renameBtn = $(this);
			var $div_pdfName = $renameBtn.closest("div").prev();
			var uId = $renameBtn.attr("data-user-id");
			var $strong_pdfName = $div_pdfName.find('strong');
			console.log($strong_pdfName.html());
			var pdfName = $strong_pdfName.html().slice(0,-4);
			console.log(pdfName);
			
			var $renameForm = $("<form class='form-inline' method='get' action='renameFilledPdf.html'>" 
					+ "<div class='input-group'>"
					+ "<input type='text' id='inputName' class='form-control' name='newFileName' placeholder='Type name here'>"
					+ "<span class='input-group-btn'>"
					+ "<button type='submit' id='submitBtn' class='btn btn-default btn-raised btn-sm'>Rename</button>"
					+ "</span>"
					+ "</div>"
					+ "<input type='hidden' name='fileName' value=" + pdfName +">"
					+ "<input type='hidden' name='uId' value=" + uId +">"
					+ "</form>");

			$strong_pdfName.html("");
			$div_pdfName.append($renameForm);
			$("#inputName").val(pdfName);
			$("#inputName").focus().blur(function() {
				var setTimer = { timer: null }
				setTimer.timer = setTimeout(function () {
					$renameBtn.prop("disabled", false);
					$renameForm.remove();
					$strong_pdfName.html(pdfName+".pdf");
		            }, 1000);
				
			});
			$renameBtn.prop("disabled", true);
	    });
		
	});
</script>