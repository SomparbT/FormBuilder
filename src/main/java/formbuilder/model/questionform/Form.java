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

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;

import formbuilder.model.core.User;

@Entity
@Table(name = "forms")
@JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
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
	@JsonIgnoreProperties("form")
	private List<Question> questions;

	@ManyToMany
	@JsonIgnoreProperties("forms")
	private Set<User> users;

	@Column(name = "notification_email")
	private String notificationEmail;

	@Column(name = "total_pages")
	private int totalPages;

	public Form() {
		enabled = true;
		questions = new ArrayList<Question>();
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

	public boolean isPublished() {
		return published;
	}

	public void setPublished(boolean published) {
		this.published = published;
	}
}
