-- --------------------------------------------------------------------------------
-- Name:		Tyler Phiffer
-- Class:		IT-111 review homework 1
-- Abstract:	DB Intro
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Options




-- --------------------------------------------------------------------------------
USE dbSQL1		            -- Don't work in master
SET NOCOUNT ON				-- Report only errors

-- ----------------------------------------------------------------------
-- Drops
-- ----------------------------------------------------------------------
IF OBJECT_ID( 'TCustomerJobs')		IS NOT NULL		DROP TABLE TCustomerJobs
IF OBJECT_ID( 'TCustomers' )		IS NOT NULL		DROP TABLE TCustomers
IF OBJECT_ID( 'TJobs' )				IS NOT NULL		DROP TABLE TJobs


-- drop views--------------------------------------------------------------
IF OBJECT_ID( 'VCustomers')		IS NOT NULL		DROP View VCustomers
IF OBJECT_ID( 'VCustomerJobs')		IS NOT NULL		DROP View VCustomerJobs
IF OBJECT_ID( 'VCustomerNoJob')		IS NOT NULL		DROP View VCustomerNoJob
IF OBJECT_ID( 'VCustomerJobCount')		IS NOT NULL		DROP View VCustomerJobCount

--drop procedures--------------------------------------------------------------
IF OBJECT_ID( 'uspAddCustomer')		IS NOT NULL		DROP PROCEDURE uspAddCustomer
IF OBJECT_ID( 'uspAddJob')		IS NOT NULL		DROP PROCEDURE uspAddJob
IF OBJECT_ID( 'uspAddCustomerJob')		IS NOT NULL		DROP PROCEDURE uspAddCustomerJob
IF OBJECT_ID( 'uspAddCustomerAndJob')		IS NOT NULL		DROP PROCEDURE uspAddCustomerAndJob



GO

-- ----------------------------------------------------------------------
-- Tables
-- ----------------------------------------------------------------------
CREATE TABLE TCustomers
(
	intCustomerID               INTEGER        NOT NULL,
	strName                     VARCHAR(50)    NOT NULL,
	intPhoneNumber              INTEGER			NOT NULL,
	strEmail					VARCHAR(50)    NOT NULL,

	CONSTRAINT TCustomers_PK PRIMARY KEY CLUSTERED ( intCustomerID ))

CREATE TABLE TJobs
(
	intJobID					INTEGER        NOT NULL,
	strJobDesc                  VARCHAR(50)    NOT NULL,
	dtmStartDate				Date			NOT NULL,
	dtmEndDate					Date			 ,

	CONSTRAINT TJobs_PK PRIMARY KEY CLUSTERED ( intJobID ))


CREATE TABLE TCustomerJobs
(
	intCustomerJobID			INTEGER IDENTITY         NOT NULL,
	intCustomerID               INTEGER			NOT NULL,
	intJobID					INTEGER			NOT NULL,

	CONSTRAINT TCustomerJobs_PK PRIMARY KEY CLUSTERED ( intCustomerJobID ))

-- --------------------------------------------------------------------------------
--	Step #2 : Establishing Referential Integrity 
-- --------------------------------------------------------------------------------
--
-- #	Child							Parent						Column
-- -	-----							------						---------						 
-- 1	TCustomers					TCustomerJobs					intCustomerID
-- 2	TJobs						TCustomerJobs						intJobID



---2
ALTER TABLE TCustomerJobs	 ADD CONSTRAINT TCustomerJobs_TCustomers_FK 
FOREIGN KEY ( intCustomerID ) REFERENCES TCustomers ( intCustomerID ) ON DELETE CASCADE

--3
ALTER TABLE TCustomerJobs	 ADD CONSTRAINT TCustomerJobs_TJobs_FK 
FOREIGN KEY ( intJobID ) REFERENCES TJobs ( intJobID ) ON DELETE CASCADE


 --Inserts      name phone email
INSERT INTO TCustomers( intCustomerID, strName, intPhoneNumber, strEmail )
VALUES ( 1, 'Jill', '1231231234', 'adc@gmail.com')
	,(2, 'Bill','1112223333','billman@gmail.com')
	,(3,'Phil','1564564560','TrillPhil@gmail.com')



