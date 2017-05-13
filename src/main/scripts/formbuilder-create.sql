create sequence hibernate_sequence start 1 increment 1;

    create table answer_files (
        answer_id int4 not null,
        files varchar(255)
    );

    create table answers (
        answer_type varchar(31) not null,
        id int4 not null,
        enabled boolean not null,
        selections bytea,
        text varchar(255),
        question_id int4,
        user_id int4,
        primary key (id)
    );

    create table authorities (
        user_id int4 not null,
        role varchar(255)
    );

    create table files_upload (
        FILE_ID int8 not null,
        FILE_DATA bytea,
        FILE_NAME varchar(255),
        primary key (FILE_ID)
    );

    create table forms (
        id int4 not null,
        description varchar(255),
        enabled boolean not null,
        name varchar(255),
        notification_email varchar(255),
        published boolean not null,
        total_pages int4,
        primary key (id)
    );

    create table forms_users (
        forms_id int4 not null,
        users_id int4 not null,
        primary key (forms_id, users_id)
    );

    create table pdf_fields (
        id int4 not null,
        enabled boolean not null,
        fieldType varchar(255),
        name varchar(255),
        pdf_id int4,
        question_id int4,
        primary key (id)
    );

    create table pdfs (
        id int4 not null,
        enabled boolean not null,
        name varchar(255),
        primary key (id)
    );

    create table question_choices (
        question_id int4 not null,
        choice varchar(255)
    );

    create table questions (
        question_type varchar(31) not null,
        id int4 not null,
        description varchar(255),
        enabled boolean not null,
        page_number int4,
        question_number int4,
        input_type varchar(255),
        max varchar(255),
        min varchar(255),
        placeholder varchar(255),
        required boolean not null,
        rows varchar(255),
        size varchar(255),
        step varchar(255),
        type varchar(255),
        form_id int4,
        primary key (id)
    );

    create table users (
        id int4 not null,
        city varchar(255),
        email varchar(255) not null,
        enabled boolean not null,
        first_name varchar(255),
        last_name varchar(255),
        password varchar(255) not null,
        phoneNumber varchar(255),
        state varchar(255),
        street varchar(255),
        username varchar(255) not null,
        zip varchar(255),
        primary key (id)
    );

    alter table users 
        add constraint UK_6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table users 
        add constraint UK_r43af9ap4edm43mmtq01oddj6 unique (username);

    alter table answer_files 
        add constraint FK5g6hgn3rar9j281mttpamfv5r 
        foreign key (answer_id) 
        references answers;

    alter table answers 
        add constraint FK3erw1a3t0r78st8ty27x6v3g1 
        foreign key (question_id) 
        references questions;

    alter table answers 
        add constraint FK5bp3d5loftq2vjn683ephn75a 
        foreign key (user_id) 
        references users;

    alter table authorities 
        add constraint FKk91upmbueyim93v469wj7b2qh 
        foreign key (user_id) 
        references users;

    alter table forms_users 
        add constraint FKhp0dk6l6s1p5c2mcew1md2yph 
        foreign key (users_id) 
        references users;

    alter table forms_users 
        add constraint FK447bluo61y51t7nxqdfl5x80x 
        foreign key (forms_id) 
        references forms;

    alter table pdf_fields 
        add constraint FKlsgntpf4rsms7ibkw5e1qsmpd 
        foreign key (pdf_id) 
        references pdfs;

    alter table pdf_fields 
        add constraint FKk13jl0ulf5u1otpif9gsfsrlv 
        foreign key (question_id) 
        references questions;

    alter table question_choices 
        add constraint FK77biojwg2xd8kc8a2odnx3ld4 
        foreign key (question_id) 
        references questions;

    alter table questions 
        add constraint FKni5pym5qivhqac03taibcw4dk 
        foreign key (form_id) 
        references forms;

insert into users (id, username, password, last_name, first_name, email, enabled) values (1000, 'admin', 'abcd', 'System', 'Administrator', 'formbuilderadmin@localhost.localdomain', TRUE);
insert into authorities (user_id, role) values (1000, 'ROLE_ADMIN');
insert into users (id, username, password, last_name, first_name, email, enabled) values (1001, 'staff', 'abcd', 'System', 'Staff', 'formbuilderstaff@localhost.localdomain', TRUE);
insert into authorities (user_id, role) values (1001, 'ROLE_STAFF');
insert into users (id, username, password, last_name, first_name, email, enabled) values (1002, 'user1', 'abcd', 'System', 'User', 'formbuilderuser1@localhost.localdomain', TRUE);
insert into authorities (user_id, role) values (1002, 'ROLE_USER');
insert into users (id, username, password, last_name, first_name, email, enabled) values (1003, 'user2', 'abcd', 'System', 'User', 'formbuilderuser2@localhost.localdomain', TRUE);
insert into authorities (user_id, role) values (1003, 'ROLE_USER');
