<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ attribute name="question" required="true" type="formbuilder.model.questionform.Question"%>
<%@ tag body-content="scriptless"%>


<div class="form-group row" style="margin-left: 10px; margin-top: 10px;">
	<c:choose>
		<c:when test="${question.tagAttribute.type eq 'text'}">
			<div data-question-id="${question.id }" class="dropContainerText" >
				<p>${question.questionNumber}. <span>${question.description }</span></p>
				<c:forEach items="${question.pdfFields}" var="field">
					<div class='field fieldText btn icon-btn btn-primary' title='${field.pdf.name }' data-field-id='${field.id }' data-question-id='${question.id }'><span class='glyphicon btn-glyphicon glyphicon-font img-circle text-primary'></span>${field.name }</div>
				</c:forEach>
			</div>
		</c:when>

		<c:when test="${question.tagAttribute.type eq 'number'}">
			<div data-question-id="${question.id }" class="dropContainerText">
				<p>${question.questionNumber}. <span>${question.description }</span></p>
				<c:forEach items="${question.pdfFields}" var="field">
					<div class='field fieldText btn icon-btn btn-primary' title='${field.pdf.name }' data-field-id='${field.id }' data-question-id='${question.id }'><span class='glyphicon btn-glyphicon glyphicon-font img-circle text-primary'></span>${field.name }</div>
				</c:forEach>
			</div>
		</c:when>

		<c:when test="${question.tagAttribute.type eq 'textarea'}">
			<div data-question-id="${question.id }" class="dropContainerText">
				<p>${question.questionNumber}. <span>${question.description }</span></p>
				<c:forEach items="${question.pdfFields}" var="field">
					<div class='field fieldText btn icon-btn btn-primary' title='${field.pdf.name }' data-field-id='${field.id }' data-question-id='${question.id }'><span class='glyphicon btn-glyphicon glyphicon-font img-circle text-primary'></span>${field.name }</div>
				</c:forEach>
			</div>
		</c:when>

		<c:when test="${question.tagAttribute.type eq 'checkbox'}">
			<div data-question-id="${question.id }">
				<p>${question.questionNumber}. <span>${question.description }</span></p>
			<c:forEach items="${question.choices}" var="choice" varStatus="loop">
				<div class="dropContainerCheckBox">
					<div class="checkbox" data-question-id="${question.id }" data-choice-index="${loop.index }">
						<label style="color:black;"> <input type="checkbox" value="" disabled> ${choice }</label>
						<c:forEach items="${question.pdfFields}" var="field">
							<div class='field fieldCheckBox btn icon-btn btn-primary' title='${field.pdf.name }' data-field-id='${field.id }' data-question-id='${question.id }'><span class='glyphicon btn-glyphicon glyphicon-check img-circle text-primary'></span>${field.name }</div>
						</c:forEach>
					</div>
				</div>
			</c:forEach>
			</div>
		</c:when>

		<c:when test="${question.tagAttribute.type eq 'radio'}">
			<div data-qId="${question.id }">
				<p>${question.questionNumber}. <span>${question.description }</span></p>
				<c:forEach items="${question.choices}" var="choice" varStatus="loop">
					<div class="dropContainerCheckBox">
						<div class="radio" data-question-id="${question.id }" data-choice-index="${loop.index }">
							<label style="color:black;"> <input type="radio" name="question${question.questionNumber}" id="optionsRadios${choiceLoop.index }" value="" disabled> ${choice }</label>
							<c:forEach items="${question.pdfFields}" var="field">
								<div class='field fieldCheckBox btn icon-btn btn-primary' title='${field.pdf.name }' data-field-id='${field.id }' data-question-id='${question.id }'><span class='glyphicon btn-glyphicon glyphicon-check img-circle text-primary'></span>${field.name }</div>
							</c:forEach>
						</div>
					</div>	
				</c:forEach>
			</div>
		</c:when>

		<c:when test="${question.tagAttribute.type eq 'options'}">
			<div data-question-id="${question.id }" class="dropContainerComboBox">
				<p>${question.questionNumber}. <span>${question.description }</span></p>
				<c:forEach items="${question.pdfFields}" var="field">
					<div class='field fieldComboBox btn icon-btn btn-primary' title='${field.pdf.name }' data-field-id='${field.id }' data-question-id='${question.id }'><span class='glyphicon btn-glyphicon glyphicon-collapse-down img-circle text-primary'></span>${field.name }</div>
				</c:forEach>
			</div>
		</c:when>
		

		<c:when test="${question.tagAttribute.type eq 'file'}">
			<div data-question-id="${question.id }">
				<p>${question.questionNumber}. <span>${question.description }</span></p>
			</div>
		</c:when>
		<c:otherwise>
			<p>QUESTION TYPE NOT FOUND</p>
			<p>${question.tagAttribute.type }</p>
		</c:otherwise>
	</c:choose>
</div>