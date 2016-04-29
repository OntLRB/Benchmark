#!/bin/bash

width=$1
prefix="Car"

read -r -d '' HEAD <<- EOM
[PrefixDeclaration]
:		http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#
lrb:		http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#
owl:		http://www.w3.org/2002/07/owl#
rdf:		http://www.w3.org/1999/02/22-rdf-syntax-ns#
uce:		http://www.siemens.com/Optique/UseCaseExample1#
xml:		http://www.w3.org/XML/1998/namespace#
xsd:		http://www.w3.org/2001/XMLSchema#
rdfs:		http://www.w3.org/2000/01/rdf-schema#

[SourceDeclaration]
sourceUri	UseCaseDB
connectionUrl	jdbc:postgresql://localhost:5432/lrb
username	postgres
password	postgres
driverClass	org.postgresql.Driver

[MappingDeclaration] @collection [[

mappingId	Mapping - hasToll
target		lrb:{VID} lrb:hasToll {Toll}. 
source		SELECT VID, Toll FROM TollStr
EOM
echo "$HEAD"
printf "\n"
for n in `seq 0 $(($width-1))`;
do
	leftSubFeature=$((2*n))
	rightSubFeature=$((leftSubFeature+1))
	lSF=SubFeature$leftSubFeature
	rSF=SubFeature$rightSubFeature
	printf "mappingId\tMapping - $lSF\n"
	printf "target\t\tlrb:{VID} a lrb:$lSF .\n"
	printf "source\t\tSELECT VID FROM Type2Feature F JOIN Car C ON F.Cartype = C.Cartype WHERE F.Subfeature = $(($leftSubFeature))\n\n"
	printf "mappingId\tMapping - $rSF\n"
	printf "target\t\tlrb:{VID} a lrb:$rSF .\n"
	printf "source\t\tSELECT VID FROM Type2Feature F JOIN Car C ON F.Cartype = C.Cartype WHERE F.Subfeature = $(($rightSubFeature))\n\n"
done
echo "]]"