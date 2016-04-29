-----------------------------
-- Linear Road Benchmark Queries
-----------------------------
--
-- This is the LRB schema file for PostgreSQL.
-- The schema is used by the STARQL-Transformator.

-----------------------------
-- 1 Highway Data Source
-----------------------------
CREATE TABLE IF NOT EXISTS Source (Type int, Time int, VID int, Spd int, XWay int, Lane int, Dir int, Seg int, Pos int, QID int, SInit int, SEnd int, DOW int, TOD int, Day int);
CREATE INDEX SourceIndex ON Source(Type, Time, VID, Spd, XWay, Lane, Dir, Seg, Pos, QID, SInit, SEnd, DOW, TOD, Day);
CREATE TABLE IF NOT EXISTS TollHistory (VID int, Day int, XWay int, Toll int);
CREATE INDEX TollHistoryIndex ON TollHistory(VID);

-----------------------------
-- Variables
-----------------------------
-- AllSeg contains 2 highways curently. Use makeAllSeg.sh to generate more highways.

CREATE TABLE IF NOT EXISTS AllSeg (XWay int, Dir int, Seg int);
CREATE INDEX AllSegIndex ON AllSeg(XWay, Dir, Seg);
CREATE TABLE IF NOT EXISTS Variables(Name TEXT PRIMARY KEY, Value int);

-----------------------------
-- Reports of different Type
-----------------------------
--
-- Stream of Linear Road Benchmark input tuples read from csv data file.

DROP VIEW IF EXISTS Reports;
CREATE VIEW Reports AS SELECT * FROM Source WHERE Time = (SELECT Value FROM Variables WHERE Name = 'CurrentSecond');

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
CREATE UNIQUE INDEX SegAvgSpeedIndex ON SegAvgSpeed(XWay, Dir, Seg);

-----------------------------
-- SegVol
-----------------------------
--
-- Relation containing the number of cars currently in a Segment.

DROP TABLE IF EXISTS SegVol;
CREATE TABLE SegVol(XWay int, Dir int, Seg int, Volume int);
CREATE UNIQUE INDEX SegVolIndex ON SegVol(XWay, Dir, Seg);

----------------------------------------------------------------
-- Accident Detection and Notification
--
-- An accident has occurred if a car reports the same location four consecutive times. 
-- When an accident is detected by the system, 
-- all the cars in 5 upstream Segments have to be notified of the accident.
----------------------------------------------------------------

-----------------------------
-- StopedCars
-----------------------------
--
-- Relation containing cars currently stoped at the highway. 
-- Count is incremented for each subsequent position report form the same position.

DROP TABLE IF EXISTS StopedCars;
CREATE TABLE StopedCars(VID int PRIMARY KEY, COUNT int, XWay int, Dir int, Seg int, Lane int, Pos int, Time int);
CREATE INDEX StopedCarsIndex ON StopedCars(VID, XWay, Dir, Seg, Lane, Pos, Time);

-----------------------------
-- AccSeg
-----------------------------
--
-- Relation containing the set of segments involved in an accident at the current timestamp.
-- This relation is obtained by joining StopedCars with itself.

DROP VIEW IF EXISTS AccSeg;
CREATE VIEW AccSeg AS SELECT S1.XWay, S1.Dir, S1.Seg, min(S1.Time) AS Time1, max(S2.Time) AS Time2 FROM StopedCars S1, StopedCars S2 WHERE 
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
CREATE UNIQUE INDEX UniqueAccidents ON Accidents(XWay, Dir, Seg);

-----------------------------
-- AccAffectedSeg
-----------------------------
--
-- Relation of Segments not tolled due to accidents (see SegToll relation). 0-4 upstream Segments of an accident degment
-- are not tolled until the accident is cleared.

DROP TABLE IF EXISTS AccAffectedSeg;
CREATE TABLE AccAffectedSeg(XWay int, Dir int, Seg int);
CREATE UNIQUE INDEX AccAffectedSegIndex ON AccAffectedSeg(XWay, Dir, Seg);

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
CREATE UNIQUE INDEX SegTollIndex ON SegToll(XWay, Dir, Seg);

