<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="formbuilder" uri="http://formbuilder.com/formbuilder"%>

<style>
.sort-item {
	background-color: #fff;
	border: 1.5px solid #eee;
	border-radius: 5px;
}

.custom {
				width: 100px !important;
				margin-right: 10px;
				margin-top: 5px;
				border-radius: 24px;
			}
</style>

<script>
$(function() {
	$("#sortable").sortable({
		update : function(event, ui) {
			const order = $(this).sortable("toArray", {
				attribute: "data-qid"
			});
			console.log("Order in sortable:" + order)
			
			$.ajax({
				url : "editQuestionOrder",
				data : {
					questionOrder : order.toString()
				},
				context : document.body,
				success : function() {
					console.log("success!")
 					$('.question-number:first-child').each(function(index) {
						$qDescription = $(this).find('span').text()
						console.log('<label for="question' + (index+1) + '" class="control-label">' + (index+1) + '. <span>' + $qDescription + '</span></label>')
						$(this).replaceWith('<div class="question-number"><label for="question' + (index+1) + '" class="control-label">' + (index+1) + '. <span>' + $qDescription + '</span></label></div>')
					}) 
				},
				error : function() {
					console.log("sortable ajax fail")
				}
			});
		}
	});
	$("#sortable").disableSelection();
});
</script>

