-- REMOVE DATA
-- DELETE FROM PERSON;
-- DELETE FROM CATEGORY;

-- REMOVE TABLE AND SEQUENCE
-- DROP TABLE CATEGORY;
-- DROP SEQUENCE SQ_CATEGORY;

-- REMOVE TABLE AND SEQUENCE
-- DROP TABLE PERSON;
-- DROP SEQUENCE SQ_PERSON;

ALTER SESSION SET CONTAINER=XEPDB1;

-- PERSON CREATION
CREATE TABLE APPUSER.PERSON (
	PERSON NUMBER,
	EMAIL VARCHAR2(100) UNIQUE NOT NULL,
	PASSWORD VARCHAR2(1000) NOT NULL,
	PERSON_TOKEN VARCHAR2(1000) NOT NULL,
	FIRST_NAME VARCHAR2(100) NOT NULL,
	LAST_NAME VARCHAR2(100) NOT NULL,
	ADD_DATE DATE DEFAULT SYSDATE,
	MOD_DATE DATE,
	PRIMARY KEY(PERSON)
);

-- PERSON SEQUENCE
CREATE SEQUENCE APPUSER.SQ_PERSON NOCACHE;

-- CATEGORY CREATION
CREATE TABLE APPUSER.CATEGORY(
	CATEGORY NUMBER,
	PERSON NUMBER NOT NULL,
	NAME VARCHAR2(100) NOT NULL,
	DESCRIPTION VARCHAR2(200) NOT NULL,
	ADD_DATE DATE DEFAULT SYSDATE,
	MOD_DATE DATE,
	PRIMARY KEY(CATEGORY),
	FOREIGN KEY(PERSON) REFERENCES APPUSER.PERSON(PERSON)
);

-- CATEGORY SEQUENCE
CREATE SEQUENCE APPUSER.SQ_CATEGORY NOCACHE;


-- ACCOUNT CREATION 
CREATE TABLE APPUSER.ACCOUNT(
    ACCOUNT_ID NUMBER,
    PERSON NUMBER NOT NULL,
    NAME VARCHAR2(100) NOT NULL,
    BANK_NAME VARCHAR2(200) NOT NULL,
    ACCOUNT_NUMBER NUMBER, 
    ACCOUNT_BALANCE NUMBER(20,6), 
    CURRENCY_ID VARCHAR2(3) NOT NULL, 
    ADD_DATE DATE DEFAULT SYSDATE,
    MOD_DATE DATE,
    PRIMARY KEY(ACCOUNT_ID),
    FOREIGN KEY(PERSON) REFERENCES APPUSER.PERSON(PERSON)
);


-- ACCOUNT SEQUENCE
CREATE SEQUENCE APPUSER.SQ_ACCOUNT NOCACHE;



-- TRANSACTION CREATION 
CREATE TABLE APPUSER.TRANSACTIONS(
    TXN_ID NUMBER NOT NULL, 
    DEBIT_ACCOUNT_ID NUMBER,
    CREDIT_ACCOUNT_ID NUMBER,
    PERSON NUMBER NOT NULL,
    DESCRIPTION VARCHAR2(100) NOT NULL,
    ACCOUNT_NUMBER NUMBER, 
    AMOUNT NUMBER(20,6), 
    DEBIT_CURRENCY NUMBER, 
    CREDIT_CURRENCY NUMBER, 
    ADD_DATE DATE DEFAULT SYSDATE,
    PRIMARY KEY(TXN_ID),
    FOREIGN KEY(PERSON) REFERENCES APPUSER.PERSON(PERSON),
    FOREIGN KEY(DEBIT_ACCOUNT_ID) REFERENCES APPUSER.ACCOUNT(ACCOUNT_ID),
    FOREIGN KEY(CREDIT_ACCOUNT_ID) REFERENCES APPUSER.ACCOUNT(ACCOUNT_ID)
);


-- TRANSACTION SEQUENCE
CREATE SEQUENCE APPUSER.SQ_TRANSACTIONS NOCACHE;

-- REMOVE TABLE AND SEQUENCE
-- DROP TABLE ACCOUNT;
-- DROP SEQUENCE SQ_ACCOUNT;

-- CREATE FUNCTION
CREATE OR REPLACE FUNCTION APPUSER.API_TOKEN(PSECRET VARCHAR2) RETURN VARCHAR2
IS
  	VRESULT VARCHAR2(4000);
BEGIN
	SELECT UTL_RAW.CAST_TO_VARCHAR2(UTL_I18N.STRING_TO_RAW(STANDARD_HASH(PSECRET, 'MD5'), 'AL32UTF8')) INTO VRESULT from dual;
	RETURN VRESULT;
END API_TOKEN;

/
