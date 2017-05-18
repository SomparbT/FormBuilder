package formbuilder.web.controller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Collection;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import formbuilder.model.core.User;
import formbuilder.model.core.dao.UserDao;
import formbuilder.model.questionform.Answer;
import formbuilder.model.questionform.ChoiceAnswer;
import formbuilder.model.questionform.FileAnswer;
import formbuilder.model.questionform.Form;
import formbuilder.model.questionform.Question;
import formbuilder.model.questionform.TextAnswer;
import formbuilder.model.questionform.dao.FormDao;

@Controller

@SessionAttributes({ "form", "question" })
@PropertySource("WEB-INF/formbuilder.properties")
public class UserFormController {
	@Autowired
	private FormDao formDao;

	@Autowired
	private UserDao userDao;

	@Value("${upload.location}")
	private String uploadLocation;

	@GetMapping("/userForm/listForm.html")
	public String listForm(@RequestParam Integer uId, ModelMap models) {

		User user = userDao.getUser(uId);
		Set<Form> forms = user.getForms();

		models.put("user", user);
		models.put("forms", forms);

		return "userForm/listForm";
	}

	@GetMapping("/userForm/fillForm.html")
	public String fillForm(@RequestParam Integer uId, @RequestParam Integer fId, @RequestParam Integer pageNum,
			ModelMap models) {

		User user = userDao.getUser(uId);
		Form form = formDao.getForm(fId);
		List<Question> questionsPage = form.getQuestionsPage(pageNum);
		int numQuestion = questionsPage.size();
		// get all questions
		for (Question question : questionsPage) {
			// get answers from all users
			List<Answer> answers = question.getAnswers();
			boolean found = false;
			// searching for specific user answer and move to index 0
			if (answers.size() > 0) {
				for (Answer answer : answers) {
					if (answer.getUser().equals(user)) {
						found = true;
						answers.set(0, answer);
						break;
					}
				}
			}
			// not found answer create new one
			if (!found) {
				if (question.getType().equals("TEXT")) {
					TextAnswer newAnswer = new TextAnswer();
					newAnswer.setUser(user);
					newAnswer.setQuestion(question);
					if (answers.size() > 0)
						answers.set(0, newAnswer);
					else
						answers.add(newAnswer);
				} else if (question.getType().equals("CHOICE")) {
					ChoiceAnswer newAnswer = new ChoiceAnswer();
					newAnswer.setUser(user);
					newAnswer.setQuestion(question);
					if (answers.size() > 0)
						answers.set(0, newAnswer);
					else
						answers.add(newAnswer);
				} else if (question.getType().equals("FILE")) {
					FileAnswer newAnswer = new FileAnswer();
					newAnswer.setUser(user);
					newAnswer.setQuestion(question);
					if (answers.size() > 0)
						answers.set(0, newAnswer);
					else
						answers.add(newAnswer);
				}

			}
		}

		models.put("form", form);
		models.put("numQuestion", numQuestion);
		models.put("user", user);


		return "userForm/fillForm";
	}

