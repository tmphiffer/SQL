-- --------------------------------------------------------------------------------
-- Name: Tyler Phiffer
-- Class: IT-112
-- Abstract: Final Project
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE dbSQL1;     -- Get out of the master database
SET NOCOUNT ON; -- Report only errors

-- --------------------------------------------------------------------------------
-- Drop Tables
-- --------------------------------------------------------------------------------

IF OBJECT_ID( 'TDrugKits' )				IS NOT NULL DROP TABLE		TDrugKits
IF OBJECT_ID( 'TVisits' )				IS NOT NULL DROP TABLE		TVisits
IF OBJECT_ID( 'TPatients' )				IS NOT NULL DROP TABLE		TPatients
IF OBJECT_ID( 'TRandomCodes' )			IS NOT NULL DROP TABLE		TRandomCodes
IF OBJECT_ID( 'TStudies' )				IS NOT NULL DROP TABLE		TStudies
IF OBJECT_ID( 'TVisitTypes' )			IS NOT NULL DROP TABLE		TVisitTypes
IF OBJECT_ID( 'TSites' )				IS NOT NULL DROP TABLE		TSites
IF OBJECT_ID( 'TStates' )				IS NOT NULL DROP TABLE		TStates
IF OBJECT_ID( 'TWithdrawReasons' )		IS NOT NULL DROP TABLE		TWithdrawReasons
IF OBJECT_ID( 'TGenders' )				IS NOT NULL DROP TABLE		TGenders


-- --------------------------------------------------------------------------------
-- Drop Procedures
-- --------------------------------------------------------------------------------
IF OBJECT_ID( 'uspAddPatient')		IS NOT NULL		DROP PROCEDURE uspAddPatient
IF OBJECT_ID( 'uspAddVisit')		IS NOT NULL		DROP PROCEDURE uspAddVisit
IF OBJECT_ID( 'uspRandomizeStudy1')		IS NOT NULL		DROP PROCEDURE uspRandomizeStudy1
IF OBJECT_ID( 'uspRandomizeStudy2')		IS NOT NULL		DROP PROCEDURE uspRandomizeStudy2
IF OBJECT_ID( 'seqNextRandom')		IS NOT NULL		DROP Sequence seqNextRandom
IF OBJECT_ID( 'uspWithdraw')		IS NOT NULL		DROP Procedure uspWithdraw
IF OBJECT_ID( 'seqNextRandomA')		IS NOT NULL		DROP Sequence seqNextRandomA
IF OBJECT_ID( 'seqNextRandomP')		IS NOT NULL		DROP Sequence seqNextRandomP
-- --------------------------------------------------------------------------------
-- Drop Views
-- --------------------------------------------------------------------------------
IF OBJECT_ID( 'VAllPatients')		IS NOT NULL		DROP View VAllPatients
IF OBJECT_ID( 'VRandPatients')		IS NOT NULL		DROP View VRandPatients
IF OBJECT_ID( 'VMinRandom1')		IS NOT NULL		DROP View VMinRandom1
IF OBJECT_ID( 'VAvailableKit')		IS NOT NULL		DROP View VAvailableKit
IF OBJECT_ID( 'VWithdrawn')			IS NOT NULL		DROP View VWithdrawn
IF OBJECT_ID( 'VPatientTreatment')			IS NOT NULL		DROP View VPatientTreatment


-- --------------------------------------------------------------------------------
-- Step #1.1: Create Tables
-- --------------------------------------------------------------------------------

CREATE TABLE TStudies
(
	 intStudyID			INTEGER			NOT NULL
	,strStudyDesc		VARCHAR(50)		NOT NULL
	,CONSTRAINT TStudies_PK PRIMARY KEY ( intStudyID )
)

CREATE TABLE TSites
(
	 intSiteID			INTEGER			NOT NULL
	,intSiteNumber		Integer			NOT NULL
	,intStudyID			Integer			Not Null
	,strName			VARCHAR(50)		Not Null
	,strAddress			Varchar(50)		Not Null
	,strCity			Varchar(50)		Not Null
	,intStateID			Integer			Not Null
	,strZip				Varchar(50)		Not Null
	,strPhone			Varchar(50)		Not Null
	,CONSTRAINT TSites_PK PRIMARY KEY ( intSiteID )
)

CREATE TABLE TPatients
(
	 intPatientID			INTEGER			NOT NULL
	,intPatientNumber		Integer			NOT NULL
	,intSiteID				Integer			Not Null
	,dtmDOB					Date			Not Null
	,intGenderID			Integer			Not Null
	,intWeight				Varchar(50)		Not Null
	,intRandomCodeID		Integer	
	,CONSTRAINT TPatients_PK PRIMARY KEY ( intPatientID )
)

