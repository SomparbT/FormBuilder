package formbuilder.web.controller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentCatalog;
import org.apache.pdfbox.pdmodel.interactive.form.PDAcroForm;
import org.apache.pdfbox.pdmodel.interactive.form.PDField;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import formbuilder.model.pdfform.Pdf;
import formbuilder.model.pdfform.PdfField;
import formbuilder.model.pdfform.dao.PdfDao;
import formbuilder.model.uploadfile.UploadFile;
import formbuilder.model.uploadfile.dao.UploadFileDao;

@Controller
public class PdfController {

	@Autowired
	private UploadFileDao uploadFileDao;

	@Autowired
	private PdfDao pdfDao;

	@Autowired
	private WebApplicationContext context;

	@RequestMapping(value = "/pdf/upload.html", method = RequestMethod.GET)
	public String showUploadForm(HttpServletRequest request) throws IOException {

		String realPath = context.getServletContext().getRealPath("/PDFresource");
		System.out.println(realPath);
		File dir = new File(realPath);
		dir.mkdir();
		request.setAttribute("path", dir);
		File[] files = dir.listFiles();
		if (files.length > 0) {
			request.setAttribute("files", files);
		}
		return "/pdf/upload";
	}

	@RequestMapping(value = "/pdf/upload.html", method = RequestMethod.POST)
	public String handleFileUpload(HttpServletRequest request, @RequestParam CommonsMultipartFile fileUpload,
			RedirectAttributes redirectAttributes) throws Exception {

		if (fileUpload != null) {

			System.out.println("Saving file: " + fileUpload.getOriginalFilename());
			UploadFile uploadFile = new UploadFile();
			uploadFile.setFileName(fileUpload.getOriginalFilename());
			uploadFile.setData(fileUpload.getBytes());
			uploadFileDao.save(uploadFile);

			if (!fileUpload.isEmpty()) {
				String fileName = fileUpload.getOriginalFilename();
				String fileType = fileName.substring(fileName.lastIndexOf('.') + 1);

				if (fileType.equals("pdf")) {

					try {
						// Creating the directory to store file
						String realPath = context.getServletContext().getRealPath("/PDFresource");
						File dir = new File(realPath);
						if (!dir.exists())
							dir.mkdirs();

						// Create the file on server
						fileUpload.transferTo(new File(dir, fileName));
						redirectAttributes.addFlashAttribute("message", "You successfully uploaded '" + fileName + "'");
						System.out.println("You successfully uploaded file=" + fileName);

						// create Pdf Object
						Pdf pdf = new Pdf();
						pdf.setName(fileUpload.getOriginalFilename());

						// add pdf fields to pdf object
						File file = new File(realPath + "/" + fileUpload.getOriginalFilename());
						PDDocument pdfTemplate = PDDocument.load(file);

						PDDocumentCatalog docCatalog = pdfTemplate.getDocumentCatalog();
						PDAcroForm acroForm = docCatalog.getAcroForm();

						if (acroForm.getFields() != null) {
							System.out.println("not null");
							List<PDField> pdFields = acroForm.getFields();
							for (PDField pdField : pdFields) {
								PdfField field = new PdfField();
								field.setName(pdField.getFullyQualifiedName());
								String fullClassName = pdField.getClass().getName();
								String className = fullClassName.substring(fullClassName.lastIndexOf('.') + 1);
								field.setFieldType(className);
								pdf.addField(field);
							}
						} else {
							System.out.println("null");
							redirectAttributes.addFlashAttribute("message", "This file has no field!");
						}
						pdfDao.savePdf(pdf);
						pdfTemplate.close();

					} catch (Exception e) {
						System.out.println(
								"You failed to upload " + fileUpload.getOriginalFilename() + " => " + e.getMessage());
					}
				} else {
					redirectAttributes.addFlashAttribute("message", "The file must be pdf only");
				}
			} else {
				redirectAttributes.addFlashAttribute("message", "Please select a file to upload");
				System.out.println(
						"You failed to upload " + fileUpload.getOriginalFilename() + " because the file was empty.");
			}

		}

		return "redirect:/pdf/upload.html";
	}

	// ###################### view file ####################

	@RequestMapping(value = "/pdf/upload/view.html", method = RequestMethod.GET)
	public void viewFile(HttpServletResponse response, @RequestParam File f) throws IOException {

		// String realPath =
		// context.getServletContext().getRealPath("/PDFresource");
		File file = new File(f.getAbsolutePath());

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

	// ################### Download #####################
	@RequestMapping(value = "/pdf/upload/download.html", method = RequestMethod.GET)
	public void downloadFile(HttpServletResponse response, @RequestParam File f) throws IOException {

		File file = new File(f.getAbsolutePath());
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

	// ###################### delete file ####################

	@RequestMapping(value = "/pdf/upload/delete.html", method = RequestMethod.GET)
	public String deleteFile(@RequestParam File f) {

		System.out.println("delete" + f.getAbsolutePath());
		File file = new File(f.getAbsolutePath());
		file.delete();
		System.out.println(f.getName());
		pdfDao.deletePdf(f.getName());

		return "redirect:/pdf/upload.html";
	}

	@RequestMapping(value = "/pdf/upload/rename.html", method = RequestMethod.GET)
	public String renameFile(@RequestParam String fileName, @RequestParam String userName) {

		File f = new File(fileName);
		File newName = new File(f.getParentFile() + "/" + userName + ".pdf");
		f.renameTo(newName);
		return "redirect:/pdf/upload.html";
	}

	@RequestMapping(value = "/pdf/listFields/{id}", method = RequestMethod.GET)
	@ResponseBody
	public List<PdfField> listFields(@PathVariable Integer id) {
		System.out.println("reach");
		Pdf pdf = pdfDao.getPdf(id);
		System.out.println(pdf.getName());
		return pdfDao.getPdf(id).getFields();
	}

}