-- Jobs     desc    start      end
INSERT INTO TJobs (intJobID, strJobDesc, dtmStartDate, dtmEndDate)
	Values(1,'Wall','1/10/2021','1/20/2021')
			,(2,'Floors','2/10/2021','3/10/2021')
			,(3,'Walls','3/10/2021',NULL)


SET IDENTITY_INSERT TCustomerJobs ON;
---- CustomerJobs  CJ    C     J
INSERT INTO TCustomerJobs(intCustomerJobID, intCustomerID,intJobID)
		Values(1,1,3)
			,(2,1,1)
			,(3,2,1)



GO





-- ----------------------------------------------------------------------
-- Testing
-- ----------------------------------------------------------------------

--show customers
--SELECT TC.intCustomerID
--from TCustomers as TC


-- show jobs
--Select TJ.intJobID
--from TJobs as TJ


--show customers that have placed work order
--Select TJC.intCustomerID, TJC.intJobID
--from TCustomerJobs as TJC



-- this is supposed to not work but idk it just doesnt give me an error, I cant remember how to create something that would place a restraint to give a 1 to 1 relationship between customer and job
-- and not allow the same job multiple times to the same customer

--Update TCustomerJobs set intCustomerID = '1'
--where intCustomerID = '2'

--Select TJC.intCustomerID, TJC.intJobID
--from TCustomerJobs as TJC


--find jobs with no end date (aka not complete)
--SELECT
--	intJobID
--	,strJobDesc
--	,dtmEndDate
--FROM
--	TJobs
--WHERE dtmEndDate is NULL




-- ASSIGNMENT TWO ---------- VIEWS AND STORED PROCS -------------

--#1 VCUSTOMERS

GO

Create View VCustomers
as
Select TC.strName
		, TC.strEmail
FROM
TCustomers as TC

--GO

--SELECT * From VCustomers




--#2 VCustomerJobs

GO

Create View VCustomerJobs
as
Select TJC.intCustomerID, TJC.intJobID
from TCustomerJobs as TJC

--Go
--Select * from VCustomerJobs


--#3 VCustomerNoJob
 GO
 Create View VCustomerNoJob
 as
 SELECT     TCustomers.strName
 FROM       TCustomers
 LEFT JOIN  TCustomerJobs ON TCustomers.intCustomerID = TCustomerjobs.intCustomerID
 WHERE      TCustomerJobs.intJobID IS NULL;

 --GO
 --Select * from VCustomerNoJob
 -- ^ works because Phil was the only customer with no job and he shows up when executed


 --#4 VCustomerJobCount
 GO
 Create View VCustomerJobCount
 as
 Select COUNT (intJobID) as JobCount from TCustomerJobs
 

 --Go
 --Select * from VCustomerJobCount
 
 -- not sure why it wont let me order the columns by which which job id the count is from
 -- so doesnt work


 --#5 uspAddCustomer


GO

CREATE PROCEDURE uspAddCustomer
	 @intCustomerID 		AS INTEGER OUTPUT
	,@strName				AS VARCHAR( 50 )
	,@intPhoneNumber		AS INTEGER
	,@strEmail				AS VARCHAR( 50 )
AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

BEGIN TRANSACTION

	SELECT @intCustomerID  = MAX( intCustomerID ) + 1
	FROM TCustomers (TABLOCKX) -- Lock table until end of transaction

	-- Default to 1 if table is empty
	SELECT @intCustomerID  = COALESCE( @intCustomerID , 1 )

	INSERT INTO TCustomers( intCustomerID, strName, intPhoneNumber, strEmail )
	VALUES( @intCustomerID, @strName, @intPhoneNumber, @strEmail )

COMMIT TRANSACTION

---- Test it
--GO

--DECLARE @intCustomerID AS INTEGER = 3;
--EXECUTE uspAddCustomer @intCustomerID OUTPUT, 'Fred', '1231112222', 'abcd@gman.com' 
--PRINT 'Customer ID = ' + CONVERT( VARCHAR, @intCustomerID )


--Select * from TCustomers


--#6----------------------------------------------- uspAddJob
GO

