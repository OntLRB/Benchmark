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
for feature in `seq 0 $(($width-1))`;
do
	leftSubFeature=$((2*feature))
	rightSubFeature=$((leftSubFeature+1))
	F=Feature$feature
	hasF=has$F
	lSF=SubFeature$leftSubFeature
	rSF=SubFeature$rightSubFeature
	subHasL=hasSubFeature$leftSubFeature
  subHasR=hasSubFeature$rightSubFeature
	printf "mappingId\tMapping - $hasF\n"
	printf "target\t\tlrb:{VID} :$hasF lrb:$F .\n"
	printf "source\t\tSELECT VID, $F FROM \"$hasF\"\n\n"
	printf "mappingId\tMapping - $subHasL\n"
	printf "target\t\tlrb:{$F} :$subHasL lrb:$lSF .\n"
	printf "source\t\tSELECT $F, $lSF FROM \"$subHasL\"\n\n"
	printf "mappingId\tMapping - $subHasR\n"
	printf "target\t\tlrb:{$F} :$subHasR lrb:$rSF .\n"
	printf "source\t\tSELECT $F, $rSF FROM \"$subHasR\"\n\n"
done
echo "]]"
