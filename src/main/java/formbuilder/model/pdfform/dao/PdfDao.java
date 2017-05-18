package formbuilder.model.pdfform.dao;

import java.util.List;

import formbuilder.model.pdfform.Pdf;
import formbuilder.model.pdfform.PdfField;

public interface PdfDao {

	Pdf getPdf(int id);

	List<Pdf> getPdfs();

	Pdf savePdf(Pdf pdf);

	void deletePdf(int id);

	PdfField getField(int fieldId);

}
