-----------------------------
-- Linear Road Benchmark Queries
-----------------------------
--
-- For Exareme / Madis
-- Author: max.berndt@tuhh.de
-- Version: April, 2016
-- Open with python ./lib/madis/src/mterm.py my.db
-- Use UDF operator lrb.py to execute the benchmark
-- For examples see bottom of this file

-----------------------------
-- 1 Highway Data Source
-----------------------------
CREATE TABLE IF NOT EXISTS Source AS SELECT cast(C1 AS int) AS Type, cast(C2 AS int) AS Time, cast(C3 AS int) AS VID, cast(C4 AS int) AS Spd, cast(C5 AS int) AS XWay, cast(C6 AS int) AS Lane, cast(C7 AS int) AS Dir, cast(C8 AS int) AS Seg, cast(C9 AS int) AS Pos, cast(C10 AS int) AS QID, cast(C11 AS int) AS SInit, cast(C12 AS int) AS SEnd, cast(C13 AS int) AS DOW, cast(C14 AS int) AS TOD, cast(C15 AS int) AS Day FROM (file '/path/to/cardatapoints.csv');
CREATE INDEX IF NOT EXISTS SourceIndex ON Source(Type, Time, VID, Spd, XWay, Lane, Dir, Seg, Pos, QID, SInit, SEnd, DOW, TOD, Day);
CREATE TABLE IF NOT EXISTS TollHistory AS SELECT cast(C1 AS int) AS VID, cast(C2 AS int) AS Day, cast(C3 AS int) AS XWay, cast(C4 AS int) AS Toll FROM (file '/path/to/historical-tolls.csv');
CREATE INDEX IF NOT EXISTS TollHistoryIndex ON TollHistory(VID);

-----------------------------
-- Variables
-----------------------------
-- AllSeg contains 2 highways curently. Use makeAllSeg.sh to generate more highways.

CREATE TABLE IF NOT EXISTS AllSeg AS SELECT cast(C1 AS int) AS XWay, cast(C2 AS int) AS Dir, cast(C3 AS int) AS Seg FROM (file '/path/to/AllSeg.csv');
CREATE INDEX IF NOT EXISTS AllSegIndex ON AllSeg(XWay, Dir, Seg);
CREATE TABLE IF NOT EXISTS Variables(Name TEXT PRIMARY KEY, Value int);
INSERT OR REPLACE INTO Variables Values('CurrentSecond', 0);

-----------------------------
-- Reports of different Type
-----------------------------
--
-- Stream of Linear Road Benchmark input tuples read from csv data file.

DROP VIEW IF EXISTS Reports;
CREATE VIEW Reports AS SELECT * FROM Source WHERE Time = (SELECT Value FROM Variables WHERE Name = 'CurrentSecond');

-- External
-- CREATE VIEW Reports AS SELECT * FROM (file 'http://sun05.pool.ifis.uni-luebeck.de:9090/streamqueryresult/Datafeeder?last=1' dialect:json);

-----------------------------
-- Linear Road Benchmark Input Queries
-----------------------------

-----------------------------
-- AccBalQueryStr Type2
-----------------------------
--
-- Stream of account-balance adhoc queries. Each query requests the current account balance of a car.

DROP VIEW IF EXISTS AccBalQueryStr;
CREATE VIEW AccBalQueryStr AS SELECT Time, VID, QID FROM Reports WHERE Type = 2;

-----------------------------
-- ExpQueryStr Type3
-----------------------------
--
-- Stream of adhoc queries requesting the expenditure of a car for the current day.

DROP VIEW IF EXISTS ExpQueryStr;
CREATE VIEW ExpQueryStr AS SELECT Time, VID, QID, Day FROM Reports WHERE Type = 3;

-----------------------------
-- TravelTimeQueryStr Type4
-----------------------------
--
-- Stream of expected-travel-time adhoc queries.

