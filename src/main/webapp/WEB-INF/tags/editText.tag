<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ tag body-content="scriptless"%>

<form:form  modelAttribute="question" class = "form" >
	<div class="form-group">
		<div><label>Description</label></div>			
		<form:input path="description" cssClass="form-control" required="required"/>
	</div>
	<div><label>Control</label><a class="btn btn-link" href="#textControlEditSection" data-toggle="collapse">Hide</a></div>
		<div class="collapse" id="textControlEditSection">
			<form:checkbox path="tagAttribute.required" label="Required" />
		</div>
	<div><label>Appearance</label><a class="btn btn-link" href="#textAppearanceEditSection" data-toggle="collapse">Hide</a></div>
		<div class="collapse in" id="textAppearanceEditSection">
			<div class="form-group">
				<label>Input Type</label>
				<form:select path="tagAttribute.inputType" cssClass="form-control">
	            	<form:option value="text" label="Text" />
	            	<form:option value="email" label="Email" />
	            	<form:option value="tel" label="Telephone number" />
	            	<form:option value="time" label="Time" />
	            	<form:option value="url" label="URL" />
	            	<form:option value="date" label="Date" />
            	</form:select>			
			</div>
			<div class="form-group">
				<label>Size</label>
				<form:select path="tagAttribute.size" cssClass="form-control">
	            	<form:option value="col-lg-3" label="Small" />
	            	<form:option value="col-lg-6" label="Medium" />
	            	<form:option value="col-lg-9" label="Large" />
            	</form:select>			
			</div>
			<div class="form-group">
				<label>Placeholder</label>			
				<form:input path="tagAttribute.placeholder" cssClass="form-control"/>
			</div>
		</div>
	<button type="submit" class="btn btn-primary btn-sm"><span class="glyphicon glyphicon-floppy-disk"></span> SAVE</button>						
</form:form>