	@PostMapping("/userForm/fillForm.html")
	public String fillForm(@ModelAttribute Form form, @RequestParam Integer uId, @RequestParam Integer fId,
			@RequestParam Integer pageNum, SessionStatus sessionStatus, HttpServletRequest request) {

		formDao.saveForm(form);

		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		Collection<List<MultipartFile>> listFiles = multipartRequest.getMultiFileMap().values();
		for (List<MultipartFile> files : listFiles) {
			for (MultipartFile file : files) {
				if (file.isEmpty()) {
					System.out.println("Empty File");
					continue; // next pls
				}

				try {
					String qId = file.getName().replace("question", "");
					FileAnswer answer = (FileAnswer) formDao.getAnswer(userDao.getUser(uId),
							formDao.getQuestion(Integer.parseInt(qId)));
					System.out.println(file.getOriginalFilename());
					if (!answer.getFiles().contains(file.getOriginalFilename())) {
						byte[] bytes = file.getBytes();
						// Path is C:/temp/formbuilder/uId_XX/qId_YY/FILE
						Path path = Paths
								.get(uploadLocation + "uId_" + uId + "/qId_"
										+ qId + "/" + file.getOriginalFilename());
						Files.createDirectories(path.getParent());
						Files.write(path, bytes);
						answer.getFiles().add(file.getOriginalFilename());
						formDao.saveAnswer(answer);
						System.out.println("add " + file.getOriginalFilename());
					}

				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}


		sessionStatus.setComplete();
		return "redirect:/userForm/fillForm.html?uId=" + uId + "&fId=" + fId + "&pageNum=" + pageNum;

	}

	@GetMapping("userForm/viewFileAnswer.html")
	public void viewFileAnswer(HttpServletResponse response, @RequestParam Integer uId, @RequestParam Integer qId,
			@RequestParam String filename) throws IOException {

		String path = uploadLocation + "uId_" + uId + "/qId_" + qId + "/"
				+ filename;
		File file = new File(path);

		if (!file.exists()) {
			String errorMessage = "Sorry. The file you are looking for does not exist";
			System.out.println("Sorry. The file you are looking for does not exist");
			OutputStream outputStream = response.getOutputStream();
			outputStream.write(errorMessage.getBytes(Charset.forName("UTF-8")));
			outputStream.close();
			return;
		}

		String mimeType = URLConnection.guessContentTypeFromName(file.getName());
		if (mimeType == null) {
			System.out.println(
					"mimetype is not detectable, will take default" + file.getName() + " " + file.getAbsolutePath());
			mimeType = "application/octet-stream";
		}

		System.out.println("mimetype : " + mimeType);

		response.setContentType(mimeType);
		response.setHeader("Content-Disposition", String.format("inline; filename=\"" + file.getName() + "\""));
		response.setContentLength((int) file.length());

		InputStream inputStream = new BufferedInputStream(new FileInputStream(file));

		FileCopyUtils.copy(inputStream, response.getOutputStream());
	}

	@GetMapping("userForm/deleteFileAnswer.html")
	public String deleteFileAnswer(@RequestParam Integer uId, @RequestParam Integer fId, @RequestParam Integer pageNum,
			@RequestParam Integer qId, @RequestParam String filename) {

		String path = uploadLocation + "uId_" + uId + "/qId_" + qId + "/"
				+ filename;
		System.out.println("delete " + path);
		File file = new File(path);
		file.delete();
		FileAnswer answer = (FileAnswer) formDao.getAnswer(userDao.getUser(uId), formDao.getQuestion(qId));
		answer.getFiles().remove(filename);
		formDao.saveAnswer(answer);

		return "redirect:/userForm/fillForm.html?uId=" + uId + "&fId=" + fId + "&pageNum=" + pageNum;
	}

	@GetMapping("/userForm/listFilledPdf.html")
	public String listFilledPdf(@RequestParam Integer uId, ModelMap models) {

		User user = userDao.getUser(uId);
		List<String> filledForms = user.getFilledForms();

		models.put("user", user);
		models.put("filledForms", filledForms);

		return "userForm/listFilledPdf";
	}

	@GetMapping("userForm/viewFilledPdf.html")
	public void viewFilledPdf(HttpServletResponse response, @RequestParam Integer uId, @RequestParam String filename)
			throws IOException {

		String path = uploadLocation + "uId_" + uId + "/PDFoutput/" + filename;
		File file = new File(path);

		if (!file.exists()) {
			String errorMessage = "Sorry. The file you are looking for does not exist";
			System.out.println("Sorry. The file you are looking for does not exist");
			OutputStream outputStream = response.getOutputStream();
			outputStream.write(errorMessage.getBytes(Charset.forName("UTF-8")));
			outputStream.close();
			return;
		}

		String mimeType = URLConnection.guessContentTypeFromName(file.getName());
		if (mimeType == null) {
			System.out.println(
					"mimetype is not detectable, will take default" + file.getName() + " " + file.getAbsolutePath());
			mimeType = "application/octet-stream";
		}

		System.out.println("mimetype : " + mimeType);

		response.setContentType(mimeType);
		response.setHeader("Content-Disposition", String.format("inline; filename=\"" + file.getName() + "\""));
		response.setContentLength((int) file.length());

		InputStream inputStream = new BufferedInputStream(new FileInputStream(file));

		FileCopyUtils.copy(inputStream, response.getOutputStream());
	}

	@GetMapping("userForm/downloadFilledPdf.html")
	public void downloadFilledPdf(HttpServletResponse response, @RequestParam Integer uId,
			@RequestParam String filename) throws IOException {

		String path = uploadLocation + "uId_" + uId + "/PDFoutput/" + filename;
		File file = new File(path);
		String mimeType = URLConnection.guessContentTypeFromName(file.getName());
		if (mimeType == null) {
			System.out.println(
					"mimetype is not detectable, will take default" + file.getName() + " " + file.getAbsolutePath());
			mimeType = "application/octet-stream";
		}

		response.setContentType(mimeType);

		/*
		 * "Content-Disposition : inline" will show viewable types [like
		 * images/text/pdf/anything viewable by browser] right on browser while
		 * others(zip e.g) will be directly downloaded [may provide save as
		 * popup, based on your browser setting.]
		 */
		response.setHeader("Content-Disposition", String.format("atachment; filename=\"" + file.getName() + "\""));

		/*
		 * "Content-Disposition : attachment" will be directly download, may
		 * provide save as popup, based on your browser setting
		 */
		// response.setHeader("Content-Disposition", String.format("attachment;
		// filename=\"%s\"", file.getName()));

		response.setContentLength((int) file.length());

		InputStream inputStream = new BufferedInputStream(new FileInputStream(file));

		// Copy bytes from source to destination(outputstream in this example),
		// closes both streams.
		FileCopyUtils.copy(inputStream, response.getOutputStream());
	}

	@GetMapping("userForm/deleteFilledPdf.html")
	public String deleteFilledPdf(@RequestParam Integer uId, @RequestParam String filename) {

		String path = uploadLocation + "uId_" + uId + "/PDFoutput/" + filename;
		System.out.println("delete " + path);
		File file = new File(path);
		file.delete();
		User user = userDao.getUser(uId);
		user.getFilledForms().remove(filename);
		userDao.saveUser(user);

		return "redirect:/userForm/listFilledPdf";
	}

}
