# OntLRB Benchmark

The linear road benchmark LRB is a well documented test suit for relational
data stream systems in a configurable trafic scenario. This work
describes an extension of LRB, called OntLRB, which aims at making
the classical LRB available for the semantically enhanced stream-engines
community. OntLRB extends LRB with additional benchmarking aspects
regarding the semantics of the data, in particular aspects related
to inference and, further, reasoning in the ontology-based data access
paradigm (OBDA).


## Running the Benchmark

### Open the Exareme terminal
```bash
python exareme/lib/madis/src/mterm.py my.db
```
### Import the LRB data
Run the queries found in *lrb.sql* in the folder **LRB-for-ExaSteam**.


### Run the classic benchmark
```sql
OUTPUT file:bal.csv delimiter:, select 2, Time, cast(Emit AS int) AS Emit, QID, Bal, 0 AS ResultTime FROM (lrb start:0 end:1999 SELECT * FROM AccBalOutStr);

OUTPUT file:accalert.csv delimiter:, SELECT 1, Time, Emit, VID, AccSeg FROM (lrb start:0 end:10784 SELECT * FROM AccNotifyStr);

OUTPUT file:tollalert.csv delimiter:, SELECT 0, VID, Time, Emit, AvgSpd as Spd, Toll FROM (lrb start:0 end:10784 SELECT * FROM TollStr);
```
