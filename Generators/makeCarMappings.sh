#!/bin/bash

level=$1
current_level=$2; current_level=${current_level:=1}
last_number=$3; last_number=${last_number:=1}
last_id=$4;
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
	$0 $level 2 1 1
	echo "]]"
else
	#left
	new_number=$(($current_level*100+$last_number*2-1))
	if [[ $level -eq $(($current_level)) ]]; then
		echo "mappingId	Mapping - $new_number"
		echo "target		lrb:{VID} a lrb:$prefix$new_number . "
		echo "source		SELECT VID FROM TollStr WHERE VID % $((2**($level-1))) = $(($last_number*2-2))"
		echo ""
	fi
	$0 $level $(($current_level+1)) $(($last_number*2-1)) $new_number

	#right
	new_number=$(($current_level*100+$last_number*2))
	if [[ $level -eq $(($current_level)) ]]; then	
		echo "mappingId	Mapping - $new_number"
		echo "target		lrb:{VID} a lrb:$prefix$new_number . "
		echo "source		SELECT VID FROM TollStr WHERE VID % $((2**($level-1))) = $(($last_number*2-1))"
		echo ""
	fi
  	$0 $level $(($current_level+1)) $(($last_number*2)) $new_number
fi