CREATE PROCEDURE uspAddJob
	 @intJobID 					AS INTEGER OUTPUT
	,@strJobDesc				AS VARCHAR( 50 )
	,@dtmStartDate				AS Date
	,@dtmEndDate					AS Date
AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

BEGIN TRANSACTION

	SELECT @intJobID  = MAX( intJobID ) + 1
	FROM TJobs (TABLOCKX) -- Lock table until end of transaction

	-- Default to 1 if table is empty
	SELECT @intJobID  = COALESCE( @intJobID , 1 )

	INSERT INTO TJobs( intJobID, strJobDesc, dtmStartDate, dtmEndDate )
	VALUES( @intJobID, @strJobDesc, @dtmStartDate, @dtmEndDate )

COMMIT TRANSACTION

---- Test it
--GO

--DECLARE @intJobID AS INTEGER = 0;
--EXECUTE uspAddJob @intJobID OUTPUT, 'Remodel', '10/22/2022', '10/29/2022' 
--PRINT 'Job ID = ' + CONVERT( VARCHAR, @intJobID )


--Select * from TJobs


-- --------------------------------------------------------------------------------
-- Assignment 3 Problem 1: uspAddCustomerJob
-- --------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspAddCustomerJob
	 @intCustomerJobID 			AS INTEGER OUTPUT
	,@intCustomerID 			AS INTEGER
	,@intJobID 					AS INTEGER
AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

BEGIN TRANSACTION

	

	INSERT INTO TCustomerJobs WITH (TABLOCKX) ( intCustomerID, intJobID)
	VALUES( @intCustomerID, @intJobID )

	SELECT @intCustomerJobID = MAX(intCustomerJobiD)
	FROM TCustomerJobs

COMMIT TRANSACTION

GO

 --Test it -- This works but the screenshot attatched shows the IDENTITY_INSERT to OFF so my insert into table at the top for samples doesnt work but this shows 
 -- that whene executed through the stored proc that it does infact insert however i dont know how to turn on identity insert for the generic insert into statement above
 -- i assume its just a setting I dont have enabled

--DECLARE @intCustomerJobID AS INTEGER = 0;
--EXECUTE uspAddCustomerJob @intCustomerJobID OUTPUT, 3, 3
--PRINT 'Customer Job ID = ' + CONVERT( VARCHAR, @intCustomerJobID )
--Select * FROM TCustomerJobs

-- --------------------------------------------------------------------------------
-- Assignment 3 Problem 2: uspAddCustomerAndJob
-- --------------------------------------------------------------------------------
GO

--INSERT INTO TCustomers( intCustomerID, strName, intPhoneNumber, strEmail )
CREATE PROCEDURE uspAddCustomerAndJob
	 @intCustomerJobID 		AS INTEGER OUTPUT
	,@strName				AS VARCHAR( 50 )
	,@intPhoneNumber		AS INTEGER
	,@strEmail				AS VARCHAR( 50 )
	,@strJobDesc				AS VARCHAR( 50 )
	,@dtmStartDate				AS Date
	,@dtmEndDate					AS Date

AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

BEGIN TRANSACTION

	DECLARE @intCustomerID AS INTEGER ;
	DECLARE @intJobID AS INTEGER ;
	
	EXECUTE uspAddCustomer @intCustomerID OUTPUT, @strName, @intPhoneNumber, @strEmail

	EXECUTE uspAddJob @intJobID OUTPUT, @strJobDesc, @dtmStartDate, @dtmEndDate
	
	EXECUTE uspAddCustomerJob @intCustomerJobID OUTPUT, @intCustomerID, @intJobID
	

COMMIT TRANSACTION

--TEST IT!



--GO

--SELECT * FROM TCustomers
--SELECT * FROM TJobs
--SELECT * FROM TCustomerJobs


--DECLARE @intCustomerJobID AS INTEGER
--EXECUTE uspAddCustomerAndJob @intCustomerJobID OUTPUT, 'Alise', '1112221111','ffxiv@gmail.com', 'crystal repair','10/22/3099', '11/21/3100'
--PRINT 'Customer Job = ' + CONVERT( VARCHAR, @intCustomerJobID )

--SELECT * FROM TCustomers
--SELECT * FROM TJobs
--SELECT * FROM TCustomerJobs
