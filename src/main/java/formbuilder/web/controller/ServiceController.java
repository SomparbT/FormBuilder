package formbuilder.web.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import formbuilder.model.pdfform.PdfField;
import formbuilder.model.pdfform.dao.PdfDao;
import formbuilder.model.questionform.Question;
import formbuilder.model.questionform.dao.FormDao;

@Controller
public class ServiceController {

	@Autowired
	private PdfDao pdfDao;

	@Autowired
	private FormDao formDao;

	@GetMapping("/service/listFields/{id}")
	@ResponseBody
	public List<PdfField> listFields(@PathVariable Integer id) {

		return pdfDao.getPdf(id).getFields();

	}

	@PostMapping("/service/mapField/{qId}/{fieldId}")
	@ResponseBody
	public void mapField(@PathVariable Integer qId, @PathVariable Integer fieldId) {
		System.out.println("service reach");
		Question question = formDao.getQuestion(qId);
		PdfField field = pdfDao.getField(fieldId);
		question.addField(field);
		formDao.saveQuestion(question);
	}

	@PostMapping("/service/unmapField/{qId}/{fieldId}")
	@ResponseBody
	public void unmapField(@PathVariable Integer qId, @PathVariable Integer fieldId) {

		Question question = formDao.getQuestion(qId);
		PdfField field = pdfDao.getField(fieldId);
		question.removeField(field);
		formDao.saveQuestion(question);
	}

	@PostMapping("/service/mapFieldChoice/{qId}/{fieldId}/{choiceIndex}")
	@ResponseBody
	public void mapFieldChoice(@PathVariable Integer qId, @PathVariable Integer fieldId,
			@PathVariable Integer choiceIndex) {

		Question question = formDao.getQuestion(qId);
		PdfField field = pdfDao.getField(fieldId);
		field.setChoiceIndex(choiceIndex);
		question.addField(field);
		formDao.saveQuestion(question);
	}

}
