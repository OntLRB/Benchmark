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
	<?xml version="1.0"?>
	<!DOCTYPE rdf:RDF [
	<!ENTITY quest "http://obda.org/quest#" >
	<!ENTITY owl "http://www.w3.org/2002/07/owl#" >
	<!ENTITY xsd "http://www.w3.org/2001/XMLSchema#" >
	<!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#" >
	<!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#" >
	]>

	<rdf:RDF xmlns="http://www.w3.org/2002/07/owl#"
	 xml:base="http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#"
	 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	 xmlns:owl="http://www.w3.org/2002/07/owl#"
	 xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
	<owl:Ontology rdf:about="http://www.ifis.uni-luebeck.de/LinearRoadBenchmark#"/>
	EOM
	echo "$HEAD"
	printf "\n<owl:Class rdf:about=\"#Car1\">\n</owl:Class>\n\n"
	$0 $level 2 1 1 0
	printf "</rdf:RDF>\n"
else
	last_level=$(($current_level-1))
	children=$((2**$last_level))
	for branch in `seq 1 $children`;
    do
    	offset=$(($last_offset*children+branch-1))
    	#echo "l: $last_offset o: $offset"
        class=$(($current_level*100+$offset+1))
		printf "<owl:Class rdf:about=\"#$prefix$class\">\n<rdfs:subClassOf rdf:resource=\"#$prefix$parentClass\"/>\n</owl:Class>\n\n"
		$0 $level $(($current_level+1)) $branch $class $offset
    done    
fi