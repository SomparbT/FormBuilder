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
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentCatalog;
import org.apache.pdfbox.pdmodel.interactive.form.PDAcroForm;
import org.apache.pdfbox.pdmodel.interactive.form.PDField;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import formbuilder.model.pdfform.Pdf;
import formbuilder.model.pdfform.PdfField;
import formbuilder.model.pdfform.dao.PdfDao;

@Controller
public class PdfController {

	@Autowired
	private PdfDao pdfDao;

	@Value("${upload.location}")
	private String uploadLocation;

	@GetMapping("/pdf/listPdf.html")
	public String listPdf(ModelMap models) {

		models.put("pdfs", pdfDao.getPdfs());
		return "pdf/listPdf";
	}

	@PostMapping("/pdf/uploadPdf.html")
	public String uploadPdf(HttpServletRequest request, @RequestParam("uploadFile") MultipartFile uploadFile,
			RedirectAttributes redirectAttributes) {

		if (uploadFile.isEmpty()) {
			redirectAttributes.addFlashAttribute("message", "Please select a file to upload");
			return "redirect:/pdf/listPdf.html";
		}

		String fileName = uploadFile.getOriginalFilename();
		String fileType = fileName.substring(fileName.lastIndexOf('.') + 1);
		String filePath = uploadLocation + "/PDFresource/" + uploadFile.getOriginalFilename();

		if (!fileType.equalsIgnoreCase("pdf")) {
			redirectAttributes.addFlashAttribute("message", "Please select pdf file only");
			return "redirect:/pdf/listPdf.html";
		}

		try {
			// Get the file and save it somewhere
			byte[] bytes = uploadFile.getBytes();
			Path path = Paths.get(filePath);
			Files.createDirectories(path.getParent());
			Files.write(path, bytes);

			redirectAttributes.addFlashAttribute("message",
					"You successfully uploaded '" + uploadFile.getOriginalFilename() + "'");

			// create Pdf Object
			Pdf pdf = new Pdf();
			pdf.setName(uploadFile.getOriginalFilename());

			// add pdf fields to pdf object
			File file = new File(filePath);
			PDDocument pdfTemplate = PDDocument.load(file);

			PDDocumentCatalog docCatalog = pdfTemplate.getDocumentCatalog();
			PDAcroForm acroForm = docCatalog.getAcroForm();

			if (acroForm.getFields() == null) {
				redirectAttributes.addFlashAttribute("message", "This file has no field!");
				return "redirect:/pdf/listPdf.html";
			}

			List<PDField> pdFields = acroForm.getFields();
			for (PDField pdField : pdFields) {
				PdfField field = new PdfField();
				field.setName(pdField.getFullyQualifiedName());
				String fullClassName = pdField.getClass().getName();
				String className = fullClassName.substring(fullClassName.lastIndexOf('.') + 1);
				field.setFieldType(className);
				pdf.addField(field);
			}

			pdfDao.savePdf(pdf);
			pdfTemplate.close();

		} catch (IOException e) {
			e.printStackTrace();
		}

		return "redirect:/pdf/listPdf.html";
	}

	@GetMapping("/pdf/viewPdf.html")
	public void viewPdf(HttpServletResponse response, @RequestParam Integer fileId) throws IOException {

		Pdf pdf = pdfDao.getPdf(fileId);
		String filePath = uploadLocation + "/PDFresource/" + pdf.getName();
		File file = new File(filePath);

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

		/*
		 * "Content-Disposition : inline" will show viewable types [like
		 * images/text/pdf/anything viewable by browser] right on browser while
		 * others(zip e.g) will be directly downloaded [may provide save as
		 * popup, based on your browser setting.]
		 */
		response.setHeader("Content-Disposition", String.format("inline; filename=\"" + file.getName() + "\""));

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

	@GetMapping("/pdf/downloadPdf.html")
	public void downloadPdf(HttpServletResponse response, @RequestParam Integer fileId) throws IOException {

		Pdf pdf = pdfDao.getPdf(fileId);
		String filePath = uploadLocation + "/PDFresource/" + pdf.getName();
		File file = new File(filePath);
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

	@GetMapping("/pdf/deletePdf.html")
	public String deletePdf(@RequestParam Integer fileId) {

		Pdf pdf = pdfDao.getPdf(fileId);
		String filePath = uploadLocation + "/PDFresource/" + pdf.getName();
		File file = new File(filePath);
		file.delete();
		pdfDao.deletePdf(fileId);

		return "redirect:/pdf/listPdf.html";
	}

	@GetMapping("/pdf/renamePdf.html")
	public String renamePdf(@RequestParam Integer fileId, @RequestParam String newFileName) {

		Pdf pdf = pdfDao.getPdf(fileId);
		String filePath = uploadLocation + "/PDFresource/" + pdf.getName();
		File file = new File(filePath);
		File newFile = new File(file.getParentFile() + "/" + newFileName + ".pdf");
		file.renameTo(newFile);
		pdf.setName(newFileName + ".pdf");
		pdfDao.savePdf(pdf);

		return "redirect:/pdf/listPdf.html";
	}

}
