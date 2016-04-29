#!/bin/bash

level=$1
current_level=$2; current_level=${current_level:=1}
last_branch=$3;
parentClass=$4;
last_offset=$5;
prefix="Car"

# test to stop recursion
[[ $level -eq $(($current_level-1)) ]] && exit

# root
if [[ $current_level -eq 1 ]]; then
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

mappingId	Mapping - hasAToll
target		lrb:{VID} lrb:hasAToll {FinalToll}^^xsd:integer . 
source		SELECT VID, Toll + 111 AS FinalToll FROM TollStr

mappingId	Mapping - hasBToll
target		lrb:{VID} lrb:hasBToll {FinalToll}^^xsd:integer . 
source		SELECT VID, Toll + 222 AS FinalToll FROM TollStr
	EOM
	echo "$HEAD"
	echo ""
	$0 $level 2 1 1 0
	echo "]]"
else
	last_level=$(($current_level-1))
	children=$((2**$last_level))
	for branch in `seq 1 $children`;
    do
    	offset=$(($last_offset*children+branch-1))
    	#echo "l: $last_offset o: $offset"
        class=$(($current_level*100+$offset+1))
        if [[ $level -eq $(($current_level)) ]]; then
			echo "mappingId	Mapping - $prefix$class"
			echo "target		lrb:{VID} a lrb:$prefix$class . "
			echo "source		SELECT VID, 'CarLeafType' FROM Cars WHERE CarLeafType = '$prefix$class'"
			echo ""
		fi
		$0 $level $(($current_level+1)) $branch $class $offset
    done
fi