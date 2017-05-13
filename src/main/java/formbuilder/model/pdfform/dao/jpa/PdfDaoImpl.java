package formbuilder.model.pdfform.dao.jpa;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import formbuilder.model.pdfform.Pdf;
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
	public Pdf getPdf(String name) {
		List<Pdf> pdfs = entityManager.createQuery("from Pdf where name = :name", Pdf.class).setParameter("name", name)
				.getResultList();
		return pdfs.size() == 0 ? null : pdfs.get(0);
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
	public void deletePdf(String name) {
		System.out.println("name");
		System.out.println(name);
		entityManager.remove(getPdf(name));

	}

}
