/*Creating the Schema and the tables*/
Drop Schema if Exists assignment;
Create Schema assignment;
Use assignment;

Set Global local_infile = true;
Set SQL_SAFE_UPDATES = 0;

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
Primary Key(PT_UNIFIED_KEY),
Constraint Organization_ID Foreign Key (ORG_KEY) References ORGANIZATIONS(ORG_KEY)
);

Create Table ACCOUNTS(
ACC_KEY int NOT NULL,
ACCTP_KEY int NOT NULL,
PROD_KEY int NOT NULL,
ORG_KEY int NOT NULL,
PT_UNIFIED_KEY bigint NOT NULL,
ACCH_OPEN_DATE date NOT NULL,
ACCH_CLOSE_DATE date NOT NULL,
Primary Key(ACC_KEY),
Constraint Account_Type Foreign Key (ACCTP_KEY) References ACCOUNT_TYPES(ACCTP_KEY),
Constraint Product_ID Foreign Key (PROD_KEY) References PRODUCTS(PROD_KEY),
Constraint Organization_ID2 Foreign Key (ORG_KEY) References ORGANIZATIONS(ORG_KEY),
Constraint Holder_ID Foreign Key (PT_UNIFIED_KEY) References PARTIES(PT_UNIFIED_KEY)
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
Primary Key(ACCTRN_KEY),
Constraint Account_ID Foreign Key (ACC_KEY) References ACCOUNTS(ACC_KEY),
Constraint Account_Type2 Foreign Key (ACCTP_KEY) References ACCOUNT_TYPES(ACCTP_KEY),
Constraint Transaction_Type Foreign Key (ACTRNTP_KEY) References ACCOUNT_TRANSACT_TYPES(ACTRNTP_KEY),
Constraint Secondary_Account_ID Foreign Key (ACC_KEY) References ACCOUNTS(ACC_KEY),
Constraint Secondary_Account_Type Foreign Key (ACCTP_KEY) References ACCOUNT_TYPES(ACCTP_KEY)
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
Create Table New_Transactions like ACCOUNT_TRANSACTIONS;

Create Table DUMMY(
DUMMY varchar(100) NOT NULL);

Insert Into DUMMY Values("DUMMY");
--
/*QUESTIONS*/
--
/*Select every cash transactions*/

Drop View if Exists Cash_Transactions;

Create View Cash_Transactions as
Select * 
From account_transactions
Where ACCTRN_CASH_FLAG = 'Y';

/*Select closed accounts*/

Drop View if Exists Closed_accounts;

Create View Closed_accounts as
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
Inner Join PARTIES t2
ON t1.PT_UNIFIED_KEY = t2.PT_UNIFIED_KEY
Where t2.PTTP_UNIFIED_ID = 'P';


/*Select most used City and the number of times it is used*/

Drop View if Exists Most_Used_City;

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

Drop Procedure if Exists Create_Live_Accounts_INFO;

DELIMITER //

Create Procedure Create_Live_Accounts_INFO()
BEGIN

Drop Table if Exists LIVE_ACCOUNTS_INFO;

Create Table LIVE_ACCOUNTS_INFO as
Select
t1.ACC_KEY as 'Account ID',
t1.ACCH_OPEN_DATE as 'Account Opening Date',
datediff(CurDate(), t1.ACCH_OPEN_DATE) as 'Account Age (Days)',
t2.ACCTP_DESC as 'Account Description',
t3.CITY,
t3.ZIP,
t4.PTTP_UNIFIED_ID as 'Entity Type (Legal or Individual)'
From
ACCOUNTS t1
Inner Join ACCOUNT_TYPES t2 Using (ACCTP_KEY)
Inner Join ORGANIZATIONS t3 Using (ORG_KEY)
Inner Join PARTIES t4 Using (PT_UNIFIED_KEY)
Where t1.ACCH_CLOSE_DATE = '3000-01-01'
Order By 'Account Age (Days)';
End //
DELIMITER;

/*Return transactions with value minimum the amount that was given (in CZK)*/

Drop Procedure if Exists Transaction_Amount;

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
Inner Join ACCOUNTS t2 Using (ACC_KEY)
Inner Join PARTIES t3 Using (PT_UNIFIED_KEY)
Where t1.ACCTRN_AMOUNT_CZK > ABS(Amount) OR t1.ACCTRN_AMOUNT_CZK < -ABS(Amount);

End //
DELIMITER ;

/*Procedure that closes a selected account and re-creates Live_Account_INFO*/

Drop Procedure if Exists Account_Close;

DELIMITER //

Create Procedure Account_Close(IN ID INT)
Begin

Update ACCOUNTS
Set ACCH_CLOSE_DATE = current_date()
Where ACC_KEY = ID;

Call Create_Live_Accounts_INFO();

End //

DELIMITER ;

/*Events*/

DELIMITER //

Create Event Delete_Recent_Transactions
On Schedule Every 1 Hour
Starts current_timestamp
Ends Current_Timestamp + Interval 24 HOUR
DO
	BEGIN
		Truncate New_Transactions;
	END//
DELIMITER ;

/*Trigger*/
/*Update Accounts INFO after Insert of new account*/

Drop Trigger if Exists after_accounts_insert;

DELIMITER //

Create Trigger after_accounts_insert
After Insert On ACCOUNTS For Each Row
Begin

	Update DUMMY Set DUMMY = CONCAT('New Account ID: ', NEW.ACC_KEY);

	Insert Into LIVE_ACCOUNTS_INFO
	Select
	t1.ACC_KEY as 'Account ID',
	t1.ACCH_OPEN_DATE as 'Account Opening Date',
	datediff(CurDate(), t1.ACCH_OPEN_DATE) as 'Account Age (Days)',
	t2.ACCTP_DESC as 'Account Description',
	t3.CITY,
	t3.ZIP,
	t4.PTTP_UNIFIED_ID as 'Entity Type (Legal or Individual)'
	From
	ACCOUNTS t1
	Inner Join ACCOUNT_TYPES t2 Using (ACCTP_KEY)
	Inner Join ORGANIZATIONS t3 Using (ORG_KEY)
	Inner Join PARTIES t4 Using (PT_UNIFIED_KEY)
	Where t1.ACCH_CLOSE_DATE = '3000-01-01' AND ACC_KEY = NEW.ACC_KEY;
    
End //

DELIMITER ;

Drop Trigger if Exists after_transaction_insert;

DELIMITER //

Create Trigger after_transaction_insert
After Insert On NEW_TRANSACTIONS For Each Row
Begin

	Update DUMMY Set DUMMY = CONCAT('New Transaction ID: ', NEW.ACCTRN_KEY);
    
    Insert Into ACCOUNT_TRANSACTIONS
    SELECT *
    From NEW_TRANSACTIONS
    Where ACCTRN_KEY = NEW.ACCTRN_KEY;

End //