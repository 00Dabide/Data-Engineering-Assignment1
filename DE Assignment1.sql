/*Creating the Schema and the tables*/
Drop Schema if Exists assignment;
Create Schema assignment;
Use assignment;

SET GLOBAL local_infile = true;

Drop Table if Exists
ACCOUNT_TRANSACTIONS,
ACCOUNT_TRANSACT_TYPES,
ACCOUNT_TYPES,
ACCOUNTS,
ORGANIZATIONS,
PARTIES,
PRODUCTS;

Create Table ACCOUNT_TRANSACT_TYPES(
ACTRNTP_KEY int NOT NULL,
ACTRNTP_DESC varchar(255) NOT NULL,
Primary Key(ACTRNTP_KEY)
);

Create Table ACCOUNT_TYPES(
ACCTP_KEY int NOT NULL,
ACCTP_DESC varchar(255),
Primary Key(ACCTP_KEY)
);

Create Table ORGANIZATIONS(
ORG_KEY int NOT NULL,
ORGH_UNIFIED_ID varchar(255) NOT NULL,
CITY varchar(255) NOT NULL,
ZIP int NOT NULL,
Primary Key(ORG_KEY)
);

Create Table PRODUCTS(
PROD_KEY int NOT NULL,
PROD_AGENDA_CODE varchar(255) NOT NULL,
PROD_AGENDA_NAME varchar(255) NOT NULL,
Primary Key(PROD_KEY)
);

Create Table PARTIES(
PT_UNIFIED_KEY bigint NOT NULL,
ORG_KEY int NOT NULL,
PTH_BIRTH_DATE varchar(255) NOT NULL,
PTH_CLIENT_FROM_DATE varchar(255) NOT NULL,
PTH_CLIENT_FROM_DATE_ALT varchar(255) NOT NULL,
PTTP_UNIFIED_ID varchar(255) NOT NULL,
PSGEN_UNIFIED_ID varchar(255) NOT NULL,
Primary Key(PT_UNIFIED_KEY)
);

Create Table ACCOUNTS(
ACC_KEY int NOT NULL,
ACCTP_KEY int NOT NULL,
PROD_KEY int NOT NULL,
ORG_KEY int NOT NULL,
PT_UNIFIED_KEY bigint NOT NULL,
ACCH_OPEN_DATE date NOT NULL,
ACCH_CLOSE_DATE date NOT NULL,
Primary Key(ACC_KEY)
);

Create Table ACCOUNT_TRANSACTIONS(
ACCTRN_KEY bigint NOT NULL,
ACC_KEY int NOT NULL,
ACCTP_KEY int NOT NULL,
ACTRNTP_KEY int NOT NULL,
ACCTRN_ACCOUNTING_DATE Date NOT NULL,
ACCTRN_AMOUNT_CZK int NOT NULL,
ACCTRN_AMOUNT_FX int NOT NULL,
CURR_ISO_CODE varchar(255) NOT NULL,
ACCTRN_CRDR_FLAG varchar(255) NOT NULL,
ACCTRN_CASH_FLAG varchar(255) NOT NULL,
ACCTRN_INTEREST_FLAG varchar(255) NOT NULL,
ACCTRN_TAX_FLAG varchar(255) NOT NULL,
ACCTRN_FEE_FLAG varchar(255) NOT NULL,
ACC_OTHER_ACCOUNT_KEY int NOT NULL,
ACCTP_OTHER_ACCOUNT_KEY int NOT NULL,
Primary Key(ACCTRN_KEY)
);

/*Loading data to the tables*/

LOAD DATA LOCAL INFILE 'D:/GITHUB/SQL Practice/Data-Engineering-Assignment1/Data/ACCOUNT_TRANSACT_TYPES.csv' 
INTO TABLE ACCOUNT_TRANSACT_TYPES 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n' 
IGNORE 1 LINES
(ACTRNTP_KEY,
ACTRNTP_DESC);

LOAD DATA LOCAL INFILE 'D:/GITHUB/SQL Practice/Data-Engineering-Assignment1/Data/ACCOUNT_TYPES.csv' 
INTO TABLE ACCOUNT_TYPES 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES
(ACCTP_KEY,
ACCTP_DESC);

LOAD DATA LOCAL INFILE 'D:/GITHUB/SQL Practice/Data-Engineering-Assignment1/Data/ORGANIZATIONS.csv' 
INTO TABLE ORGANIZATIONS
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES
(ORG_KEY,
ORGH_UNIFIED_ID,
CITY,
ZIP);

LOAD DATA LOCAL INFILE 'D:/GITHUB/SQL Practice/Data-Engineering-Assignment1/Data/PRODUCTS.csv' 
INTO TABLE PRODUCTS 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES
(PROD_KEY,
PROD_AGENDA_CODE,
PROD_AGENDA_NAME);

LOAD DATA LOCAL INFILE 'D:/GITHUB/SQL Practice/Data-Engineering-Assignment1/Data/PARTIES.csv' 
INTO TABLE PARTIES 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES
(PT_UNIFIED_KEY,
ORG_KEY,
PTH_BIRTH_DATE,
PTH_CLIENT_FROM_DATE,
PTH_CLIENT_FROM_DATE_ALT,
PTTP_UNIFIED_ID,
PSGEN_UNIFIED_ID);

