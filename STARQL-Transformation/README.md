# Transformation

This is a transformation service for transforming OntLRB queries from STARQL into ExaStream

## Run instruction

You can directly transform queries by using the runnable JAR "StarqlToExaStream.jar" provided in this folder.

Use of Parameters:
```javascript
StarqlToExaStream.jar [STARQLquery] [resultFile] [ontologyFile] [obdaFile]```

Execution Example:
```javascript
StarqlToExaStream.jar query1.txt result1.txt ontlrb.owl ontlrb.obda```

Example Files can be found in the folder "Mappings", "Ontologies" and "Queries" of the Benchmark.
