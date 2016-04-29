"""
Linear Road Benchmark
Usage: lrb start:0 end:10784 SELECT * FROM TollStr;
This is a customized version of the UDF operator "repeat"

Examples::
mterm> lrb start:0 end:4 select 1+1;
2
2
2
2
2
--- [0|Column names ---
[1|1+1 
Query executed and displayed 5 rows in 0 min. 4 sec 759 msec.

lrb start:0 end:1 pre_query:insert_into_test_values('foo',12) select * from test;


"""
import setpath
import vtbase
import functions
import gc
import time

### Classic stream iterator
registered=True
       
class Ordered(vtbase.VT):
    def BestIndex(self, constraints, orderbys):
        return (None, 0, None, True, 1000)

    def VTiter(self, *parsedArgs,**envars):
        largs, dictargs = self.full_parse(parsedArgs)
        #print parsedArgs
        if 'query' not in dictargs:
            raise functions.OperatorError(__name__.rsplit('.')[-1],"No query argument ")
        query = dictargs['query']
        if 'pre_query' in dictargs:
            pre_query = dictargs['pre_query'].replace('_',' ').replace('|',';')
            print "pre query: " + pre_query
        else:
            pre_query = None
        if 'post_query' in dictargs:
            post_query = dictargs['post_query'].replace('_',' ').replace('|',';')
        else:
            post_query = None
        start=int(dictargs['start'])
        end=int(dictargs['end'])
        cur = envars['db'].cursor()
        initial_cleanup(cur)
        headerPrinted = False
        # Repeat n time
        for x in xrange(start, end + 1):
            iteration = str(x)
            t = time.time();
            print "Current iteration: " + iteration
            queryTimed = query
            if pre_query is not None:
                pre_queryTimed = pre_query
            else:
                pre_queryTimed = None
            if post_query is not None:
                post_queryTimed = post_query
            else:
                post_queryTimed = None
            # Execute Queries
            result = execute_query(queryTimed,pre_queryTimed,post_queryTimed,cur,iteration,x)
            if not(headerPrinted):
                header = result[0]
                yield header + [('Emit',)]
                headerPrinted = True
            # Print all tuples of current iteration
            for tupl in result[1]:
                yield tupl + (x + time.time() - t,) # Emit Column
            #time.sleep(.99)