<div class="row">
	<div class="col-md-offset-1 col-md-7">
		<H3>FORM LIVE PREVIEW</H3>
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
						<div id="sortable">
							<c:forEach items="${questionsPage}" var="question">
								<div class="sort-item" data-qid="${question.id}">
									<formbuilder:fieldDisplay question="${question}"></formbuilder:fieldDisplay>
									<div class="btn-group btn-group-sm" role="group" aria-label="..." style="margin-left: 10px;">
										<a href="copyQuestion.html?qId=${question.id}" class="btn btn-success" data-toggle="tooltip" data-placement="bottom" title="Duplicate this question"><span
											class="glyphicon glyphicon-plus-sign"></span></a> <a href="deleteQuestion.html?qId=${question.id}" class="btn btn-danger" data-toggle="tooltip" data-placement="bottom" title="Delete question"><span
											class="glyphicon glyphicon-minus-sign"></span></a> <a href="editQuestion.html?qId=${question.id}" class="btn btn-default" data-toggle="tooltip"
											data-placement="bottom" title="Edit this question"><span class="glyphicon glyphicon-pencil"></span></a> 
									</div>
								</div>
							</c:forEach>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>

	</div>

	<div class="col-md-4" style="position: fixed; right: 0; height: 90%; overflow: auto;">
		<div class="panel panel-info">
			<div class="panel-heading">
				<h4 class="panel-title">FORM CONTROL</h4>
			</div>
			<div class="panel-body">

				<a href="#editForm" class="btn btn-info btn-sm" data-toggle="collapse">Edit Form Properties</a>
				<div id="editForm" class="collapse">

					<form:form modelAttribute="form" class="form">
						<div class="form-group">
							<div>
								<label>Form Title</label>
							</div>
							<form:input path="name" cssClass="form-control" required="required" />
						</div>
						<div class="form-group">
							<div>
								<label>Description</label>
							</div>
							<form:textarea path="description" cssClass="form-control" />
						</div>
						<div class="form-group">
							<div>
								<label>Notification Email</label>
							</div>
							<form:input path="notificationEmail" cssClass="form-control" />
						</div>
						<div class="form-group">
							<form:checkbox path="enabled" label="Enable" />
						</div>

						<button type="submit" class="btn btn-raised btn-info btn-sm">
							<span class="glyphicon glyphicon-floppy-disk"></span> SAVE
						</button>
					</form:form>
				</div>
				<hr />
				<p class="text-center">Click here to add field to the form.</p>
				<div>
					<a href="addTextQuestion.html?id=${param.id}&pageNum=${param.pageNum}&type=text"><button type="button" class="btn btn-info btn-sm btn-raised custom">
							<span class="glyphicon glyphicon-font"></span> TEXT
						</button></a> <a href="addTextQuestion.html?id=${param.id}&pageNum=${param.pageNum}&type=number"><button type="button" class="btn btn-info btn-sm btn-raised custom">
							<span class="glyphicon glyphicon-sound-5-1"></span> NUMBER
						</button></a> <a href="addTextQuestion.html?id=${param.id}&pageNum=${param.pageNum}&type=textarea"><button type="button" class="btn btn-info btn-sm btn-raised custom">
							<span class="glyphicon glyphicon-text-size"></span> TEXT AREA
						</button></a>
				</div>
				<div>
					<a href="addChoiceQuestion.html?id=${param.id}&pageNum=${param.pageNum}&type=checkbox"><button type="button" class="btn btn-info btn-sm btn-raised custom">
							<span class="glyphicon glyphicon-check"></span> CHECKBOX
						</button></a> <a href="addChoiceQuestion.html?id=${param.id}&pageNum=${param.pageNum}&type=radio"><button type="button" class="btn btn-info btn-sm btn-raised custom">
							<span class="glyphicon glyphicon-th-list"></span> RADIO
						</button></a> <a href="addChoiceQuestion.html?id=${param.id}&pageNum=${param.pageNum}&type=options"><button type="button" class="btn btn-info btn-sm btn-raised custom">
							<span class="glyphicon glyphicon-collapse-down"></span> OPTION
						</button></a>
				</div>
				<div>
					<a href="addFileQuestion.html?id=${param.id}&pageNum=${param.pageNum}&type=file"><button type="button" class="btn btn-info btn-sm btn-raised custom">
							<span class="glyphicon glyphicon-file"></span> FILE
						</button></a>
				</div>
				<hr />
				<div>
					<a href="addPage.html?id=${param.id}"><button type="button" class="btn btn-success btn-sm btn-raised">
							<span class="glyphicon glyphicon-plus"></span> ADD NEW PAGE
						</button></a>
					<c:if test="${form.totalPages > 1 }">
						<button type="button" class="btn btn-danger btn-sm btn-raised" data-toggle="modal" data-target="#deletePage">
							<span class="glyphicon glyphicon-trash"></span> DELETE PAGE
						</button>
					</c:if>
				</div>
			</div>
		</div>

		<formbuilder:pagination href_path="editPage.html" href_staticParameter="id=${param.id}" href_dynamicParameter="pageNum" currentPage="${param.pageNum}" totalPages="${form.totalPages}"></formbuilder:pagination>
		
	</div>
</div>

<!-- Modal -->
<div class="modal fade" id="deletePage" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">
					<span class="glyphicon glyphicon-remove" aria-hidden="true"></span>
				</button>
				<h4 class="modal-title custom_align" id="Heading">Delete this entry</h4>
			</div>
			<div class="modal-body">

				<div class="alert alert-danger">
					<span class="glyphicon glyphicon-warning-sign"></span> Are you sure you want to delete this Page?
				</div>

				<div class="modal-footer ">
					<a href="deletePage.html?id=${param.id}&pageNum=${param.pageNum}">
						<button type="button" class="btn btn-danger">
							<span class="glyphicon glyphicon-ok-sign"></span> Yes
						</button>
					</a>
					<button type="button" class="btn btn-default" data-dismiss="modal">
						<span class="glyphicon glyphicon-remove"></span> No
					</button>
				</div>
			</div>
		</div>
	</div>
</div>
<script>
	function deletePage() {
		var msg = "Are you sure you want to delete this page?";
		if (confirm(msg))
			window.location.href = "deletePage.html?id=${param.id}&pageNum=${param.pageNum}";
	}
</script>
<script>
	$(function() {
		$('[data-toggle="tooltip"]').tooltip({
			delay : 500
		});
	});
</script>
