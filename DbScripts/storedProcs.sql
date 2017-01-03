-- Stored Procedures..

DROP PROCEDURE IF EXISTS getAllContacts;
DELIMITER $$
-- Return = (fn, mi, ln, Contact Number, Email Id, contactId) 
CREATE PROCEDURE `getAllContacts`()
BEGIN
select fname, mname, lname, contactNumber, email, CONTACT.contactId
from CONTACT LEFT OUTER JOIN (CONTACTNUMBER, EMAIL)
		ON (CONTACTNUMBER.contactId = CONTACT.contactId and EMAIL.contactId = CONTACT.contactId);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS insertForNewContact;
DELIMITER $$
-- Parameters = (fn, MI, ln, gender, relation, phone, email, street, city, zip)
-- call insertForNewContact("lulufder","smthn","kulkarni","F","friend","3657654","sc@gmail.com","601 w", "Richardson", "75080");
CREATE PROCEDURE `insertForNewContact`(IN fn varchar(25), IN mi varchar(25), IN ln varchar(25), IN gen varchar(5),
 IN relation varchar(25), IN phone varchar(15), IN email varchar(30), IN street varchar(50), IN city varchar(20),
 IN zip varchar(10))
BEGIN
DECLARE genderId INT;
DECLARE contactId INT;

select genderTypeId into genderId from GENDERTYPE where gender = gen;
-- Insert On CONTACT TABLE
insert into CONTACT(fname, mname, lname, genderTypeId, relationType) 
values(fn, mi, ln, genderId, relation);
SELECT LAST_INSERT_ID() into contactId;
-- Insert for Contact Number On CONTACTNUMBER TABLE.
insert into CONTACTNUMBER(contactNumber, contactId) 
values(phone, contactId);
-- Insert for Email Id On EMAIL TABLE
insert into EMAIL(email, contactId) values(email, contactId);
-- Insert for Address On PHYSICALADDRESS TABLE.
insert  into PHYSICALADDRESS(street, city, zip, contactId) 
values(street, city, zip, contactId);

END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS getContactDetails;
DELIMITER $$
-- Parameters = (contactId)
CREATE PROCEDURE `getContactDetails`(IN contact_Id int)
BEGIN

select c.fname, c.mname, c.lname, g.gender, cn.contactNumber, e.email, p.street, p.city, p.zip, c.relationType
from CONTACT as c, CONTACTNUMBER as cn, EMAIL as e, PHYSICALADDRESS as p, GENDERTYPE as g
where c.contactId = cn.contactId and c.contactId = e.contactId and c.contactId = p.contactId and c.genderTypeId = g.genderTypeId and c.contactId = contact_Id;

END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS updateContact;
DELIMITER $$
-- Parameters = (fn, MI, ln, gender, relation, phone, email, street, city, zip, contactId)
CREATE PROCEDURE `updateContact`(IN fn varchar(25), IN mi varchar(25), IN ln varchar(25), IN gen varchar(5),
 IN relation varchar(25), IN phone varchar(15), IN email varchar(30), IN street varchar(50), IN city varchar(20),
 IN zip varchar(10), IN contact_Id INT)
BEGIN
DECLARE genderId INT;

-- UPDATE QUERY everything except gender
update CONTACT, CONTACTNUMBER, EMAIL, PHYSICALADDRESS
set CONTACT.fname = fn, CONTACT.mname = mi, CONTACT.lname = ln, CONTACT.relationType = relation,
	contactNumber.contactNumber = phone, EMAIL.email = email, PHYSICALADDRESS.street = street, PHYSICALADDRESS.city = city,
    PHYSICALADDRESS.zip = zip
where CONTACT.contactId = CONTACTNUMBER.contactId and CONTACT.contactId = EMAIL.contactId
 and CONTACT.contactId = PHYSICALADDRESS.contactId and CONTACT.contactId = contact_Id;
 
-- update gender separately
select genderTypeId into genderId from GENDERTYPE where gender = gen;
update CONTACT set genderTypeId = genderId where contactId = contact_Id;

END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteContact;
DELIMITER $$
-- Parameters = (contactId)
CREATE PROCEDURE `deleteContact`(IN contact_Id int)
BEGIN

delete from CONTACT where contactId = contact_id;

END$$
DELIMITER ;