def execute_query(query,pre_query,post_query,cur,currentIteration,x):
    # Execute pre_query initially
    cur.execute("INSERT OR REPLACE INTO Variables Values('CurrentSecond',"+currentIteration+")", parse=False)
    #cur.execute("INSERT INTO TollHistory SELECT VID, Day, XWay, Toll FROM TollStr WHERE Toll <> 0 AND Day <> -1", parse=False)
    # Accident Alerts
    cur.execute("INSERT OR REPLACE INTO StoppedCars SELECT S.VID, ifnull((SELECT Count + 1 FROM StoppedCars I WHERE I.VID = S.VID AND S.Pos = I.Pos),1), S.XWay, S.Dir, S.Seg, S.Lane, S.Pos, S.Time FROM Source S WHERE Spd = 0 AND Time = "+currentIteration+" AND Type = 0 GROUP BY VID", parse=False)
    cur.execute("DELETE FROM StoppedCars WHERE VID IN (SELECT VID FROM Reports WHERE Spd > 0 AND Type = 0 GROUP BY VID)", parse=False)
    cur.execute("INSERT OR REPLACE INTO Accidents SELECT A.XWay, A.Dir, A.Seg, ifnull((SELECT MinuteStart FROM Accidents O WHERE A.XWay = O.XWay AND A.Dir = O.Dir AND A.Seg = O.Seg), cast(min(A.Time2,A.Time1)/60 as INTEGER)+1) AS MinuteStart, cast(max(A.Time2,A.Time1)/60 AS INTEGER) +1 AS MinuteEnd FROM AccSeg A GROUP BY A.XWay, A.Dir, A.Seg", parse=False)
    # Toll Alerts
    if x > 0 and x % 60 == 0:
        cur.execute("DELETE FROM SegVol; DELETE FROM SegAvgSpeed; DELETE FROM SegToll; DELETE FROM AccAffectedSeg;")
        cur.execute("INSERT OR REPLACE INTO SegAvgSpeed SELECT XWay, Dir, Seg, CASE WHEN "+currentIteration+""" < 60 THEN 0 ELSE cast(avg(MinuteSpd) AS INTEGER) END AS LAV FROM ( 
            SELECT XWay, Dir, Seg, avg(CarAvgSpdPerMinute) AS MinuteSpd, Minute FROM (
                SELECT XWay, Dir, Seg, avg(Spd) AS CarAvgSpdPerMinute, cast(Time/60 AS INTEGER)+1 AS Minute FROM Source WHERE Type = 0 AND Time BETWEEN """+str(x/60 * 60 - 300)+" AND "+str(x/60 * 60 - 1)+""" GROUP BY XWay, Dir, Seg, VID, Minute
                ) GROUP BY XWay, Dir, Seg, Minute
            ) GROUP BY XWay, Dir, Seg;""", parse=False)
        cur.execute("INSERT OR REPLACE INTO SegVol SELECT XWay, Dir, Seg, COUNT(DISTINCT VID) as Volume FROM Source WHERE Time BETWEEN "+str(x/60 * 60 - 60)+" AND "+ str(x/60 * 60 -1) +" GROUP BY XWay, Dir, Seg", parse=False)
        cur.execute("INSERT OR REPLACE INTO AccAffectedSeg SELECT S.XWay, S.Dir, S.Seg FROM AllSeg S, Accidents A WHERE ((S.XWay = A.XWay AND S.Dir = 0 AND A.Dir = 0 AND S.Seg <= A.Seg AND S.Seg + 4 >= A.Seg) OR (S.XWay = A.XWay AND S.Dir = 1 AND A.Dir = 1 AND S.Seg >= A.Seg AND S.Seg - 4 <= A.Seg )) AND A.MinuteStart + 1 <= "+str(x/60 + 1)+" AND A.MinuteEnd + 1 >= "+str(x/60 + 1), parse=False)
        cur.execute("INSERT OR REPLACE INTO SegToll SELECT S.XWay, S.Dir, S.Seg, CASE WHEN "+currentIteration+" < 300 THEN 0 WHEN S.LAV >= 40 OR V.Volume <= 50 OR S.LAV = 0 THEN 0 WHEN (SELECT COUNT(*) FROM AccAffectedSeg A WHERE S.XWay = A.XWay AND S.Dir = A.Dir AND S.Seg = A.Seg) > 0 THEN 0 ELSE 2*(V.Volume-50)*(V.Volume-50) END AS Toll, S.LAV, V.Volume FROM SegAvgSpeed S LEFT JOIN SegVol V ON S.XWay = V.XWay AND S.Dir = V.Dir AND S.Seg = V.Seg;", parse=False)
    if pre_query is not None:
        cur.execute(pre_query, parse=False)
    tuples = []
    # Get header and all tuples of current iteration
    for row in cur.execute(query, parse=False):
        tuples.append(row)
    header = list(cur.getdescriptionsafe())
    # Execute post_query finally
    if post_query is not None:
        cur.execute(post_query, parse=False)

    cur.execute("INSERT OR REPLACE INTO InformedCars SELECT S.VID, S.XWay, S.Dir, S.Seg FROM Source S WHERE Time = "+currentIteration+" AND Type = 0", parse=False)
    return (header, tuples)

def initial_cleanup(cur):
    cur.execute("DELETE FROM StoppedCars; DELETE FROM Accidents; DELETE FROM SegAvgSpeed; DELETE FROM SegVol;")
    cur.execute("DELETE FROM AccAffectedSeg; DELETE FROM SegToll; DELETE FROM InformedCars;")

def Source():
    return vtbase.VTGenerator(Ordered)

if not ('.' in __name__):
    """
    This is needed to be able to test the function, put it at the end of every
    new function you create
    """
    import sys
    import setpath
    from functions import *
    testfunction()
    if __name__ == "__main__":
        reload(sys)
        sys.setdefaultencoding('utf-8')
        import doctest
        doctest.testmod()