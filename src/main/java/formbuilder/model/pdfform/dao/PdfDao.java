package formbuilder.model.pdfform.dao;

import formbuilder.model.pdfform.Pdf;

public interface PdfDao {

	Pdf getPdf(int id);

	Pdf getPdf(String name);

	Pdf savePdf(Pdf pdf);

	void deletePdf(int id);

	void deletePdf(String name);

}
