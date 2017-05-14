<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ attribute name="question" required="true" type="formbuilder.model.questionform.Question"%>
<%@ tag body-content="scriptless"%>


<div class="form-group row" style="margin-left: 10px; margin-top: 10px;">
	<c:choose>
		<c:when test="${question.tagAttribute.type eq 'text'}">
			<div data-qId="${question.id }" class="dropContainer">
				<p>${question.questionNumber}. <span>${question.description }</span></p>
			</div>
		</c:when>

		<c:when test="${question.tagAttribute.type eq 'number'}">
			<div data-qId="${question.id }" class="dropContainer">
				<p>${question.questionNumber}. <span>${question.description }</span></p>
			</div>
		</c:when>

		<c:when test="${question.tagAttribute.type eq 'textarea'}">
			<div data-qId="${question.id }" class="dropContainer">
				<p>${question.questionNumber}. <span>${question.description }</span></p>
			</div>
		</c:when>

		<c:when test="${question.tagAttribute.type eq 'checkbox'}">
			<div data-qId="${question.id }">
				<p>${question.questionNumber}. <span>${question.description }</span></p>
			<c:forEach items="${question.choices}" var="choice" varStatus="loop">
				<div class="checkbox" data-qId="${question.id }" data-choiceIndex="${loop.index }" class="dropContainer">
					<label> <input type="checkbox" value=""> ${choice }</label>
				</div>
			</c:forEach>
			</div>
		</c:when>

		<c:when test="${question.tagAttribute.type eq 'radio'}">
			<div data-qId="${question.id }">
				<p>${question.questionNumber}. <span>${question.description }</span></p>
				<c:forEach items="${question.choices}" var="choice" varStatus="loop">
					<div class="radio" data-qId="${question.id }" data-choiceIndex="${loop.index }" class="dropContainer">
						<label> <input type="radio" name="question${question.questionNumber}" id="optionsRadios${choiceLoop.index }" value=""> ${choice }</label>
					</div>
				</c:forEach>
			</div>
		</c:when>

		<c:when test="${question.tagAttribute.type eq 'options'}">
			<div data-qId="${question.id }" class="dropContainer">
				<p>${question.questionNumber}. <span>${question.description }</span></p>
			</div>
		</c:when>
		
		<c:when test="${question.tagAttribute.type eq 'file'}">
			<div data-qId="${question.id }" class="dropContainer">
				<p>${question.questionNumber}. <span>${question.description }</span></p>
			</div>
		</c:when>
		<c:otherwise>
			<p>QUESTION TYPE NOT FOUND</p>
			<p>${question.tagAttribute.type }</p>
		</c:otherwise>
	</c:choose>
</div>