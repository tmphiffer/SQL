-- --------------------------------------------------------------------------------
-- Name: Tyler Phiffer
-- Class: IT-112
-- Abstract: Final Project CallsToStoredProcedures
-- --------------------------------------------------------------------------------



--recorded patient information via stored procedure
--

GO
-- patient number, site, date, gender, weight, null
DECLARE @intPatientID as Integer=0;

--these are study 1 patients
EXECUTE uspAddPatient @intPatientID OUTPUT, '101001','1','1/2/2011','2','115',NULL --1
EXECUTE uspAddPatient @intPatientID OUTPUT, '111001','2','2/11/2001','1','144',NULL--2
EXECUTE uspAddPatient @intPatientID OUTPUT, '121001','3','3/12/2002','2','185',NULL--3
EXECUTE uspAddPatient @intPatientID OUTPUT, '101002','1','3/12/2002','1','125',NULL--4
EXECUTE uspAddPatient @intPatientID OUTPUT, '111002','2','3/12/2002','2','285',NULL--5
EXECUTE uspAddPatient @intPatientID OUTPUT, '121002','3','3/12/2002','1','205',NULL--6
EXECUTE uspAddPatient @intPatientID OUTPUT, '101003','1','3/12/2002','1','285',NULL--7
EXECUTE uspAddPatient @intPatientID OUTPUT, '111003','2','3/12/2002','2','185',NULL--8

--these are study 2 patients
EXECUTE uspAddPatient @intPatientID OUTPUT, '501001','4','1/2/2011','2','115',NULL --1
EXECUTE uspAddPatient @intPatientID OUTPUT, '511001','5','2/11/2001','1','144',NULL--2
EXECUTE uspAddPatient @intPatientID OUTPUT, '521001','6','3/12/2002','2','185',NULL--3
EXECUTE uspAddPatient @intPatientID OUTPUT, '501002','4','3/12/2002','1','125',NULL--4
EXECUTE uspAddPatient @intPatientID OUTPUT, '511002','5','3/12/2002','2','285',NULL--5
EXECUTE uspAddPatient @intPatientID OUTPUT, '521002','6','3/12/2002','1','205',NULL--6
EXECUTE uspAddPatient @intPatientID OUTPUT, '501003','4','3/12/2002','1','285',NULL--7
EXECUTE uspAddPatient @intPatientID OUTPUT, '511003','5','3/12/2002','2','185',NULL--8

--  PATIENT ID -time of doctor visit (date) and visit type id (of 1) for pre screening
DECLARE @intVisitID as Integer=0;
Execute uspAddVisit @intVisitID OUTPUT, '1','12/11/2021','1',NULL	--#1
Execute uspAddVisit @intVisitID OUTPUT, '2','12/11/2021','1',NULL	--#2
Execute uspAddVisit @intVisitID OUTPUT, '3','12/11/2021','1',NULL	--#3
Execute uspAddVisit @intVisitID OUTPUT, '4','12/11/2021','1',NULL	--#4
Execute uspAddVisit @intVisitID OUTPUT, '5','12/11/2021','1',NULL	--#5
Execute uspAddVisit @intVisitID OUTPUT, '6','12/11/2021','1',NULL	--#6
Execute uspAddVisit @intVisitID OUTPUT, '7','12/11/2021','1',NULL	--#7
Execute uspAddVisit @intVisitID OUTPUT, '8','12/11/2021','1',NULL	--#8

Execute uspAddVisit @intVisitID OUTPUT, '9','12/11/2021','1',NULL	--#1
Execute uspAddVisit @intVisitID OUTPUT, '10','12/11/2021','1',NULL	--#2
Execute uspAddVisit @intVisitID OUTPUT, '11','12/11/2021','1',NULL	--#3
Execute uspAddVisit @intVisitID OUTPUT, '12','12/11/2021','1',NULL	--#4
Execute uspAddVisit @intVisitID OUTPUT, '13','12/11/2021','1',NULL	--#5
Execute uspAddVisit @intVisitID OUTPUT, '14','12/11/2021','1',NULL	--#6
Execute uspAddVisit @intVisitID OUTPUT, '15','12/11/2021','1',NULL	--#7
Execute uspAddVisit @intVisitID OUTPUT, '16','12/11/2021','1',NULL	--#8

-- add visit for randomization (aka visittypeID =2)
Execute uspAddVisit @intVisitID OUTPUT, '1','12/12/2021','2',NULL   --#9
Execute uspAddVisit @intVisitID OUTPUT, '2','12/12/2021','2',NULL	--#10
Execute uspAddVisit @intVisitID OUTPUT, '3','12/12/2021','2',NULL	--#11
Execute uspAddVisit @intVisitID OUTPUT, '4','12/12/2021','2',NULL	--#12
Execute uspAddVisit @intVisitID OUTPUT, '5','12/11/2021','2',NULL	--#13
Execute uspAddVisit @intVisitID OUTPUT, '6','12/11/2021','2',NULL	--#14
Execute uspAddVisit @intVisitID OUTPUT, '7','12/11/2021','2',NULL	--#15
Execute uspAddVisit @intVisitID OUTPUT, '8','12/11/2021','2',NULL	--#16

Execute uspAddVisit @intVisitID OUTPUT, '9','12/11/2021','2',NULL	--#1
Execute uspAddVisit @intVisitID OUTPUT, '10','12/11/2021','2',NULL	--#2
Execute uspAddVisit @intVisitID OUTPUT, '11','12/11/2021','2',NULL	--#3
Execute uspAddVisit @intVisitID OUTPUT, '12','12/11/2021','2',NULL	--#4
Execute uspAddVisit @intVisitID OUTPUT, '13','12/11/2021','2',NULL	--#5
Execute uspAddVisit @intVisitID OUTPUT, '14','12/11/2021','2',NULL	--#6
Execute uspAddVisit @intVisitID OUTPUT, '15','12/11/2021','2',NULL	--#7
Execute uspAddVisit @intVisitID OUTPUT, '16','12/11/2021','2',NULL	--#8

--remove patient from study
EXECUTE uspAddVisit @intVisitID OUTPUT, '1','01/1/01','3','2'
EXECUTE uspAddVisit @intVisitID OUTPUT, '2','01/1/01','3','1'



--EXECUTE uspRandomizeStudy1 (patientID,visitNumber)

--randomize patient 1 anyways but doesnt crash (also removed from study)


Execute uspRandomizeStudy1 3,11
Execute uspRandomizeStudy1 4,12
Execute uspRandomizeStudy1 5,13
Execute uspRandomizeStudy1 6,14
Execute uspRandomizeStudy1 7,15
Execute uspRandomizeStudy1 8,16

-- executes randomization of study 2 participants
Execute uspRandomizeStudy2 9,17
Execute uspRandomizeStudy2 10,18
Execute uspRandomizeStudy2 11,19
Execute uspRandomizeStudy2 12,20
Execute uspRandomizeStudy2 13,21
Execute uspRandomizeStudy2 14,22
Execute uspRandomizeStudy2 15,23
Execute uspRandomizeStudy2 16,24

--remove patient from study
EXECUTE uspAddVisit @intVisitID OUTPUT, '3','01/1/01','3','2'
EXECUTE uspAddVisit @intVisitID OUTPUT, '4','01/1/01','3','1'

--view all visits, last 4 entriest have withdraw reason (aka removed)
SELECT * FROM TVisits

SELECT * FROM TPatients

SELECT * FROM VPatientTreatment
SELECT * FROM TDrugKits

