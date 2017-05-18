package formbuilder.model.pdfform.dao.jpa;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import formbuilder.model.pdfform.Pdf;
import formbuilder.model.pdfform.PdfField;
import formbuilder.model.pdfform.dao.PdfDao;

@Repository
@Transactional
public class PdfDaoImpl implements PdfDao {

	@PersistenceContext
	private EntityManager entityManager;

	@Override
	public Pdf getPdf(int id) {
		return entityManager.find(Pdf.class, id);
	}

	@Override
	public List<Pdf> getPdfs() {
		return entityManager.createQuery("from Pdf", Pdf.class).getResultList();
	}

	@Override
	public Pdf savePdf(Pdf pdf) {
		return entityManager.merge(pdf);
	}

	@Override
	public void deletePdf(int id) {
		System.out.println("id");
		System.out.println(id);
		entityManager.remove(getPdf(id));
	}

	@Override
	public PdfField getField(int fieldId) {
		return entityManager.find(PdfField.class, fieldId);
	}

}
