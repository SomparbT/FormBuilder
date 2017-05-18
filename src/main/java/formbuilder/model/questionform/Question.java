package formbuilder.model.questionform;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.DiscriminatorColumn;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonIgnore;

import formbuilder.model.pdfform.PdfField;

@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@Table(name = "questions")
@DiscriminatorColumn(name = "question_type")
public abstract class Question implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue
	protected int id;

	protected String description;

	@OneToMany(mappedBy = "question", cascade = CascadeType.ALL)
	@JsonIgnore
	protected List<Answer> answers;

	@Column(name = "question_number")
	protected int questionNumber;

	protected boolean enabled;

	@ManyToOne
	@JsonIgnore
	protected Form form;

	@Column(name = "page_number")
	protected int pageNumber;

	@Embedded
	protected TagAttribute tagAttribute;

	@OneToMany(mappedBy = "question")
	@JsonIgnore
	protected List<PdfField> fields;

	public Question() {
		enabled = true;
		answers = new ArrayList<Answer>();
		tagAttribute = new TagAttribute();
		fields = new ArrayList<PdfField>();
	}

	public abstract String getType();

	public abstract Question clone();

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public List<Answer> getAnswers() {
		return answers;
	}

	public void setAnswers(List<Answer> answers) {
		this.answers = answers;
	}

	public int getQuestionNumber() {
		return questionNumber;
	}

	public void setQuestionNumber(int questionNumber) {
		this.questionNumber = questionNumber;
	}

	public boolean isEnabled() {
		return enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	public Form getForm() {
		return form;
	}

	public void setForm(Form form) {
		this.form = form;
	}

	public int getPageNumber() {
		return pageNumber;
	}

	public void setPageNumber(int pageNumber) {
		this.pageNumber = pageNumber;
	}

	public TagAttribute getTagAttribute() {
		return tagAttribute;
	}

	public void setTagAttribute(TagAttribute tagAttribute) {
		this.tagAttribute = tagAttribute;
	}

	public List<PdfField> getFields() {
		return fields;
	}

	public void setFields(List<PdfField> fields) {
		this.fields = fields;
	}

	public void addField(PdfField field) {
		field.setQuestion(this);
		fields.add(field);
	}

	public void removeField(PdfField field) {
		fields.remove(field);
		if (field != null) {
			field.setQuestion(null);
		}
	}
}