CREATE TABLE TVisitTypes
(
	 intVisitTypeID			INTEGER			NOT NULL
	,strVisitDesc				Varchar(50)		Not Null
	,CONSTRAINT TVisitTypes_PK PRIMARY KEY ( intVisitTypeID )
)

CREATE TABLE TVisits
(
	 intVisitID				INTEGER			NOT NULL
	,intPatientID			Integer			NOT NULL
	,dtmVisit				Date			Not Null
	,intVisitTypeID			Integer			Not Null
	,intWithdrawReasonID	Integer			

	,CONSTRAINT TVisits_PK PRIMARY KEY ( intVisitID )
)

CREATE TABLE TRandomCodes
(
	 intRandomCodeID		INTEGER			NOT NULL
	,intRandomCode			Integer			NOT NULL
	,intStudyID				Integer			Not Null
	,strTreatment			Varchar(50)			Not Null
	,blnAvailable			Varchar(50)			Not Null

	,CONSTRAINT TRandomCodes_PK PRIMARY KEY ( intRandomCodeID )
)

Create Table TDrugKits
(
	intDrugKitID		Integer		Not Null
	,intDrugKitNumber	Integer		Not Null
	,intSiteID			Integer		Not Null
	,strTreatment		Varchar(50)	Not Null
	,intVisitID			integer		

	,Constraint TDrugDits_PK Primary Key (intDrugKitID)
)

CREATE TABLE TWithdrawReasons
(
	 intWithdrawReasonID		INTEGER			NOT NULL
	,strWithdrawDesc			Varchar(50)			NOT NULL

	,CONSTRAINT TWithdrawReasons_PK PRIMARY KEY ( intWithdrawReasonID )
)

CREATE TABLE TGenders
(
	 intGenderID		INTEGER			NOT NULL
	,strGender			Varchar(50)			NOT NULL

	,CONSTRAINT TGenders_PK PRIMARY KEY ( intGenderID )
)

CREATE TABLE TStates
(
	 intStateID				INTEGER			NOT NULL
	,strStateDesc			Varchar(50)		NOT NULL

	,CONSTRAINT TStates_PK PRIMARY KEY ( intStateID )
)


-- --------------------------------------------------------------------------------
-- Step #1.2: Identify and Create Foreign Keys
-- --------------------------------------------------------------------------------
--
-- #	Child								Parent						Column(s)
-- -	-----								------						---------
--0     TVendors					TState						intStateID
--1		TSites						TStates						intStateID
--2		TPatients					TSites						intSiteID
--3		TPatients					TGender						intGenderID
--4		TPatients					TRandomCodes				intRandomCodeID
--5		TVisits						TPatients					intPatientID
--6		TVisits						TWithdrawReasons			intWithdrawReasonID
--7		TRandomCodes				TStudies					intStudyID
--8		TDrugKits					TSites						intSiteID
--9		TDrugKits					TVisits						intVisitID





--0 (reference)
--ALTER TABLE TVendors ADD CONSTRAINT TVendors_TState_FK
--FOREIGN KEY ( intStateID ) REFERENCES TState ( intStateID )

--1
ALTER TABLE TSites ADD CONSTRAINT TSites_TStates_FK
FOREIGN KEY (intStateID) REFERENCES TStates (intStateID)

--2
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TSites_FK
FOREIGN KEY (intSiteID) REFERENCES TSites (intSiteID)

--3
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TGenders_FK
FOREIGN KEY (intGenderID) REFERENCES TGenders (intGenderID)

--4
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TRandomCodes_FK
FOREIGN KEY (intRandomCodeID) REFERENCES TRandomCodes (intRandomCodeID)


--5
ALTER TABLE TVisits ADD CONSTRAINT TVisits_TPatients_FK
FOREIGN KEY (intPatientID) REFERENCES TPatients (intPatientID)

--6
ALTER TABLE TVisits ADD CONSTRAINT TVisits_TWithdrawReasons_FK
FOREIGN KEY (intWithdrawReasonID) REFERENCES TWithdrawReasons (intWithdrawReasonID)

--7
ALTER TABLE TRandomCodes ADD CONSTRAINT TRandomCodes_TStudies_FK
FOREIGN KEY (intStudyID) REFERENCES TStudies (intStudyID)


--8
ALTER TABLE TDrugKits ADD CONSTRAINT TDrugKits_TSites_FK
FOREIGN KEY (intSiteID) REFERENCES TSites (intSiteID)

