package formbuilder.model.pdfform;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import formbuilder.model.questionform.Question;

@Entity
@Table(name = "pdf_fields")
public class PdfField implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue
	private int id;

	private String name;

	private boolean enabled;

	private Integer choiceIndex;

	@ManyToOne
	private Question question;

	@ManyToOne
	private Pdf pdf;

	private String fieldType;

	public PdfField() {
		enabled = true;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Pdf getPdf() {
		return pdf;
	}

	public void setPdf(Pdf pdf) {
		this.pdf = pdf;
	}

	public boolean isEnabled() {
		return enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	public Question getQuestion() {
		return question;
	}

	public void setQuestion(Question question) {
		this.question = question;
	}

	public String getFieldType() {
		return fieldType;
	}

	public void setFieldType(String fieldType) {
		this.fieldType = fieldType;
	}

	public Integer getChoiceIndex() {
		return choiceIndex;
	}

	public void setChoiceIndex(Integer choiceIndex) {
		this.choiceIndex = choiceIndex;
	}

}
