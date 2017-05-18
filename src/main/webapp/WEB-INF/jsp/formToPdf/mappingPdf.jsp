<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="formbuilder" uri="http://formbuilder.com/formbuilder"%>

<style>
.form {
	background-color: #fff;
	border: 1.5px solid #eee;
	border-radius: 5px;
}
.custom-active {
            background : #ffffe0;
            border-style: dashed;
            border-width: 1px;
         } 
.dropContainerX {
	background-color: #fff;
	border: 1.5px solid #eee;
	border-radius: 5px;
}
.btn-glyphicon { padding:8px; background:#ffffff; margin-right:4px; }
.icon-btn { padding: 1px 15px 3px 2px; border-radius:50px;}
.dropContainerx {
    -moz-appearance: textfield;
    -webkit-appearance: textfield;
    background-color: white;
    background-color: -moz-field;
    border: 1px solid darkgray;
    box-shadow: 1px 1px 1px 0 lightgray inset;  
    font: -moz-field;
    font: -webkit-small-control;
    margin-top: 5px;
    padding: 2px 3px;
    width: 398px;    
}

</style>





<div class="row">
	<div class="col-md-offset-1 col-md-7">
		<H3>FORM MAPPING TEMPLATE</H3>
		<div class="panel panel-primary">
			<div class="panel-heading">
				<h4 class="panel-title">LIST OF FORMS</h4>
			</div>
			<div class="panel-body">
				<c:choose>
					<c:when test="${empty forms}">
						<h3 class="text-center">There is no form.</h3>
					</c:when>
					<c:otherwise>
						<div>
							<c:forEach items="${forms}" var="form">
								<div class="form">
									<div class="form-group row" style="margin-left: 10px; margin-top: 10px;">
										<div data-form-id="${form.id }" class="dropContainer" >
											<p class="lead"><span>${form.name }</span></p>
											<c:forEach items="${form.pdfs}" var="pdf">
												<div class='pdf btn icon-btn btn-primary' data-pdf-id='${pdf.id }' data-form-id='${form.id }'><span class='glyphicon btn-glyphicon glyphicon-font img-circle text-primary'></span>${pdf.name }</div>
											</c:forEach>
										</div>
									</div>	
								</div>
							</c:forEach>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>

	<div class="col-md-4" style="position: fixed; right: 0; height: 90%; ">
		<div class="panel panel-info">
			<div class="panel-heading">
				<h4 class="panel-title">PDF CONTROL</h4>
			</div>
			<div class="panel-body">
				<div id="pdfContainer">
					<p class="text-center">Drag PDF name from here to map with the form.</p>
					<c:forEach items="${pdfs}" var="pdf">
						<c:if test="${empty pdf.form}">
							<div class='pdf btn icon-btn btn-primary' data-pdf-id='${pdf.id }' data-form-id=''><span class='glyphicon btn-glyphicon glyphicon-duplicate img-circle text-primary'></span>${pdf.name }</div>
						</c:if>
					</c:forEach>
				</div>
				
				<hr />
			</div>
		</div>

		
	</div>
</div>


<script>
	$(function() {
		$('[data-toggle="tooltip"]').tooltip({
			delay : 500
		});
		
		$(".pdf").draggable({
		    appendTo: "body",
		    cursor: "move",
		    helper: 'clone',
		    revert: "invalid"
		});
		
		$("#pdfContainer").droppable({
		    tolerance: "intersect",
		    accept: ".pdf",
		    classes: {
		        "ui-droppable-active": "ui-state-default",
		        "ui-droppable-hover": "ui-state-hover"
		      },
		    drop: function(event, ui) {
		    	var $pdf = $(ui.draggable);
		    	var pdfId = $pdf.attr('data-pdf-id');
		    	var formId = $pdf.attr('data-form-id');
		        if(formId.length !== 0){
			        $.ajax({
		                url: "/formbuilder/service/unmapPdf/" + formId + "/" + pdfId,
		                method: "POST",
		                success: function(){
		                	$pdf.attr("data-form-id", "");
		                	$("#pdfContainer").append($pdf);
		                }
		            });	
		        } 
		    }
		});
		
		$(".dropContainer").droppable({
		    tolerance: "intersect",
		    accept: ".pdf",
		    classes: {
		        "ui-droppable-active": "custom-active",
		        "ui-droppable-hover": "ui-state-hover"
		      },
		    drop: function(event, ui) {  
		    	var $pdf = $(ui.draggable);
		    	var pdfId = $pdf.attr('data-pdf-id');
		    	var $container = $(this);
		    	var formId = $pdf.attr('data-form-id');
		    	var containerFormId = $container.attr('data-form-id');
		        if(containerFormId !== formId){
			        $.ajax({
		                url: "/formbuilder/service/mapPdf/" + containerFormId + "/" + pdfId,
		                method: "POST",
		                success: function(){
		                	$pdf.attr("data-form-id", containerFormId);
		                }
		            });
		        }
		        $container.append($pdf);
		    }
		});
		
	});
	
</script>
