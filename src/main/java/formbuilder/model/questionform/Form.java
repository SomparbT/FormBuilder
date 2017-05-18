package formbuilder.model.questionform;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Table;

import formbuilder.model.core.User;
import formbuilder.model.pdfform.Pdf;

@Entity
@Table(name = "forms")
public class Form implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue
	private int id;

	private String name;

	private String description;

	private boolean enabled;
	
	private boolean published;

	@OneToMany(mappedBy = "form", cascade = CascadeType.ALL, orphanRemoval = true)
	@OrderBy("pageNumber, questionNumber")
	private List<Question> questions;

	@ManyToMany
	private Set<User> users;

	@Column(name = "notification_email")
	private String notificationEmail;

	@Column(name = "total_pages")
	private int totalPages;

	@OneToMany(mappedBy = "form")
	private List<Pdf> pdfs;

	private boolean userPrintable;

	public Form() {
		enabled = true;
		questions = new ArrayList<Question>();
		pdfs = new ArrayList<Pdf>();
		users = new HashSet<User>();
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

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public boolean isEnabled() {
		return enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	public Set<User> getUsers() {
		return users;
	}

	public void setUsers(Set<User> users) {
		this.users = users;
	}

	public String getNotificationEmail() {
		return notificationEmail;
	}

	public void setNotificationEmail(String notificationEmail) {
		this.notificationEmail = notificationEmail;
	}

	public List<Question> getQuestions() {
		return questions;
	}

	public void setQuestions(List<Question> questions) {
		this.questions = questions;
	}

	public int getTotalPages() {
		return totalPages;
	}

	public void setTotalPages(int totalPages) {
		this.totalPages = totalPages;
	}

	public boolean isPublished() {
		return published;
	}

	public void setPublished(boolean published) {
		this.published = published;
	}

	public boolean isUserPrintable() {
		return userPrintable;
	}

	public void setUserPrintable(boolean userPrintable) {
		this.userPrintable = userPrintable;
	}

	public List<Pdf> getPdfs() {
		return pdfs;
	}

	public void setPdfs(List<Pdf> pdfs) {
		this.pdfs = pdfs;
	}

	public List<Question> getQuestionsPage(int pageNumber) {
		List<Question> questionsPage = new ArrayList<Question>();
		for (Question question : questions) {
			if (question.getPageNumber() == pageNumber)
				questionsPage.add(question);
		}
		return questionsPage;
	}

	public void addQuestion(Question question) {
		question.setForm(this);
		questions.add(question);
	}

	public void removeQuestion(Question question) {
		questions.remove(question);
		if (question != null) {
			question.setForm(null);
		}
	}

	public void addPdf(Pdf pdf) {
		pdf.setForm(this);
		pdfs.add(pdf);
	}

	public void removePdf(Pdf pdf) {
		pdfs.remove(pdf);
		if (pdf != null) {
			pdf.setForm(null);
		}
	}


}
