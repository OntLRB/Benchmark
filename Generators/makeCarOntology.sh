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
	$0 $level 2 1 1
	printf "</rdf:RDF>\n"
else
	#left
	new_number=$(($current_level*100+$last_number*2-1))
	printf "<owl:Class rdf:about=\"#$prefix$new_number\">\n<rdfs:subClassOf rdf:resource=\"#$prefix$last_id\"/>\n</owl:Class>\n\n"
	$0 $level $(($current_level+1)) $(($last_number*2-1)) $new_number

	#right
	new_number=$(($current_level*100+$last_number*2))
    printf "<owl:Class rdf:about=\"#$prefix$new_number\">\n<rdfs:subClassOf rdf:resource=\"#$prefix$last_id\"/>\n</owl:Class>\n\n"
  	$0 $level $(($current_level+1)) $(($last_number*2)) $new_number
fi