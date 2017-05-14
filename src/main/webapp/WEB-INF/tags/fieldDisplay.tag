<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ attribute name="question" required="true" type="formbuilder.model.questionform.Question"%>
<%@ tag body-content="scriptless"%>


<div class="form-group row" style="margin-left: 10px; margin-top: 10px;">
	<c:choose>
		<c:when test="${question.tagAttribute.type eq 'text'}">
			<div class="question-number">
				<label for="question${question.questionNumber }" class="control-label">${question.questionNumber}. <span>${question.description }</span></label>
			</div>
			<div class="${question.tagAttribute.size } input-group">
				<c:choose>
					<c:when test="${question.tagAttribute.inputType eq 'email' }">
						<div class="input-group-addon">
							<span class="glyphicon glyphicon-envelope"></span>
						</div>
					</c:when>
					<c:when test="${question.tagAttribute.inputType eq 'tel' }">
						<div class="input-group-addon">
							<span class="glyphicon glyphicon-earphone"></span>
						</div>
					</c:when>
					<c:when test="${question.tagAttribute.inputType eq 'time' }">
						<div class="input-group-addon">
							<span class="glyphicon glyphicon-time"></span>
						</div>
					</c:when>
					<c:when test="${question.tagAttribute.inputType eq 'url' }">
						<div class="input-group-addon">http://</div>
					</c:when>
					<c:when test="${question.tagAttribute.inputType eq 'date' }">
						<div class="input-group-addon">
							<span class="glyphicon glyphicon-calendar"></span>
						</div>
					</c:when>
				</c:choose>
				<input type="${question.tagAttribute.inputType}" class="form-control" id="question${question.questionNumber}" placeholder="${question.tagAttribute.placeholder }">
			</div>
		</c:when>

		<c:when test="${question.tagAttribute.type eq 'number'}">
			<div class="question-number">
				<label for="question${question.questionNumber}" class="control-label">${question.questionNumber}. <span>${question.description }</span></label>
			</div>
			<div class="${question.tagAttribute.size }">
				<input type="number" class="form-control" id="question${question.questionNumber}" min="${question.tagAttribute.min}" max="${question.tagAttribute.max}" step="${question.tagAttribute.step}"
					placeholder="${question.tagAttribute.placeholder }">
			</div>
		</c:when>

		<c:when test="${question.tagAttribute.type eq 'textarea'}">
			<div class="question-number">
				<label for="question${question.questionNumber}" class="control-label">${question.questionNumber}. <span>${question.description }</span></label>
			</div>
			<div class="${question.tagAttribute.size }">
				<textarea class="form-control" rows="${question.tagAttribute.rows}"></textarea>
			</div>
		</c:when>

		<c:when test="${question.tagAttribute.type eq 'checkbox'}">
			<div class="question-number">
				<label for="question${question.questionNumber}" class="control-label">${question.questionNumber}. <span>${question.description }</span></label>
			</div>
			<c:forEach items="${question.choices}" var="choice">
				<div class="checkbox">
					<label> <input type="checkbox" value=""> ${choice }
					</label>
				</div>
			</c:forEach>
		</c:when>

		<c:when test="${question.tagAttribute.type eq 'radio'}">
			<div class="question-number">
				<label for="question${question.questionNumber}" class="control-label">${question.questionNumber}. <span>${question.description }</span></label>
			</div>
			<c:forEach items="${question.choices}" var="choice" varStatus="loop">
				<div class="radio">
					<label> <input type="radio" name="question${question.questionNumber}" id="optionsRadios${loop.index }" value=""> ${choice }
					</label>
				</div>
			</c:forEach>
		</c:when>

		<c:when test="${question.tagAttribute.type eq 'options'}">
			<div class="question-number">
				<label for="question${question.questionNumber}" class="control-label">${question.questionNumber}. <span>${question.description }</span></label>
			</div>
			<div class="${question.tagAttribute.size }">
				<select class="form-control">
					<option label=" "></option>
					<c:forEach items="${question.choices}" var="choice">
						<option>${choice }</option>
					</c:forEach>
				</select>
			</div>
		</c:when>
		
		<c:when test="${question.tagAttribute.type eq 'file'}">
			<div>
				<label for="question${question.questionNumber}"
					class="control-label">${question.questionNumber}.
					${question.description}</label>
			</div>
			<div class="form-group">
				<input type="file" name="file" multiple> <input type="text"
					class="form-control"
					placeholder="Browse or Drag your file here to upload" readonly>
			</div>


		</c:when>
		<c:otherwise>
			<p>QUESTION TYPE NOT FOUND</p>
			<p>${question.tagAttribute.type }</p>
		</c:otherwise>
	</c:choose>
</div>