package formbuilder.web.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentCatalog;
import org.apache.pdfbox.pdmodel.interactive.form.PDAcroForm;
import org.apache.pdfbox.pdmodel.interactive.form.PDCheckBox;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import formbuilder.model.core.User;
import formbuilder.model.core.dao.UserDao;
import formbuilder.model.pdfform.Pdf;
import formbuilder.model.pdfform.PdfField;
import formbuilder.model.pdfform.dao.PdfDao;
import formbuilder.model.questionform.Answer;
import formbuilder.model.questionform.ChoiceAnswer;
import formbuilder.model.questionform.Form;
import formbuilder.model.questionform.Question;
import formbuilder.model.questionform.TextAnswer;
import formbuilder.model.questionform.dao.FormDao;

@Controller
@SessionAttributes({ "form", "question" })
@PropertySource("WEB-INF/formbuilder.properties")
public class FormToPdfController {

	@Autowired
	private FormDao formDao;

	@Autowired
	private UserDao userDao;

	@Autowired
	private PdfDao pdfDao;

	@Value("${upload.location}")
	private String uploadLocation;

	@GetMapping("/formToPdf/listForm.html")
	public String listForm(ModelMap models) {

		models.put("forms", formDao.getForms());
		return "formToPdf/listForm";
	}

	@GetMapping("/formToPdf/listPrintForm.html")
	public String listPrintForm(@RequestParam Integer id, ModelMap models) {

		// Set<User> users = form.getUsers();
		models.put("form", formDao.getForm(id));
		models.put("users", userDao.getUsers());
		return "formToPdf/listPrintForm";
	}

	@GetMapping("/formToPdf/mappingPdf.html")
	public String mappingPdf(ModelMap models) {


		List<Form> forms = formDao.getForms();
		List<Pdf> pdfs = pdfDao.getPdfs();

		models.put("forms", forms);
		models.put("pdfs", pdfs);

		return "formToPdf/mappingPdf";
	}

	@GetMapping("/formToPdf/mappingField.html")
	public String mappingField(@RequestParam Integer id, @RequestParam Integer pageNum, ModelMap models) {

		Form form = formDao.getForm(id);
		if (pageNum > form.getTotalPages())
			return "redirect:/formToPdf/mappingPage.html?id=" + id + "&pageNum=1";
		List<Question> questionsPage = form.getQuestionsPage(pageNum);
		
		List<Pdf> pdfs = form.getPdfs();
		
		
		models.put("form", form);
		models.put("questionsPage", questionsPage);
		models.put("pdfs", pdfs);

		return "formToPdf/mappingField";
	}

	@GetMapping("/formToPdf/printForm.html")
	public String printForm(@RequestParam Integer fId, @RequestParam Integer uId, ModelMap models) throws IOException {

		Form form = formDao.getForm(fId);
		User user = userDao.getUser(uId);

		Pdf pdf = pdfDao.getPdf(37);
		String filePath = uploadLocation + "/PDFresource/" + pdf.getName();
		File file = new File(filePath);
		PDDocument pdfTemplate = PDDocument.load(file);

		PDDocumentCatalog docCatalog = pdfTemplate.getDocumentCatalog();
		PDAcroForm acroForm = docCatalog.getAcroForm();

		List<PdfField> fields = pdf.getFields();

		for (PdfField field : fields) {
			// acroForm.getField("text_" + i).setValue("text_" + i);
			// acroForm.getField("cb" + i).setValue("Yes");
			// ((PDCheckBox) acroForm.getField("cb" + i)).check();
			if(field.getQuestion() != null){
				Answer answer = formDao.getAnswer(user, field.getQuestion());
    			switch(field.getFieldType()){
    			case "PDTextField" :
					acroForm.getField(field.getName()).setValue(((TextAnswer) answer).getText());
	        		break;
    			case "PDCheckBox" :
					ChoiceAnswer choiceAnswer = (ChoiceAnswer) answer;
					String[] selections = choiceAnswer.getSelections();
					if (field.getQuestion().getTagAttribute().getType().equalsIgnoreCase("checkbox")) {
						if (selections[field.getChoiceIndex()] != null)
							((PDCheckBox) acroForm.getField(field.getName())).check();
					} else if (field.getQuestion().getTagAttribute().getType().equalsIgnoreCase("radio")) {
						if (selections[0] != null && field.getChoiceIndex().toString().equals(selections[0]))
							((PDCheckBox) acroForm.getField(field.getName())).check();
					}
    			case "PDComboBox" :
					ChoiceAnswer optionAnswer = (ChoiceAnswer) answer;
					String[] optionSelections = optionAnswer.getSelections();
					for (String selection : optionSelections)
						System.out.println(selection);
	        		break;
    			default :
	        		break;	
    			
    			}
			}
		}
		String fileOutputPath = uploadLocation + "/uId_" + uId + "/PDFoutput/" + pdf.getName();
		File output = new File(fileOutputPath);
		output.getParentFile().mkdirs();
		pdfTemplate.save(output);
		pdfTemplate.close();
		return "formToPdf/listPrintForm";
	}


}
