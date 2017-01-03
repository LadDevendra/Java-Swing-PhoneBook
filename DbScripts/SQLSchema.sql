

DROP DATABASE IF EXISTS ContactList;
CREATE DATABASE ContactList;

use ContactList;

DROP TABLE IF EXISTS GENDERTYPE;
CREATE TABLE GENDERTYPE (
	genderTypeId	int auto_increment,
    gender			varchar(25) not null,
    CONSTRAINT pk_gendertype primary key (genderTypeId)
);

DROP TABLE IF EXISTS CONTACT;
CREATE TABLE CONTACT (
  contactId		int auto_increment,
  fname			varchar(25) not null,
  mname			varchar(25),
  lname			varchar(25),
  genderTypeId	int,
  dateOfBirth	datetime,
  CONSTRAINT pk_contact primary key (contactId),
  CONSTRAINT fk_contact_gendertype foreign key (genderTypeId) references GENDERTYPE(genderTypeId)
);
alter table CONTACT add column relationType varchar(25);

DROP TABLE IF EXISTS EMAIL;
CREATE TABLE EMAIL (
	-- emailId		int auto_increment,
    email		varchar(25) not null,
    contactId	int,
    CONSTRAINT pk_email primary key (email, contactId),
    CONSTRAINT fk_email_contact foreign key (contactId) references CONTACT(contactId)
);

alter table EMAIL drop foreign key fk_email_contact;

alter table EMAIL
add constraint fk_email_contact
	foreign key (contactId) references CONTACT(contactId) ON DELETE CASCADE;


DROP TABLE IF EXISTS CONTACTNUMBER;
CREATE TABLE CONTACTNUMBER (
	-- contactNumberId		int auto_increment,
    contactNumber		varchar(20),
    countryCode		varchar(25),
    extension		varchar(25),
    contactId	int,
    CONSTRAINT pk_contactNumber primary key (contactNumber, contactId),
    CONSTRAINT fk_contactNumber_contact foreign key (contactId) references CONTACT(contactId)
);

alter table CONTACTNUMBER drop foreign key fk_contactNumber_contact;

alter table CONTACTNUMBER
add constraint fk_contactNumber_contact
	foreign key (contactId) references CONTACT(contactId) ON DELETE CASCADE;
    

DROP TABLE IF EXISTS PHYSICALADDRESS;
CREATE TABLE PHYSICALADDRESS (
	physicalAddressId	int auto_increment,
    flatNumber			varchar(10),
    addressLine1		varchar(25),
    addressLine2		varchar(25),
    street				varchar(25),
    city				varchar(25),
    zip					varchar(15),
    contactId			int,
    CONSTRAINT pk_physicalAddress primary key (physicalAddressId, contactId),
    CONSTRAINT fk_physicalAddress_contact foreign key (contactId) references CONTACT(contactId)
);

alter table PHYSICALADDRESS drop foreign key fk_physicalAddress_contact;

alter table PHYSICALADDRESS
add constraint fk_physicalAddress_contact
	foreign key (contactId) references CONTACT(contactId) ON DELETE CASCADE;


DROP TABLE IF EXISTS FAMILY;
CREATE TABLE FAMILY (
	familyId			int auto_increment,
    familyHead			varchar(25),
    contactId 			int,
	CONSTRAINT pk_family primary key (familyId),
    CONSTRAINT fk_family_contactId foreign key (contactId) references CONTACT(contactId)
);

DROP TABLE IF EXISTS CONTACTMEDIUMTYPE;
CREATE TABLE CONTACTMEDIUMTYPE (
	contactMediumTypeId	int auto_increment,
    contactMediumType			varchar(25) not null,
    CONSTRAINT pk_contactMediumType primary key (contactMediumTypeId)
);

DROP TABLE IF EXISTS COMMUNICATIONLOG;
CREATE TABLE COMMUNICATIONLOG (
	communicationLogId		int auto_increment,
    contactMediumTypeId		int,
    purpose					varchar(30),
    outcome					varchar(30),
    contactId				int,
    CONSTRAINT pk_communicationLog primary key (communicationLogId),
    CONSTRAINT fk_communicationLog_contactMediumType foreign key (contactMediumTypeId) references CONTACTMEDIUMTYPE(contactMediumTypeId)    
);
    
DROP TABLE IF EXISTS TODO;
CREATE TABLE TODO (
	todoId				int auto_increment,
    todo				varchar(30) not null,
    dateAndTime			datetime,
    venue				varchar(50),
    contactId			int,
    communicationLogId	int,
    CONSTRAINT pk_todo primary key (todoId),
    CONSTRAINT fk_todo_communicationLog foreign key (communicationLogId) references COMMUNICATIONLOG(communicationLogId),
    CONSTRAINT fk_todo_contact foreign key (contactId) references CONTACT(contactId)
);

DROP TABLE IF EXISTS JOBTITLE;
CREATE TABLE JOBTITLE (
	jobTitleId			int,
    jobTitle			varchar(30),
    CONSTRAINT pk_jobTitle primary key (jobTitleId)
);

DROP TABLE IF EXISTS COMPANY;
CREATE TABLE COMPANY (
	companyId			int,
    companyName			varchar(30),
    CONSTRAINT pk_company primary key (companyId)
);

DROP TABLE IF EXISTS PROFESSION;
CREATE TABLE PROFESSION (
	professionId		int auto_increment,
    jobTitleId			int,
    companyId			int,
    jobDescription		varchar(50),
    CONSTRAINT pk_profession primary key (professionId),
    CONSTRAINT fk_profession_jobTitle foreign key (jobTitleId) references JOBTITLE(jobTitleId),
    CONSTRAINT fk_profession_company foreign key (companyId) references COMPANY(companyId)
);

DELIMITER $$
CREATE TRIGGER check_birth_date BEFORE INSERT
ON CONTACT
FOR EACH ROW
BEGIN
	IF(new.dateOfBirth < date '1870-01-01' or new.dateOfBirth > CURDATE() ) THEN 
	signal sqlstate '45000'
		set message_text = 'My Error Message';
	END IF; 
END$$

CREATE TRIGGER check_email BEFORE INSERT
ON EMAIL
FOR EACH ROW
BEGIN
	IF(new.email NOT LIKE '%_@%_.__%') THEN
    signal sqlstate '45000'
		SET MESSAGE_TEXT = 'email column is not valid';
    END IF; 
END$$    

CREATE UNIQUE INDEX name_index
ON CONTACT ( fname, lname);

