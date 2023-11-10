# **DE Assignment 1**
## **Fitness of the input dataset to the purpose**
The selected dataset is an artificial data from a Czech bank. As the purpose is to have a dataset, in which simple or even complex work can be done, a bank dataset should fulfill this.
Link to the selected dataset:
_https://relational.fit.cvut.cz/dataset/CS_
## **Complexity of the input data set**
The data set uses 7 tables to represent the complexity of a bank’s information about accounts, transaction etc. and the relationships between them.
The following data tables are available for this assignment:

Account Transactions:

![image](https://github.com/00Dabide/Data-Engineering-Assignment1/assets/144621576/3f3b5420-b453-4fe0-9443-8d36602d67aa)


Account Transaction Types:

![image](https://github.com/00Dabide/Data-Engineering-Assignment1/assets/144621576/a08eabad-8b72-4cce-afe2-2fa060819285)

Accounts:

![image](https://github.com/00Dabide/Data-Engineering-Assignment1/assets/144621576/2856b422-edd6-451f-b17a-392d41ef96f0)

Account Types:

![image](https://github.com/00Dabide/Data-Engineering-Assignment1/assets/144621576/41a60314-c596-43f7-adb9-0b39a3ead6c7)

Parties:

![image](https://github.com/00Dabide/Data-Engineering-Assignment1/assets/144621576/dde2f1c0-a72a-45a7-b65b-334139665192)

Organizations:

![image](https://github.com/00Dabide/Data-Engineering-Assignment1/assets/144621576/07891e35-103d-4c0f-8cce-e2b6992a4419)

Products:

![image](https://github.com/00Dabide/Data-Engineering-Assignment1/assets/144621576/51bd4cb2-71fd-4dca-8d23-2dd0c487fac7)

Entity-Relationships Diagram:

![image](https://github.com/00Dabide/Data-Engineering-Assignment1/assets/144621576/277d191e-851a-42c9-b15c-c6aa7abb4e3d)

 
## **Execution of the operational data layer**
The tables have been made with the columns exactly alike as it could be seen on the previous pictures.

The loading of the data has been made by the
LOAD DATA LOCAL INFILE “PATH/FILE_NAME.csv”
command, after setting local_infile to True, at the beginning of the script.

## **Analytics plan**
During the assignment, I will use most of the knowledge we learnt during class. Mainly I want to focus on making programs and asking questions about the Accounts Transactions and the Accounts table, with the help of the remaining ones.

Some example questions:
- In which city most of the accounts are being held?
- Which accounts have been closed already?

## **Execution of the analytical data layer**

### **Views:**
_Cash_Transactions:_

Shows every transaction, which is a cash transaction.

_Closed_Accounts:_

Shows every account, that has been closed (aka close date is not 3000-01-01).

_Legal_Entity_AccOP_Date:_

Shows the opening date of those accounts, where the owner is a legal entity.
 
_Most_Used_City:_

Shows that City, where most of the accounts are being held.
### **Procedures:**
_Transaction_Amount:_

Returns those transactions, where the amount is at least as much, as the given number. (Because these are transactions, the + and – signs are only the direction of the transaction, thus we speak in absolutes.)

_Create_Live_Accounts_INFO:_

Creates a new table, which shows information about live the accounts, like the holder’s ID, Account type, location etc.

_Account_Close:_

Closes the that account, which’s ID was given, and re-creates the Live_Accounts_INFO, because the closed account is no longer the part of it.
### **Events:**
_Clear_recent_transactions:_

Clears the “new_transactions” table every hour for the day
### **Triggers:**
_After_Account_Insert:_

If a new account was made, that account will be automatically added to the Live_Accounts_INFO.

_After_Transaction_Insert:_

After a new transaction have been added to new_transactions, it also adds it to ACCOUNT_TRANSACTIONS (as this table is actually a history of all-time transactions).