-----------------------------
-- InformedCars
-----------------------------
--
-- Relation containing cars on segments that have already been informed of the toll for that segment.
-- A Car is only informed once per segment about tolls.

DROP TABLE IF EXISTS InformedCars;
CREATE TABLE InformedCars(VID int, XWay int, Dir int, Seg int);
CREATE INDEX InformedCarsIndex ON InformedCars(VID, XWay, Dir, Seg);
CREATE UNIQUE INDEX InformedCarsUIndex ON InformedCars(VID);

----------------------------------------------------------------
-- Linear Road Benchmark - Output Streams
----------------------------------------------------------------

-----------------------------
-- AccNotifyStr OUTPUT 1
-----------------------------
--
-- Output stream notifying an accident to cars currently in the upstream 5 Segments from the accident segment. 

DROP VIEW IF EXISTS AccNotifyStr;
CREATE VIEW AccNotifyStr AS SELECT 1, S.Time, S.VID, A.Seg AS AccSeg, S.XWay, S.Dir, S.Seg, S.Lane FROM Accidents A, Reports S WHERE S.Type = 0 AND
((A.XWay = S.XWay AND A.Dir = 0 AND S.Dir = 0 AND S.Seg <= A.Seg AND S.Seg > A.Seg - 5) OR 
(A.XWay = S.XWay AND A.Dir = 1 AND S.Dir = 1 AND S.Seg >= A.Seg AND S.Seg < A.Seg + 5)) AND
S.Lane <> 4 AND cast(S.Time/60 as int) <= A.MinuteEnd AND cast(S.Time/60 as int) >= A.MinuteStart AND
S.VID NOT IN (SELECT R.VID FROM Reports R WHERE Type = 0 AND Time = (SELECT Value FROM Variables WHERE Name = 'CurrentSecond') - 30 AND S.VID = R.VID AND S.XWay = R.XWay AND S.Dir = R.Dir AND S.Seg = R.Seg );

-----------------------------
-- TollStr OUTPUT 0
-----------------------------
--
-- Stream of tolls. This is one of the output streams of the benchmark. Each car, on entering a segment,
-- pays a toll determined by the current state of traffic in the segment. The formulation of TollStr 
-- below uses a relation SegToll, that contains the current toll for each segment.

DROP VIEW IF EXISTS TollStr;
CREATE VIEW TollStr AS SELECT S.VID, S.Time, COALESCE(T.LAV,0) AS AvgSpd, COALESCE(T.Toll,0) AS Toll, S.XWay, S.Dir, S.Seg, S.Day FROM Reports S LEFT JOIN SegToll T ON S.XWay = T.XWay AND S.Dir = T.Dir AND S.Seg = T.Seg
WHERE NOT EXISTS (SELECT 1 FROM InformedCars I WHERE S.VID = I.VID AND S.XWay = I.XWay AND S.Dir = I.Dir AND S.Seg = I.Seg)
AND S.Lane <> 4 AND S.Type = 0;

-----------------------------
-- AccBalOutStr OUTPUT 2
-----------------------------
--
-- Output stream of account balance queries.

DROP VIEW IF EXISTS AccBalOutStr;
CREATE VIEW AccBalOutStr AS SELECT max(Q.Time) AS Time, max(Q.QID) AS QID, SUM(T.Toll) AS Bal FROM AccBalQueryStr Q 
INNER JOIN TollHistory T ON Q.VID = T.VID GROUP BY Q.VID;

-----------------------------
-- ExpOutStr OUTPUT 3
-----------------------------
--
-- Output stream of current-day-expenditure adhoc queries.

DROP VIEW IF EXISTS ExpOutStr;
CREATE VIEW ExpOutStr AS SELECT max(E.Time) AS Time, max(E.QID) AS QID, SUM(T.Toll) AS Toll FROM ExpQueryStr E, TollHistory T WHERE
E.VID = T.VID AND E.Day = T.Day;

-----------------------------
-- TravelTimeOutStr OUTPUT 4
-----------------------------
--
-- Output stream of travel-time-estimate adhoc queries.
-- As with all other LRB implementations, this stream is not implemented yet.