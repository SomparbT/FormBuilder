package formbuilder.model.questionform;

import java.io.Serializable;

import javax.persistence.DiscriminatorColumn;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import formbuilder.model.core.User;

@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@Table(name = "answers")
@DiscriminatorColumn(name = "answer_type")
public class Answer implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue
	protected int id;

	@ManyToOne
	protected Question question;

	@ManyToOne
	@JoinColumn(name = "user_id")
	protected User user;

	private boolean enabled;

	public Answer() {
		enabled = true;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}


	public Question getQuestion() {
		return question;
	}

	public void setQuestion(Question question) {
		this.question = question;
	}

	public User getUser() {
		return user;
	}

	public void setUserId(User user) {
		this.user = user;
	}

	public boolean isEnabled() {
		return enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	public void setUser(User user) {
		this.user = user;
	}


}
