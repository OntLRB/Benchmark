CREATE TEMP VIEW TollStr_stream AS SELECT Time AS wid, 0 AS abox, * FROM TollStr;


CREATE TEMP VIEW FinalTollsA_having AS
SELECT wid, _FinalToll, _VID
FROM
 ( SELECT * FROM
    (
        (
            SELECT VID AS _VID FROM (
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car405') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car406') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car407') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car408') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car401') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car402') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car403') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car404') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car424') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car423') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car420') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car422') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car421') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car419') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car418') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car417') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car415') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car414') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car413') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car412') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car416') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car411') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car410') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car409') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car432') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car431') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car430') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car426') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car425') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car428') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car427') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car429') qview1
            WHERE 
            qview1.vid IS NOT NULL
            ) SUB_QVIEW
            
        ) SUB_TRIPLE
    ) SUB_WHERE
    NATURAL JOIN
     (      SELECT wid, _FinalToll, _VID FROM(
                (
                    SELECT wid, abox AS i, FinalToll AS _FinalToll, VID AS _VID FROM (
                    SELECT wid, abox, 
                       4 AS "FinalTollQuestType", NULL AS "FinalTollLang", CAST(qview1."toll" + 111 AS VARCHAR(10485760)) AS "FinalToll", 
                       1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1."vid" AS VARCHAR(10485760))) AS "VID"
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



CREATE TEMP VIEW FinalTollsB_having AS
SELECT wid, _FinalToll, _VID
FROM
 ( SELECT * FROM
    (
        (
            SELECT VID AS _VID FROM (
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car440') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car439') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car438') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car437') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car436') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car435') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car434') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car433') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car449') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car456') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car452') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car453') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car454') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car455') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car450') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car451') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car446') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car445') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car448') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car447') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car442') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car441') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car444') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car443') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car457') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car458') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car459') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car463') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car464') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car461') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car462') qview1
            WHERE 
            qview1.vid IS NOT NULL
            UNION
            SELECT 
               1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1.vid AS VARCHAR(10485760))) AS "VID"
             FROM 
            (SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = 'Car460') qview1
            WHERE 
            qview1.vid IS NOT NULL
            ) SUB_QVIEW
            
        ) SUB_TRIPLE
    ) SUB_WHERE
    NATURAL JOIN
     (      SELECT wid, _FinalToll, _VID FROM(
                (
                    SELECT wid, abox AS i, FinalToll AS _FinalToll, VID AS _VID FROM (
                    SELECT wid, abox, 
                       4 AS "FinalTollQuestType", NULL AS "FinalTollLang", CAST(qview1."toll" + 222 AS VARCHAR(10485760)) AS "FinalToll", 
                       1 AS "VIDQuestType", NULL AS "VIDLang", ('http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#' || CAST(qview1."vid" AS VARCHAR(10485760))) AS "VID"
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



CREATE TEMP VIEW FinalTolls_having AS
SELECT wid, _FinalToll, _VID
FROM
 ( SELECT * FROM
     (      SELECT wid, _FinalToll, _VID FROM(
                (
                    SELECT wid, _FinalToll, _VID
                    FROM FinalTollsA_having
                    UNION
                    SELECT wid, _FinalToll, _VID
                    FROM FinalTollsB_having
                   ) SUB_TRIPLE0
            ) SUB_QVIEW
    ) SUB_HAVING
) SUB_FROM;


lrb start:0 end:3 SELECT * FROM FinalTolls_having;
