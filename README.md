# OntLRB Benchmark

The Linear Road Benchmark LRB is a well documented test suit for relational
data stream systems in a configurable traffic scenario. This work
describes an extension of LRB, called OntLRB, which aims at making
the classical LRB available for the semantically enhanced stream-engines
community. OntLRB extends LRB with additional benchmarking aspects
regarding the semantics of the data, in particular aspects related
to inference and, further, reasoning in the ontology-based data access
paradigm (OBDA).


## Preparation for Exareme
We provide a proof-of-concept implementation of OntLRB for the distributed data
stream management system [ExaStream](http://www.exareme.org).

### Open the Exareme terminal
```bash
python exareme/lib/madis/src/mterm.py my.db
```
### Import the LRB data
Use the [LRB data generator](http://www.cs.brandeis.edu/~linearroad/tools.html) to
create historical tolls and cardatapoints. To skip this step, Uppala University
provides these files for one express way [here](http://udbl2.it.uu.se/LR/). Secondly,
use the script *makeAllSeg.sh* to generate segment for any number of expressways.
The file AllSeg.csv has data for two expressways by now.
Thirdly, adjust the queries found in *lrb.sql* in the folder **LRB-for-ExaSteam**
to your environment. Update paths to point to your car data files.
Run the LRB queries in the Madis/Exareme terminal.


### Run the classic Linear Road Benchmark
```sql
OUTPUT file:bal.csv delimiter:, select 2, Time, cast(Emit AS int) AS Emit, QID, Bal, 0 AS ResultTime
FROM (lrb start:0 end:10784 SELECT * FROM AccBalOutStr);

OUTPUT file:accalert.csv delimiter:, SELECT 1, Time, Emit, VID, AccSeg FROM (lrb start:0 end:10784
SELECT * FROM AccNotifyStr);

OUTPUT file:tollalert.csv delimiter:, SELECT 0, VID, Time, Emit, AvgSpd as Spd, Toll FROM
(lrb start:0 end:10784 SELECT * FROM TollStr);
```
The generated output files can be validated with the validator from [LRB](http://www.cs.brandeis.edu/~linearroad/tools.html).

### Run an ontology extended benchmark
Unfold a query from STARQL to ExaStream. For example:
```java
StarqlToExaStream.jar featureQuery.txt ExaStreamResult.txt
Ontologies/featuresWidth4.owl Mappings/featuresWidth4.obda
```
Run the queries found in ExaStreamResult.txt in the Madis/Exareme terminal.
On successful execution, run the actual benchmark with such a command:
```sql
OUTPUT file:featuresWidth4.csv delimiter:, SELECT Time, ifnull(Emit-Time,0) AS Delay,
NumCars FROM (lrb start:0 end:10784 SELECT _vid AS VID, wid AS Time,
Count(DISTINCT _vid) AS NumCars FROM FinalTolls_having);
```

The file *featuresWidth4.csv* is filled with tuples of the form ```(time, delay, # of toll notifications)```. This data can be used for evaluation.
