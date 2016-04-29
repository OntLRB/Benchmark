# OntLRB Benchmark

This is the OntLRB benchmark

## Installation instruction

This is how you install it

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
