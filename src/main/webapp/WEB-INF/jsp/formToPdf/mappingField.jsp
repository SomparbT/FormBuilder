<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="formbuilder" uri="http://formbuilder.com/formbuilder"%>

<style>
.question {
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
		<formbuilder:pagination href_path="mappingForm.html" href_staticParameter="id=${param.id}" href_dynamicParameter="pageNum" currentPage="${param.pageNum}" totalPages="${form.totalPages}"></formbuilder:pagination>
		<H3>FORM MAPPING TEMPLATE</H3>
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
						<div>
							<c:forEach items="${questionsPage}" var="question">
								<div class="question"">
									<formbuilder:fieldMappingDisplay question="${question}"></formbuilder:fieldMappingDisplay>
								</div>
							</c:forEach>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
		<formbuilder:pagination href_path="mappingForm.html" href_staticParameter="id=${param.id}" href_dynamicParameter="pageNum" currentPage="${param.pageNum}" totalPages="${form.totalPages}"></formbuilder:pagination>
	</div>

	<div class="col-md-4" style="position: fixed; right: 0; height: 90%; ">
		<div class="panel panel-info">
			<div class="panel-heading">
				<h4 class="panel-title">PDF FIELD CONTROL</h4>
			</div>
			<div class="panel-body">
				<div class="row form-group" style="margin-top: 0;">
					<label for="selectPdf" class="control-label">Select PDF for Mapping: </label>
					<select id="selectPdf" class="form-control">
						<option value="" disabled selected hidden>Select PDF here</option>
						<c:forEach items="${pdfs}" var="pdf">
				         	<option data-pdf-id="${pdf.id}">${pdf.name}</option>
						</c:forEach>
				     </select>
					 <button id="clearBtn" class="btn btn-default btn-sm btn-raised" style="padding-left: 3em; padding-right: 3em;">Clear</button>
				     <button id="chooseBtn" class="btn btn-primary btn-sm btn-raised" style="padding-left: 3em; padding-right: 3em;">Choose</button>
				</div>
				<hr />
				
				
				<div id="fieldContainer">
					<p class="text-center">Drag field name from here to map the form field.</p>
				
				</div>
				
				<hr />
			</div>
		</div>

		
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
	$(function() {
		$('[data-toggle="tooltip"]').tooltip({
			delay : 500
		});
		
		var $selectPdf = $("#selectPdf");
		var $clearBtn = $("#clearBtn");
		var $chooseBtn = $("#chooseBtn");
		var $fieldContainer = $("#fieldContainer");
		$chooseBtn.prop("disabled", true);

		
		$selectPdf.change(function() {
			$chooseBtn.prop("disabled", false);
		});
		
		$clearBtn.on("click", function () {
			$selectPdf.val("");
	        $selectPdf.attr("disabled", false);
	        $chooseBtn.prop("disabled", true);
	        $(".field").remove();
	    });
		
		$chooseBtn.on("click", function () {
			$chooseBtn.prop("disabled", true);
	        $selectPdf.attr("disabled", true);
	        var pdfId = $("#selectPdf option:selected").attr('data-pdf-id');
	        var pdfName = $selectPdf.val()
	        $.ajax({
		        url: "/formbuilder/service/listFields/" + pdfId,
		        method: "GET",
		        dataType: "json",
		        success: function(data) {
		        	data.forEach(function (field) {
		        			switch(field.fieldType){
		        			case "PDTextField" :
				        		var $dragField = $("<div class='field fieldText btn icon-btn btn-primary' title='" + pdfName + "' data-field-id='" + field.id + "' data-question-id=''><span class='glyphicon btn-glyphicon glyphicon-font img-circle text-primary'></span>" + field.name + "</div>").draggable({
				        		    appendTo: "body",
				        		    cursor: "move",
				        		    helper: 'clone',
				        		    revert: "invalid"
				        		});
				        		break;
		        			case "PDCheckBox" :
				        		var $dragField = $("<div class='field fieldCheckBox btn icon-btn btn-primary' title='" + pdfName + "' data-field-id='" + field.id + "' data-question-id='' data-choice-index=''><span class='glyphicon btn-glyphicon glyphicon-check img-circle text-primary'></span>" + field.name + "</div>").draggable({
				        		    appendTo: "body",
				        		    cursor: "move",
				        		    helper: 'clone',
				        		    revert: "invalid"
				        		});
				        		break;
		        			case "PDComboBox" :
				        		var $dragField = $("<div class='field fieldComboBox btn icon-btn btn-primary' title='" + pdfName + "' data-field-id='" + field.id + "' data-question-id=''><span class='glyphicon btn-glyphicon glyphicon-collapse-down img-circle text-primary'></span>" + field.name + "</div>").draggable({
				        		    appendTo: "body",
				        		    cursor: "move",
				        		    helper: 'clone',
				        		    revert: "invalid"
				        		});
				        		break;
		        			default :
				        		var $dragField = $("<div class='field btn icon-btn btn-danger' title='" + pdfName + "'><span class='glyphicon btn-glyphicon glyphicon-remove img-circle text-danger'></span>" + field.name + "</div>");
				        		break;		        			
		        			}        			
		        			
		        		if(field.question === null){
				 			$("#fieldContainer").append($dragField);	
		        		}else{
		        			$dragField.attr("data-question-id", field.question.id);
		        			if(field.fieldType === "PDCheckBox"){
		        				$dragField.attr("data-choice-index", field.choiceIndex);
		        				$( ".dropContainer[data-question-id='" + field.question.id +"'][data-choice-index='" + field.choiceIndex +"']" ).append($dragField);
		        			}else{
		        				$( ".dropContainer[data-question-id='" + field.question.id +"']" ).append($dragField);
		        			}
		        		}
		        	});
		        }
		    });
	    });
		
		$(".field").draggable({
		    appendTo: "body",
		    cursor: "move",
		    helper: 'clone',
		    revert: "invalid"
		});
		
		$("#fieldContainer").droppable({
		    tolerance: "intersect",
		    accept: ".field",
		    classes: {
		        "ui-droppable-active": "ui-state-default",
		        "ui-droppable-hover": "ui-state-hover"
		      },
		    drop: function(event, ui) {
		    	var $field = $(ui.draggable);
		    	var fieldId = $field.attr('data-field-id');
		    	var questionId = $field.attr('data-question-id');
		        if(questionId.length !== 0){
			        $.ajax({
		                url: "/formbuilder/service/unmapField/" + questionId + "/" + fieldId,
		                method: "POST",
		                success: function(){
		                	$field.attr("data-question-id", "");
		                	$("#fieldContainer").append($field);
		                }
		            });	
		        } 
		    }
		});
		
		$(".dropContainerText").droppable({
		    tolerance: "intersect",
		    accept: ".fieldText",
		    classes: {
		        "ui-droppable-active": "custom-active",
		        "ui-droppable-hover": "ui-state-hover"
		      },
		    drop: function(event, ui) {  
		    	var $field = $(ui.draggable);
		    	var fieldId = $field.attr('data-field-id');
		    	var $container = $(this);
		    	var questionId = $field.attr('data-question-id');
		    	var containerQuestionId = $container.attr('data-question-id');
		        if(containerQuestionId !== questionId){
			        $.ajax({
		                url: "/formbuilder/service/mapField/" + containerQuestionId + "/" + fieldId,
		                method: "POST",
		                success: function(){
		                	$field.attr("data-question-id", containerQuestionId);
		                }
		            });
		        }
		        $container.append($field);
		    }
		});
		
		$(".dropContainerCheckBox").droppable({
		    tolerance: "intersect",
		    accept: ".fieldCheckBox",
		    classes: {
		        "ui-droppable-active": "custom-active",
		        "ui-droppable-hover": "ui-state-hover"
		      },
		    drop: function(event, ui) {        
		    	var $field = $(ui.draggable);
		    	var fieldId = $field.attr('data-field-id');
		    	var $container = $(this);
		    	var questionId = $field.attr('data-question-id');
		    	var containerQuestionId = $container.attr('data-question-id');
		    	var choiceIndex = $container.attr('data-choice-index');
		        if(containerQuestionId !== questionId){
			        $.ajax({
		                url: "/formbuilder/service/mapFieldChoice/" + containerQuestionId + "/" + fieldId + "/" + choiceIndex,
		                method: "POST",
		                success: function(){
		                	$field.attr("data-question-id", containerQuestionId).attr("data-choice-index", choiceIndex);
		                }
		            });
		        }
		        $container.append($field);
		    }
		});
		
		$(".dropContainerComboBox").droppable({
		    tolerance: "intersect",
		    accept: ".fieldComboBox",
		    classes: {
		        "ui-droppable-active": "custom-active",
		        "ui-droppable-hover": "ui-state-hover"
		      },
		    drop: function(event, ui) {        
		    	var $field = $(ui.draggable);
		    	var fieldId = $field.attr('data-field-id');
		    	var $container = $(this);
		    	var questionId = $field.attr('data-question-id');
		    	var containerQuestionId = $container.attr('data-question-id');
		        if(containerQuestionId !== questionId){
			        $.ajax({
		                url: "/formbuilder/service/mapField/" + containerQuestionId + "/" + fieldId,
		                method: "POST",
		                success: function(){
		                	$field.attr("data-question-id", containerQuestionId);
		                }
		            });
		        }
		        $container.append($field);
		    }
		});
		
	});
	
</script>
