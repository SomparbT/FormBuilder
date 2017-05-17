package formbuilder.model.pdfform;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;

@Entity
@Table(name = "pdfs")
@JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
public class Pdf implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue
	private int id;
	private String name;

	@OneToMany(mappedBy = "pdf", cascade = CascadeType.ALL, orphanRemoval = true)
	@JsonIgnoreProperties("pdf")
	List<PdfField> fields;

	private boolean enabled;

	public Pdf() {
		enabled = true;
		fields = new ArrayList<PdfField>();
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

	public List<PdfField> getFields() {
		return fields;
	}

	public void setFields(List<PdfField> fields) {
		this.fields = fields;
	}

	public boolean isEnabled() {
		return enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	public void addField(PdfField field) {
		field.setPdf(this);
		fields.add(field);
	}

	public void removeField(PdfField field) {
		fields.remove(field);
		if (field != null) {
			field.setPdf(null);
		}
	}

}
