package formbuilder.util;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

import javax.persistence.Persistence;

import org.hibernate.engine.jdbc.internal.DDLFormatterImpl;
import org.hibernate.engine.jdbc.internal.Formatter;

public class SchemaGeneration {

	public static void main(String args[]) throws IOException {
		// Write the generated schema to a string
		StringWriter stringWriter = new StringWriter();
		Map<String, Object> properties = new HashMap<>();

		properties.put("javax.persistence.schema-generation.scripts.action", "create");

		properties.put("javax.persistence.schema-generation.scripts.create-target", stringWriter);

		Persistence.generateSchema("formbuilder", properties);

		// If there is a command line argument, consider it the output file name
		BufferedWriter out = null;
		if (args.length > 0)
			out = new BufferedWriter(new FileWriter(args[0]));

		// Use Hibernate's SQL formatter to format each statement
		Formatter formatter = new DDLFormatterImpl();
		Scanner scanner = new Scanner(stringWriter.toString());
		while (scanner.hasNextLine()) {
			String line = formatter.format(scanner.nextLine() + ";");
			System.out.println(line);
			if (out != null) {
				out.write(line);
				out.newLine();
			}
		}

		System.out.println();

		System.out.println("insert into users (id, username, password, last_name, first_name, email, enabled) values "
				+ "(1000, 'admin', 'abcd', 'System', 'Administrator', 'formbuilderadmin@localhost.localdomain', TRUE);");

		System.out.println("insert into authorities (user_id, role) values (1000, 'ROLE_ADMIN');");

		System.out.println("insert into users (id, username, password, last_name, first_name, email, enabled) values "
				+ "(1001, 'staff', 'abcd', 'System', 'Staff', 'formbuilderstaff@localhost.localdomain', TRUE);");

		System.out.println("insert into authorities (user_id, role) values (1001, 'ROLE_STAFF');");

		System.out.println("insert into users (id, username, password, last_name, first_name, email, enabled) values "
				+ "(1002, 'user1', 'abcd', 'System', 'User', 'formbuilderuser1@localhost.localdomain', TRUE);");

		System.out.println("insert into authorities (user_id, role) values (1002, 'ROLE_USER');");

		System.out.println("insert into users (id, username, password, last_name, first_name, email, enabled) values "
				+ "(1003, 'user2', 'abcd', 'System', 'User', 'formbuilderuser2@localhost.localdomain', TRUE);");

		System.out.println("insert into authorities (user_id, role) values (1003, 'ROLE_USER');");

		out.newLine();

		out.write("insert into users (id, username, password, last_name, first_name, email, enabled) values "
				+ "(1000, 'admin', 'abcd', 'System', 'Administrator', 'formbuilderadmin@localhost.localdomain', TRUE);");

		out.newLine();

		out.write("insert into authorities (user_id, role) values (1000, 'ROLE_ADMIN');");

		out.newLine();

		out.write("insert into users (id, username, password, last_name, first_name, email, enabled) values "
				+ "(1001, 'staff', 'abcd', 'System', 'Staff', 'formbuilderstaff@localhost.localdomain', TRUE);");

		out.newLine();

		out.write("insert into authorities (user_id, role) values (1001, 'ROLE_STAFF');");

		out.newLine();

		out.write("insert into users (id, username, password, last_name, first_name, email, enabled) values "
				+ "(1002, 'user1', 'abcd', 'System', 'User', 'formbuilderuser1@localhost.localdomain', TRUE);");

		out.newLine();

		out.write("insert into authorities (user_id, role) values (1002, 'ROLE_USER');");

		out.newLine();

		out.write("insert into users (id, username, password, last_name, first_name, email, enabled) values "
				+ "(1003, 'user2', 'abcd', 'System', 'User', 'formbuilderuser2@localhost.localdomain', TRUE);");

		out.newLine();

		out.write("insert into authorities (user_id, role) values (1003, 'ROLE_USER');");

		out.newLine();

		scanner.close();
		if (out != null)
			out.close();

		System.exit(0);
	}

}