--9
ALTER TABLE TDrugKits ADD CONSTRAINT TDrugKits_TVisits_FK
FOREIGN KEY (intVisitID) REFERENCES TVisits (intVisitID)



-- --------------------------------------------------------------------------------
-- Step #1.3: add inserts
-- --------------------------------------------------------------------------------
INSERT INTO TStudies ( intStudyID, strStudyDesc )
VALUES	 ( 1, 'Study 12345')
		,( 2, 'Study 54321')
		


INSERT INTO TVisitTypes( intVisitTypeID, strVisitDesc )
VALUES	 ( 1, 'Screening')
		,( 2, 'Randomization')
		,( 3, 'Withdrawal')
		

Insert Into TStates (intStateID, strStateDesc)
Values	(1,'Ohio')
		,(2,'Kentucky')
		,(3,'Indiana')
		,(4,'New Jersey')
		,(5,'Virginia')
		,(6,'Georgia')
		,(7,'Iowa')

INSERT INTO TSites( intSiteID, intSiteNumber, intStudyID, strName , strAddress,  strCity, intStateID, strZip, strPhone)
VALUES	 ( 1, '101' , '1','Dr.Stan Heinrich','123 E.Main St','Atlanta','6','25869','1234567890')
		,( 2, '111' , '1','Mercy Hospital','3456 Elmhurst Rd.','Secaucus','4','32659','5013629564')
		,( 3, '121' , '1','St. Elizabeth Hospital','976 Jackson Way','Ft. Thomas','2','41258','3026521478')
		,( 4, '501' , '2','Dr. Robert Adler','9087 W. Maple Ave.','Cedar Rapids','7','42365','6149652574')
		,( 5, '511' , '2','Dr.Tim Schmitz','4539 Helena Run','Mason','1','45040','5136987462')
		,( 6, '521' , '2','Dr.Lawrence Snell','9201 NW. Washington Blvd.','Bristol','5','20163','3876510249')


-- T patients done with stored proc :)


Insert Into TRandomCodes (intRandomCodeID, intRandomCode, intStudyID, strTreatment, blnAvailable)
Values	(1,'1000','1','A','T')
		,(2,'1001','1','P','T')
		,(3,'1002','1','A','T')
		,(4,'1003','1','P','T')
		,(5,'1004','1','P','T')
		,(6,'1005','1','A','T')
		,(7,'1006','1','A','T')
		,(8,'1007','1','P','T')
		,(9,'1008','1','A','T')
		,(10,'1009','1','P','T')
		,(11,'1010','1','P','T')
		,(12,'1011','1','A','T')
		,(13,'1012','1','P','T')
		,(14,'1013','1','A','T')
		,(15,'1014','1','A','T')
		,(16,'1015','1','A','T')
		,(17,'1016','1','P','T')
		,(18,'1017','1','P','T')
		,(19,'1018','1','A','T')
		,(20,'1019','1','P','T')

		,(21,'5000','2','A','T')
		,(22,'5001','2','A','T')
		,(23,'5002','2','A','T')
		,(24,'5003','2','A','T')
		,(25,'5004','2','A','T')
		,(26,'5005','2','A','T')
		,(27,'5006','2','A','T')
		,(28,'5007','2','A','T')
		,(29,'5008','2','A','T')
		,(30,'5009','2','A','T')
		,(31,'5010','1','P','T')
		,(32,'5011','1','P','T')
		,(33,'5012','1','P','T')
		,(34,'5013','1','P','T')
		,(35,'5014','1','P','T')
		,(36,'5015','1','P','T')
		,(37,'5016','1','P','T')
		,(38,'5017','1','P','T')
		,(39,'5018','1','P','T')
		,(40,'5019','1','P','T')


Insert Into TDrugKits (intDrugKitID, intDrugKitNumber, intSiteID, strTreatment, intVisitID)
Values	(1,'10000','1','A',NULL)
		,(2,'10001','1','A',NULL)
		,(3,'10002','1','A',NULL)
		,(4,'10003','1','P',NULL)
		,(5,'10004','1','P',NULL)
		,(6,'10005','1','P',NULL)
		,(7,'10006','2','A',NULL)
		,(8,'10007','2','A',NULL)
		,(9,'10008','2','A',NULL)
		,(10,'10009','2','P',NULL)
		,(11,'10010','2','P',NULL)
		,(12,'10011','2','P',NULL)
		,(13,'10012','3','A',NULL)
		,(14,'10013','3','A',NULL)
		,(15,'10014','3','A',NULL)
		,(16,'10015','3','P',NULL)
		,(17,'10016','3','P',NULL)
		,(18,'10017','3','P',NULL)
		,(19,'10018','4','A',NULL)
		,(20,'10019','4','A',NULL)
		,(21,'10020','4','A',NULL)
		,(22,'10021','4','P',NULL)
		,(23,'10022','4','P',NULL)
		,(24,'10023','4','P',NULL)
		,(25,'10024','5','A',NULL)
		,(26,'10025','5','A',NULL)
		,(27,'10026','5','A',NULL)
		,(28,'10027','5','P',NULL)
		,(29,'10028','5','P',NULL)
		,(30,'10029','5','P',NULL)
		,(31,'10030','6','A',NULL)
		,(32,'10031','6','A',NULL)
		,(33,'10032','6','A',NULL)
		,(34,'10033','6','P',NULL)
		,(35,'10034','6','P',NULL)
		,(36,'10035','6','P',NULL)

