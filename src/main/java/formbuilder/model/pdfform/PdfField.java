package formbuilder.model.pdfform;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;

import formbuilder.model.questionform.Question;

@Entity
@Table(name = "pdf_fields")
@JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
public class PdfField implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue
	private int id;

	private String name;

	private boolean enabled;

	private Integer choiceIndex;

	@ManyToOne
	@JsonIgnoreProperties("fields")
	private Question question;

	@ManyToOne
	@JsonIgnoreProperties("fields")
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
