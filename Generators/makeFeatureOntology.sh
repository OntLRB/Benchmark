#!/bin/bash

width=$1

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

<owl:DatatypeProperty rdf:about="#hasToll">
 <rdfs:domain rdf:resource="#Car"/>
 <rdfs:range rdf:resource="&xsd;integer"/>
</owl:DatatypeProperty>

<owl:Class rdf:about="#VID">
</owl:Class>
EOM
echo "$HEAD"
printf "\n"
for feature in `seq 0 $(($width-1))`;
do
	leftSubFeature=$((2*feature))
	rightSubFeature=$((leftSubFeature+1))
  F=Feature$feature
  subHasL=hasSubFeature$leftSubFeature
  subHasR=hasSubFeature$rightSubFeature
	printf "<owl:Class rdf:about=\"#$F\">\n</owl:Class>\n\n"
  printf "<owl:ObjectProperty rdf:about=\"#has$F\">\n<rdfs:domain rdf:resource=\"#VID\"/>\n<rdfs:range rdf:resource=\"#$F\"/>\n</owl:ObjectProperty>\n\n"
	printf "<owl:ObjectProperty rdf:about=\"#$subHasL\">\n<rdfs:subPropertyOf rdf:resource=\"#has$F\"/>\n</owl:ObjectProperty>\n\n"
	printf "<owl:ObjectProperty rdf:about=\"#$subHasR\">\n<rdfs:subPropertyOf rdf:resource=\"#has$F\"/>\n</owl:ObjectProperty>\n\n"
done
echo "</rdf:RDF>"