Insert Into TWithdrawReasons (intWithdrawReasonID, strWithdrawDesc)
Values (1, 'Patient withdrew consent')
		,(2,'Adverse Event')
		,(3,'Health Issue-related to study')
		,(4,'Health Issue-unrelated to study')
		,(5,'Personal Reason')
		,(6,'Completed the Study')

Insert Into TGenders(intGenderID,strGender)
Values (1, 'male')
		,(2,'female')




--views

GO

Create View VAllPatients
as
Select TPatients.intPatientID, TPatients.intSiteID
FROM TPatients


GO
Create View VRandPatients
as
Select TPatients.intPatientID,TPatients.intSiteID,TPatients.intRandomCodeID
FROM TPatients

Go
Create View VMinRandom1 
as 
Select MIN(intRandomCodeID) as RandomNext
FROM TRandomCodes





Go

CREATE SEQUENCE seqNextRandom AS INT
start with 1
increment by 1
minvalue 0
maxvalue 100
cycle;


Go

CREATE SEQUENCE seqNextRandomA AS INT
start with 21
increment by 1
minvalue 21
maxvalue 30
cycle;



Go

CREATE SEQUENCE seqNextRandomP AS INT
start with 31
increment by 1
minvalue 31
maxvalue 40
cycle;




 Go 
 Create View VPatientTreatment
 as
 SELECT TPatients.intPatientID, TPatients.intSiteID, TRandomCodes.intRandomCodeID, TRandomCodes.strTreatment
FROM TPatients
INNER JOIN TRandomCodes ON TPatients.intRandomCodeID=TRandomCodes.intRandomCodeID;




 Go 
 Create View VAvailableKit
 as
 Select TDrugKits.intDrugKitID,TDrugKits.intSiteID
 From	TDrugKits


 GO
 Create View VWithdrawn
 as
 SELECT     TVisits.intPatientID, TVisits.intWithdrawReasonID, TWithdrawReasons.strWithdrawDesc
 FROM       TVisits
 LEFT JOIN  TWithdrawReasons ON TVisits.intWithdrawReasonID = TWithdrawReasons.intWithdrawReasonID
 WHERE      TVisits.intWithdrawReasonID IS Not NULL;



 --stored procs
  --#5 uspAddCustomer


GO

CREATE PROCEDURE uspAddPatient
	 @intPatientID 			AS INTEGER OUTPUT
	,@intPatientNumber		AS Integer
	,@intSiteID				AS INTEGER
	,@dtmDOB				AS DATE
	,@intGenderID			AS Integer
	,@intWeight				AS Integer
	,@intRandomCodeID		AS INTEGER
AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

BEGIN TRANSACTION

	SELECT @intPatientID  = MAX( intPatientID ) + 1
	FROM TPatients (TABLOCKX) -- Lock table until end of transaction

	-- Default to 1 if table is empty
	SELECT @intPatientID  = COALESCE( @intPatientID , 1 )

	INSERT INTO TPatients( intPatientID, intPatientNumber, intSiteID, dtmDOB, intGenderID, intWeight, intRandomCodeID )
	VALUES( @intPatientID, @intPatientNumber, @intSiteID, @dtmDOB, @intGenderID, @intWeight, @intRandomCodeID )

COMMIT TRANSACTION

--remove random code from patient to withdraw

GO
CREATE PROCEDURE uspWithdraw
	@intPatientID AS INTEGER
AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

BEGIN TRANSACTION


Update TPatients set intRandomCodeID = NULL
WHERE intPatientID = @intPatientID

COMMIT TRANSACTION


--add visit
GO

CREATE PROCEDURE uspAddVisit
	 @intVisitID 			AS INTEGER OUTPUT
	,@intPatientID			AS Integer
	,@dtmVisit				AS Date
	,@intVisitTypeID		AS INTEGER
	,@intWithdrawReasonID	AS INTEGER
AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

BEGIN TRANSACTION

	SELECT @intVisitID  = MAX( intVisitID ) + 1
	FROM TVisits (TABLOCKX) -- Lock table until end of transaction

	-- Default to 1 if table is empty
	SELECT @intVisitID  = COALESCE( @intVisitID , 1 )

	INSERT INTO TVisits( intVisitID, intPatientID, dtmVisit, intVisitTypeID, intWithdrawReasonID)
	VALUES( @intVisitID, @intPatientID, @dtmVisit, @intVisitTypeID, @intWithdrawReasonID)

	--if visit is type 3 update TPatient to recieve update to withdraw reason
	IF (@intVisitID ='3')
	EXECUTE uspWithdraw @intPatientID;
	

COMMIT TRANSACTION




--randomize patient for 12345 study
GO

Create Procedure uspRandomizeStudy1
@intPatientID		AS INTEGER
,@intVisitID			AS INTEGER

AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

BEGIN TRANSACTION
	
	DECLARE @intRandomCodeID as Integer=0;
	DECLARE @intSiteID as INTEGER=0;
	DECLARE @strTreatment as Varchar ='';



	-- since study 1 is down the list order for random codes i just made a sequence to assign id



	SELECT @intRandomCodeID = NEXT VALUE FOR seqNextRandom;  
	
	UPDATE TPatients set TPatients.intRandomCodeID = @intRandomCodeID
	where TPatients.intPatientID = @intPatientID


--now to fetch drug kit

--first get site
	
			DECLARE ObtainSite CURSOR LOCAL FOR
			SELECT intSiteID FROM TPatients
			WHERE intPatientID = @intPatientID
			
			OPEN ObtainSite

			FETCH FROM ObtainSite
			INTO @intSiteID		

			CLOSE ObtainSite

--fetch treatment
			DECLARE ObtainTreatment CURSOR LOCAL FOR
			SELECT strTreatment FROM VPatientTreatment
			WHERE intPatientID = @intPatientID
			
			OPEN ObtainTreatment

			FETCH FROM ObtainTreatment
			INTO @strTreatment	

			CLOSE ObtainTreatment

--update TDrugKits for visitID


		UPDATE TOP (1) TDrugKits set TDrugKits.intVisitID = @intVisitID
		WHERE TDrugKits.intSiteID = @intSiteID AND TDrugKits.strTreatment = @strTreatment AND TDrugKits.intVisitID IS NULL;
		


COMMIT TRANSACTION




GO

Create Procedure uspRandomizeStudy2
@intPatientID		AS INTEGER
,@intVisitID			AS INTEGER

AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

BEGIN TRANSACTION
	
	DECLARE @intRandomCodeID as Integer=0;
	DECLARE @intSiteID as INTEGER=0;
	DECLARE @strTreatment as Varchar ='';
	DECLARE @RNGletitRIP as Integer=1;


	-- use sequence if RNG is less than 0.5 for next available random code to be assigned to patient

	-- author note, no idea how to set it up so that no more than two in A group than in P group
	-- I tried eveyrthing, views, counts, sequences, nothing worked for me.

IF (RAND() > 0.5  )
    SELECT @intRandomCodeID = NEXT VALUE FOR seqNextRandomA;
ELSE
    SELECT @intRandomCodeID = NEXT VALUE FOR seqNextRandomP;



	UPDATE TPatients set TPatients.intRandomCodeID = @intRandomCodeID
	where TPatients.intPatientID = @intPatientID


--now to fetch drug kit

--first get site
	
			DECLARE ObtainSite CURSOR LOCAL FOR
			SELECT intSiteID FROM TPatients
			WHERE intPatientID = @intPatientID
			
			OPEN ObtainSite

			FETCH FROM ObtainSite
			INTO @intSiteID		

			CLOSE ObtainSite

--fetch treatment
			DECLARE ObtainTreatment CURSOR LOCAL FOR
			SELECT strTreatment FROM VPatientTreatment
			WHERE intPatientID = @intPatientID
			
			OPEN ObtainTreatment

			FETCH FROM ObtainTreatment
			INTO @strTreatment	

			CLOSE ObtainTreatment

--update TDrugKits for visitID


		UPDATE TOP (1) TDrugKits set TDrugKits.intVisitID = @intVisitID
		WHERE TDrugKits.intSiteID = @intSiteID AND TDrugKits.strTreatment = @strTreatment AND TDrugKits.intVisitID IS NULL;
		


COMMIT TRANSACTION