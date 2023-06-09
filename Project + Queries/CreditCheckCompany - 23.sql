CREATE SCHEMA CreditCheckCompany;

USE CreditCheckCompany;

CREATE TABLE IF NOT EXISTS SalesDocument (
	DOCUMENT_id INT NOT NULL,
    Sformat VARCHAR(10),
    CRELIM_id INT NOT NULL UNIQUE,
    BIL_id INT NOT NULL UNIQUE,
    DEL_id INT NOT NULL UNIQUE,
    GRO_id INT NOT NULL UNIQUE,
    BLO_id INT NOT NULL UNIQUE,
    PRIMARY KEY (DOCUMENT_id)
    );

CREATE TABLE IF NOT EXISTS CreditLimitCheckParameter (
	PARAMETER_id INT NOT NULL,
	Pchecktype VARCHAR(50),
	PRIMARY KEY (PARAMETER_id),
	FOREIGN KEY (PARAMETER_id) REFERENCES SalesDocument(CRELIM_id)
);

CREATE TABLE IF NOT EXISTS Billing (
	BILLING_id INT NOT NULL,
	Btypes VARCHAR(50),
	PRIMARY KEY (BILLING_id),
	FOREIGN KEY (BILLING_id) REFERENCES SalesDocument(BIL_id)
);

CREATE TABLE IF NOT EXISTS Delivery (
	DELIVERY_id INT NOT NULL,
	Dtypes VARCHAR(50),
	PRIMARY KEY (DELIVERY_id),
	FOREIGN KEY (DELIVERY_id) REFERENCES SalesDocument(DEL_id)
);

CREATE TABLE IF NOT EXISTS CreditGroup (
	GROUP_id INT NOT NULL,
	Gworkgrade CHAR(1),
	Gexpertise VARCHAR(50),
	EMssn INT,
	PRIMARY KEY (GROUP_id),
	FOREIGN KEY (GROUP_id) REFERENCES SalesDocument(GRO_id),
	FOREIGN KEY (EMssn) REFERENCES Employee(Essn)
);

CREATE TABLE IF NOT EXISTS EmployeeGManager (
	Essn INT NOT NULL,
	Eaddress VARCHAR(50),
	Ename VARCHAR(40),
	Esurname VARCHAR(30),
	PRIMARY KEY(Essn)
);


CREATE TABLE IF NOT EXISTS BlockReason (
	Rblocknumber INT NOT NULL,
	Rdateissued DATE,
	Rmotivation VARCHAR(30),
	PRIMARY KEY (Rblocknumber),
	FOREIGN KEY (Rblocknumber) REFERENCES SalesDocument(BLO_id)
);

CREATE TABLE IF NOT EXISTS SalesOrder (
	ORDER_id INT NOT NULL,
	Odateissued DATE,
	Oduedate DATE,
	PRIMARY KEY (ORDER_id),
	FOREIGN KEY (ORDER_id) REFERENCES SalesDocument(DOCUMENT_id)
);

CREATE TABLE IF NOT EXISTS Complaint (
	COMPLAINT_id INT NOT NULL,
    Ctcode VARCHAR(6),
    PRIMARY KEY (COMPLAINT_id),
    FOREIGN KEY (COMPLAINT_id) REFERENCES SalesDocument(DOCUMENT_id)
    );