DROP VIEW IF EXISTS TravelTimeQueryStr;
CREATE VIEW TravelTimeQueryStr AS SELECT Time, VID, QID, XWay, SInit, SEnd, DOW, TOD FROM Reports WHERE Type = 4;

----------------------------------------------------------------
-- Linear Road Benchmark - Logic
----------------------------------------------------------------

-----------------------------
-- SegAvgSpeed
-----------------------------
--
-- The average speed of the cars in a Segment over the last 5 minutes.

DROP TABLE IF EXISTS SegAvgSpeed;
CREATE TABLE SegAvgSpeed(XWay int, Dir int, Seg int, LAV int);
CREATE UNIQUE INDEX IF NOT EXISTS SegAvgSpeedIndex ON SegAvgSpeed(XWay, Dir, Seg);

-----------------------------
-- SegVol
-----------------------------
--
-- Relation containing the number of cars currently in a Segment.

DROP TABLE IF EXISTS SegVol;
CREATE TABLE SegVol(XWay int, Dir int, Seg int, Volume int);
CREATE UNIQUE INDEX IF NOT EXISTS SegVolIndex ON SegVol(XWay, Dir, Seg);

----------------------------------------------------------------
-- Accident Detection and Notification
--
-- An accident has occurred if a car reports the same location four consecutive times.
-- When an accident is detected by the system,
-- all the cars in 5 upstream Segments have to be notified of the accident.
----------------------------------------------------------------

-----------------------------
-- StoppedCars
-----------------------------
--
-- Relation containing cars currently stoped at the highway.
-- Count is incremented for each subsequent position report form the same position.

DROP TABLE IF EXISTS StoppedCars;
CREATE TABLE StoppedCars(VID int PRIMARY KEY, COUNT int, XWay int, Dir int, Seg int, Lane int, Pos int, Time int);
CREATE INDEX IF NOT EXISTS StoppedCarsIndex ON StoppedCars(VID, XWay, Dir, Seg, Lane, Pos, Time);

-----------------------------
-- AccSeg
-----------------------------
--
-- Relation containing the set of segments involved in an accident at the current timestamp.
-- This relation is obtained by joining StoppedCars with itself.

DROP VIEW IF EXISTS AccSeg;
CREATE VIEW AccSeg AS SELECT S1.XWay, S1.Dir, S1.Seg, min(S1.Time) AS Time1, max(S2.Time) AS Time2 FROM StoppedCars S1, StoppedCars S2 WHERE
S1.VID <> S2.VID AND S1.XWay = S2.XWay AND S1.Dir = S2.Dir AND S1.Seg = S2.Seg AND S1.Lane = S2.Lane AND S1.Pos = S2.Pos AND
S1.Count > 4 AND (S2.Count > 4  OR (S2.Count = 4 AND EXISTS (SELECT S.VID FROM Source S WHERE S.VID = S2.VID AND S.Time = S2.Time + 30 AND
S.Type = 0 and S.Spd = 0 AND S2.XWay = S.XWay AND S2.Dir = S.Dir AND S2.Seg = S.Seg AND S2.Lane = S.Lane AND S2.Pos = S.Pos)))
GROUP BY S1.XWay, S1.Dir, S1.Seg;

-----------------------------
-- Accident
-----------------------------
--
-- Relation containing all accidents happend at any time point.
-- MinuteStart - MinuteEnd is the time frame in which die accident is present.

DROP TABLE IF EXISTS Accidents;
CREATE TABLE Accidents(XWay int, Dir int, Seg int, MinuteStart int, MinuteEnd int);
CREATE UNIQUE INDEX IF NOT EXISTS UniqueAccidents ON Accidents(XWay, Dir, Seg);

-----------------------------
-- AccAffectedSeg
-----------------------------
--
-- Relation of Segments not tolled due to accidents (see SegToll relation). 0-4 upstream Segments of an accident degment
-- are not tolled until the accident is cleared.

