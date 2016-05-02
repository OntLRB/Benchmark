## Linear Road Benchmark for ExaStream
-----------
File | Usage
-----|--------
lrb.py| This is the ExaStream User Defined Function (UDF) used to run the benchmark. This operator needs to be imported to Exareme and placed in the folder *functions/vtable*.
lrb.sql| These are the classic LRB queries tailored to perfectly integrate with the stream processor Exareme. Execute them in Exarem/Madis terminal to have them available for the benchmark.
AllSeg.csv | This file currently contains segment data for 2 express ways. Use *makeAllSeg.sh* to create data for more.
makeAllSeg.sh | ```./makeAllSeg.sh 3 > segmentsFor3expressways.csv``` creates segment data for up to 3 express ways.
