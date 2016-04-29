CREATE TEMP VIEW TollStr_stream AS SELECT Time AS wid, 0 AS abox, * FROM TollStr;


CREATE TEMP VIEW FinalTolls_having AS
SELECT wid, (_Toll + 111) AS _FinalToll, _VID
FROM
 ( SELECT * FROM
	(
	 	(
			SELECT VID AS _VID FROM (
			SELECT DISTINCT 
			   1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || qview2."vid") AS "VID"
			 FROM 
			Type2Feature qview1,
			car qview2
			WHERE 
			(qview1."cartype" = qview2."cartype") AND
			((4 = qview1."subfeature") OR (5 = qview1."subfeature")) AND
			qview2."vid" IS NOT NULL
			) SUB_QVIEW
			
		) SUB_TRIPLE
		NATURAL JOIN
		(
			SELECT VID AS _VID FROM (
			SELECT DISTINCT 
			   1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || qview2."vid") AS "VID"
			 FROM 
			Type2Feature qview1,
			car qview2
			WHERE 
			(qview1."cartype" = qview2."cartype") AND
			((1 = qview1."subfeature") OR (0 = qview1."subfeature")) AND
			qview2."vid" IS NOT NULL
			) SUB_QVIEW
			
		) SUB_TRIPLE
		NATURAL JOIN
		(
			SELECT VID AS _VID FROM (
			SELECT DISTINCT 
			   1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || qview2."vid") AS "VID"
			 FROM 
			Type2Feature qview1,
			car qview2
			WHERE 
			(qview1."cartype" = qview2."cartype") AND
			((3 = qview1."subfeature") OR (2 = qview1."subfeature")) AND
			qview2."vid" IS NOT NULL
			) SUB_QVIEW
			
		) SUB_TRIPLE
	) SUB_WHERE
	NATURAL JOIN
	 (		SELECT wid, _Toll, _VID FROM(
				(
					SELECT wid, abox AS i, Toll AS _Toll, VID AS _VID FROM (
					SELECT DISTINCT wid, abox, 
					   4 AS "TollQuestType", NULL AS "TollLang", qview1."toll" AS "Toll", 
					   1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || qview1."vid") AS "VID"
					 FROM 
					TollStr_stream qview1
					WHERE 
					qview1."toll" IS NOT NULL AND
					qview1."vid" IS NOT NULL
					) SUB_QVIEW
					
				   ) SUB_TRIPLE0
			) SUB_QVIEW
	) SUB_HAVING
) SUB_FROM;




lrb start:0 end:3 SELECT * FROM FinalTolls_having;
SELECT * FROM  (newtimeslidingwindow timecolumn:0 timewindow:2 frequency:3 granularity:1 equivalence:floor SELECT * FROM (lrb start:0 end:6 select * from FinalTolls_having));