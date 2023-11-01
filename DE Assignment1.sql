/*Documentation:
https://www.kaggle.com/datasets/ravindrasinghrana/employeedataset?select=training_and_development_data.csv */
SET Global local_infile = "ON";
show variables like "local_infile";
/* Creating the Assignment Schema
	If there's already a Schema named that, it drops it,
    to eliminate error.*/
Drop Schema if exists Assignment;
Create Schema Assignment;
Use Assignment;

/* Creating the neccesary tables. */
Drop Table if exists employee_data;
Create Table employee_data
(EmpID Integer Not Null,
FirstName Varchar(32) Not Null,
LastName Varchar(32) Not Null,
StartDate Date Not Null,
ExitDate Date,
Title Varchar(255) Not Null,
Supervisor Varchar(64) Not Null,
ADEmail Varchar(255) Not Null,
BusinessUnit Varchar(16) Not Null,
EmployeeStatus Varchar(32) Not Null,
EmployeeType Varchar(16) Not Null,
PayZone Varchar(16) Not Null,
EmployeeClassificationType Varchar(16) Not Null,
TerminationType Varchar(16) Not Null,
TerminationDescription Varchar(255),
DepartmentType Varchar(32) Not Null,
Division Varchar(64) Not Null,
DOB Date Not Null,
State Varchar(32) Not Null,
JobFunctionDescription Varchar(255) Not Null,
GenderCode Varchar(16) Not Null,
LocationCode Integer Not Null,
RaceDesc Varchar(32) Not Null,
MaritalDesc Varchar(32) Not Null,
PerformanceScore Varchar(64) Not Null,
CurrentEmployeeRating Integer Not Null,
Primary key(EmpID)
);

/* Loading the files*/
LOAD DATA Local INFILE 'D:\GITHUB\SQL Practice\Data-Engineering-Assignment1\Data\employee_data.csv' 
INTO TABLE employee_data
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES
(EmpID, FirstName, LastName, StartDate, @v_ExitDate, Title, Supervisor, ADEmail, BusinessUnit, EmployeeStatus, EmployeeType, PayZone, 
EmployeeClassificationType, TerminationType, @v_TerminationDescription, DepartmentType, Division, DOB, State, JobFunctionDescription, 
GenderCode, LocationCode, RaceDesc, MaritalDesc, PerformanceScore, CurrentEmployeeRating
)
SET
ExitDate = nullif(@v_ExitDate, ''),
TerminationDescription = nullif(@v_TerminationDescription, '');