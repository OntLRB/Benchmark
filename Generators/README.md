## Generators
-----------
Scripts in this folders are used to generate ontology and mapping files. Each generator expects one parameter, the number of levels for car ontologies or the width of the feature ontology respectively.

The command
```javascript
./makeCarOntology.sh 2
```
creates a car ontology with 2 levels which corresponds to a tree of depth 1:

```xml
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

<owl:Class rdf:about="#Car1">
</owl:Class>

<owl:Class rdf:about="#Car201">
<rdfs:subClassOf rdf:resource="#Car1"/>
</owl:Class>

<owl:Class rdf:about="#Car202">
<rdfs:subClassOf rdf:resource="#Car1"/>
</owl:Class>

</rdf:RDF>

```