LOAD DATA LOCAL INFILE 'D:/GITHUB/SQL Practice/Data-Engineering-Assignment1/Data/ACCOUNTS.csv' 
INTO TABLE ACCOUNTS 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES
(ACC_KEY,
ACCTP_KEY,
PROD_KEY,
ORG_KEY,
PT_UNIFIED_KEY,
ACCH_OPEN_DATE,
ACCH_CLOSE_DATE);

LOAD DATA LOCAL INFILE 'D:/GITHUB/SQL Practice/Data-Engineering-Assignment1/Data/ACCOUNT_TRANSACTIONS.csv' 
INTO TABLE ACCOUNT_TRANSACTIONS 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES
(ACCTRN_KEY,
ACC_KEY,
ACCTP_KEY,
ACTRNTP_KEY,
ACCTRN_ACCOUNTING_DATE,
ACCTRN_AMOUNT_CZK,
ACCTRN_AMOUNT_FX,
CURR_ISO_CODE,
ACCTRN_CRDR_FLAG,
ACCTRN_CASH_FLAG,
ACCTRN_INTEREST_FLAG,
ACCTRN_TAX_FLAG,
ACCTRN_FEE_FLAG,
ACC_OTHER_ACCOUNT_KEY,
ACCTP_OTHER_ACCOUNT_KEY);

/*Analytical Data Store*/
/*Creating a table for the new transactions*/
CREATE TABLE new_transactions LIKE ACCOUNT_TRANSACTIONS;

--
/*QUESTIONS*/
--
/*Select every cash transactions*/
Drop view if exists Cash_Transactions;

Create view Cash_Transactions as
Select * 
from account_transactions
Where ACCTRN_CASH_FLAG = 'Y';

/*Select closed accounts*/
Drop view if exists Closed_accounts;

Create view Closed_accounts as
Select * 
From accounts
Where ACCH_CLOSE_DATE <> '3000-01-01';

/* Select account open dates of legal entities */
Drop View if Exists Legal_Entity_AccOP_Date;

Create View Legal_Entity_AccOP_Date as
Select 
t1.ACC_KEY as 'Account ID',
t2.PT_UNIFIED_KEY as 'Holder ID', 
t2.PTTP_UNIFIED_ID as 'Entity Type',
t1.ACCH_OPEN_DATE as 'Account Opening Date'
From ACCOUNTS t1
INNER JOIN PARTIES t2
ON t1.PT_UNIFIED_KEY = t2.PT_UNIFIED_KEY
Where t2.PTTP_UNIFIED_ID = 'P';


/*Select most used City and the number of times it is used*/
Drop View if exists Most_Used_City;

Create View Most_Used_City as
Select t2.CITY, Count(t2.CITY) as 'COUNT'
From PARTIES t1
Inner Join ORGANIZATIONS t2
ON t1.ORG_KEY = t2.ORG_KEY
Group By t2.CITY
Order By Count(t2.CITY) desc
Limit 1;

/*Procedures*/
/*Creates a new table, which shows information about the live (not closed) accounts*/
Drop Procedure if Exists Create_Accounts_INFO;

DELIMITER //

Create Procedure Create_Accounts_INFO()
BEGIN

Drop Table if Exists ACCOUNTS_INFO;

CREATE TABLE ACCOUNTS_INFO AS
Select
t1.ACC_KEY AS 'Account ID',
t1.ACCH_OPEN_DATE AS 'Account Opening Date',
t2.ACCTP_DESC AS 'Account Description',
t3.CITY,
t3.ZIP,
t4.PTTP_UNIFIED_ID AS 'Entity Type (Legal or Individual)'
From
ACCOUNTS t1
Inner Join ACCOUNT_TYPES t2 USING (ACCTP_KEY)
Inner Join ORGANIZATIONS t3 USING (ORG_KEY)
Inner Join PARTIES t4 USING (PT_UNIFIED_KEY)
Where t1.ACCH_CLOSE_DATE = '3000-01-01';

END //
DELIMITER;

/*Return transactions with value minimum the amount that was given (in CZK)*/
Drop Procedure if exists Transaction_Amount;

DELIMITER //

Create Procedure Transaction_Amount(IN Amount INT)
Begin

Select
t1.ACCTRN_AMOUNT_CZK as 'Local Amount (CZK)',
t1.ACCTRN_AMOUNT_FX as 'Foreign Amount',
t1.ACCTRN_KEY as 'Transaction ID',
t1.ACCTRN_ACCOUNTING_DATE as 'Transaction Date',
t3.PT_UNIFIED_KEY as 'Holder ID',
t3.PSGEN_UNIFIED_ID as 'Holder Sex'
From ACCOUNT_TRANSACTIONS t1
Inner Join ACCOUNTS t2 USING (ACC_KEY)
Inner Join PARTIES t3 USING (PT_UNIFIED_KEY)
Where t1.ACCTRN_AMOUNT_CZK > ABS(Amount) OR t1.ACCTRN_AMOUNT_CZK < -ABS(Amount);

END //
DELIMITER ;

/*Event*/

DELIMITER //

CREATE EVENT Create_Live_Accounts
ON SCHEDULE EVERY 1 MINUTE
STARTS CURRENT_TIMESTAMP
ENDS CURRENT_TIMESTAMP + INTERVAL 1 HOUR
DO
	BEGIN
		Drop Table if exists ACCOUNTS_INFO;
    		CALL Create_Accounts_INFO();
	END//
DELIMITER ;