DROP TABLE IF EXISTS AccAffectedSeg;
CREATE TABLE AccAffectedSeg(XWay int, Dir int, Seg int);
CREATE UNIQUE INDEX IF NOT EXISTS AccAffectedSegIndex ON AccAffectedSeg(XWay, Dir, Seg);

-----------------------------
-- SegToll
-----------------------------
--
-- Relation containing the toll for each Segment. There are no entries in the relation for segments having no toll.
-- A Segment is tolled only if the average speed of the Segment is less than 40, and if it is not affected by an accident
-- (represented here by the relation AccAffectedSeg). If a Segment is tolled, its toll is
-- 2 * (#cars - 150) * (#cars - 150).

DROP TABLE IF EXISTS SegToll;
CREATE TABLE SegToll(XWay int, Dir int, Seg int, Toll int, LAV int, Volume int);
CREATE UNIQUE INDEX IF NOT EXISTS SegTollIndex ON SegToll(XWay, Dir, Seg);

-----------------------------
-- InformedCars
-----------------------------
--
-- Relation containing cars on segments that have already been informed of the toll for that segment.
-- A Car is only informed once per segment about tolls.

DROP TABLE IF EXISTS InformedCars;
CREATE TABLE InformedCars(VID int, XWay int, Dir int, Seg int);
CREATE INDEX IF NOT EXISTS InformedCarsIndex ON InformedCars(VID, XWay, Dir, Seg);
CREATE UNIQUE INDEX IF NOT EXISTS InformedCarsUIndex ON InformedCars(VID);

----------------------------------------------------------------
-- Linear Road Benchmark - Output Streams
----------------------------------------------------------------

-----------------------------
-- AccNotifyStr OUTPUT 1
-----------------------------
--
-- Output stream notifying an accident to cars currently in the upstream 5 Segments from the accident segment.

DROP VIEW IF EXISTS AccNotifyStr;
CREATE VIEW AccNotifyStr AS SELECT 1, R.Time, R.VID, A.Seg AS AccSeg, R.XWay, R.Dir, R.Seg, R.Lane FROM Accidents A, Reports R WHERE R.Type = 0 AND
((A.XWay = R.XWay AND A.Dir = 0 AND R.Dir = 0 AND R.Seg <= A.Seg AND R.Seg > A.Seg - 5) OR
(A.XWay = R.XWay AND A.Dir = 1 AND R.Dir = 1 AND R.Seg >= A.Seg AND R.Seg < A.Seg + 5)) AND
R.Lane <> 4 AND cast(R.Time/60 as int) <= A.MinuteEnd AND cast(R.Time/60 as int) >= A.MinuteStart AND
R.VID NOT IN (SELECT S.VID FROM Source S WHERE Type = 0 AND Time = (SELECT Value FROM Variables WHERE Name = 'CurrentSecond') - 30 AND S.VID = R.VID AND S.XWay = R.XWay AND S.Dir = R.Dir AND S.Seg = R.Seg );

-----------------------------
-- TollStr OUTPUT 0
-----------------------------
--
-- Stream of tolls. This is one of the output streams of the benchmark. Each car, on entering a segment,
-- pays a toll determined by the current state of traffic in the segment. The formulation of TollStr
-- below uses a relation SegToll, that contains the current toll for each segment.

DROP VIEW IF EXISTS TollStr;
CREATE VIEW TollStr AS SELECT S.VID, S.Time, ifnull(T.LAV,0) AS AvgSpd, ifnull(T.Toll,0) AS Toll, S.XWay, S.Dir, S.Seg, S.Day FROM Reports S LEFT JOIN SegToll T ON S.XWay = T.XWay AND S.Dir = T.Dir AND S.Seg = T.Seg
WHERE NOT EXISTS (SELECT 1 FROM InformedCars I WHERE S.VID = I.VID AND S.XWay = I.XWay AND S.Dir = I.Dir AND S.Seg = I.Seg)
AND S.Lane <> 4 AND S.Type = 0;

-----------------------------
-- AccBalOutStr OUTPUT 2
-----------------------------
--
-- Output stream of account balance queries.

DROP VIEW IF EXISTS AccBalOutStr;
CREATE VIEW AccBalOutStr AS SELECT max(Q.Time) AS Time, max(Q.QID) AS QID, SUM(T.Toll) AS Bal FROM AccBalQueryStr Q
INNER JOIN TollHistory T ON Q.VID = T.VID GROUP BY T.VID;

-----------------------------
-- ExpOutStr OUTPUT 3
-----------------------------
--
-- Output stream of current-day-expenditure adhoc queries.

DROP VIEW IF EXISTS ExpOutStr;
CREATE VIEW ExpOutStr AS SELECT E.Time, E.QID, ifnull(sum(T.Toll),0) as Bal FROM ExpQueryStr E LEFT JOIN TollHistory T ON
E.VID = T.VID AND E.Day = T.Day GROUP BY E.VID, E.Day;

-----------------------------
-- TravelTimeOutStr OUTPUT 4
-----------------------------
--
-- Output stream of travel-time-estimate adhoc queries.
-- As with all other LRB implementations, this stream is not implemented yet.

-----------------------------
-- Benchmark Execution
-----------------------------
--
-- OUTPUT file:bal.csv delimiter:, select 2, Time, cast(Emit AS int) AS Emit, QID, Bal, 0 AS ResultTime FROM (lrb start:0 end:1999 SELECT * FROM AccBalOutStr);
-- OUTPUT file:accalert.csv delimiter:, SELECT 1, Time, Emit, VID, AccSeg FROM (lrb start:0 end:10784 SELECT * FROM AccNotifyStr);
-- OUTPUT file:tollalert.csv delimiter:, SELECT 0, VID, Time, Emit, AvgSpd as Spd, Toll FROM (lrb start:0 end:10784 SELECT * FROM TollStr);
-- OUTPUT file:daily.csv delimiter:, SELECT 3, Time, Emit, QID, Bal FROM (lrb start:0 end:10784 SELECT * FROM ExpOutStr);
-- OUTPUT file:measurementToll.csv delimiter:, SELECT Time, Emit-Time AS Delay, NumCars FROM (lrb start:0 end:10 SELECT VID, Time, Count(DISTINCT VID) AS NumCars FROM TollStr);
-- OUTPUT file:tollalert.csv delimiter:, SELECT Time, Emit-Time AS Delay, NumCars FROM (lrb start:0 end:10784 SELECT wid as Time, Count(DISTINCT _VID) AS NumCars FROM TollStr_having);
-- OUTPUT file:featuresWidth4.csv delimiter:, SELECT Time, ifnull(Emit-Time,0) AS Delay, NumCars FROM (lrb start:0 end:10784 SELECT _vid AS VID, wid AS Time, Count(DISTINCT _vid) AS NumCars FROM FinalTolls_having);

-----------------------------
-- Static Cars Binary Experiment
-----------------------------
DROP TABLE IF EXISTS Cars;
CREATE TABLE Cars(VID int, CarLeafType text);
CREATE INDEX IF NOT EXISTS CarsIndex ON Cars(VID, CarLeafType);
-- Depth 3
INSERT INTO Cars SELECT VID, 'Car' || cast((VID % 8) + 401 AS text) AS CarLeafType FROM (SELECT DISTINCT VID FROM Source);
-- Depth 4
INSERT INTO Cars SELECT VID, 'Car' || cast((VID % 16) + 501 AS text) AS CarLeafType FROM (SELECT DISTINCT VID FROM Source);
-- Depth 5
INSERT INTO Cars SELECT VID, 'Car' || cast((VID % 32) + 601 AS text) AS CarLeafType FROM (SELECT DISTINCT VID FROM Source);
-- Depth 7
INSERT INTO Cars SELECT VID, 'Car' || cast((VID % 128) + 801 AS text) AS CarLeafType FROM (SELECT DISTINCT VID FROM Source);
-- Depth 8
INSERT INTO Cars SELECT VID, 'Car' || cast((VID % 256) + 901 AS text) AS CarLeafType FROM (SELECT DISTINCT VID FROM Source);
-- Depth 9
INSERT INTO Cars SELECT VID, 'Car' || cast((VID % 512) + 1001 AS text) AS CarLeafType FROM (SELECT DISTINCT VID FROM Source);

-----------------------------
-- Static Cars Exponential Experiment
-----------------------------
-- Depth 2
INSERT INTO Cars SELECT VID, 'Car' || cast((VID % 8) + 301 AS text) AS CarLeafType FROM (SELECT DISTINCT VID FROM Source);
-- Depth 3 - 8 * 8 = 64
INSERT INTO Cars SELECT VID, 'Car' || cast((VID % 64) + 401 AS text) AS CarLeafType FROM (SELECT DISTINCT VID FROM Source);
-- Depth 4 - 64 * 16 = 1024
INSERT INTO Cars SELECT VID, 'Car' || cast((VID % 1024) + 501 AS text) AS CarLeafType FROM (SELECT DISTINCT VID FROM Source);
-- Depth 5 - 1024 * 32 = 32768
INSERT INTO Cars SELECT VID, 'Car' || cast((VID % 32768) + 601 AS text) AS CarLeafType FROM (SELECT DISTINCT VID FROM Source);


-----------------------------
-- Feature Experiment
-----------------------------
DROP TABLE IF EXISTS Car;
CREATE TABLE Car(VID int, Cartype int);
CREATE INDEX CarIndex ON Car(VID, Cartype);

-- n = 1: 4^1 = 4
INSERT INTO Car SELECT VID, VID % 4 FROM (SELECT DISTINCT VID FROM Source);
-- n = 2: 4^2 = 16
INSERT INTO Car SELECT VID, VID % 16 FROM (SELECT DISTINCT VID FROM Source);
-- n = 3: 4^3 = 64
INSERT INTO Car SELECT VID, VID % 64 FROM (SELECT DISTINCT VID FROM Source);
-- n = 4: 4^4 = 256
INSERT INTO Car SELECT VID, VID % 256 FROM (SELECT DISTINCT VID FROM Source);
-- n = 5: 4^5 = 1024
INSERT INTO Car SELECT VID, VID % 1024 FROM (SELECT DISTINCT VID FROM Source);


CREATE VIEW Type2Feature AS
SELECT Cartype, 0 AS Subfeature FROM (SELECT DISTINCT Cartype FROM Car WHERE (Cartype & 1) = 1 ORDER BY Cartype)
UNION
SELECT Cartype, 1 AS Subfeature FROM (SELECT DISTINCT Cartype FROM Car WHERE (Cartype & 2) = 2 ORDER BY Cartype)
UNION
SELECT Cartype, 2 AS Subfeature FROM (SELECT DISTINCT Cartype FROM Car WHERE (Cartype & 4) = 4 ORDER BY Cartype)
UNION
SELECT Cartype, 3 AS Subfeature FROM (SELECT DISTINCT Cartype FROM Car WHERE (Cartype & 8) = 8 ORDER BY Cartype)
UNION
SELECT Cartype, 4 AS Subfeature FROM (SELECT DISTINCT Cartype FROM Car WHERE (Cartype & 16) = 16 ORDER BY Cartype)
UNION
SELECT Cartype, 5 AS Subfeature FROM (SELECT DISTINCT Cartype FROM Car WHERE (Cartype & 32) = 32 ORDER BY Cartype)
UNION
SELECT Cartype, 6 AS Subfeature FROM (SELECT DISTINCT Cartype FROM Car WHERE (Cartype & 64) = 64 ORDER BY Cartype)
UNION
SELECT Cartype, 7 AS Subfeature FROM (SELECT DISTINCT Cartype FROM Car WHERE (Cartype & 128) = 128 ORDER BY Cartype);
