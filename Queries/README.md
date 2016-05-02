## OntLRB Queries
-----------
This folder contains the OntLRB queries written in the STARQL dialect. Use the **STARQL-Transformation** tool to unfold these queries to the ExaStream SQL dialect.

The query **feature query** is provided for a feature width = 4. Adjust the *WHERE*-clause
of the query to meet other feature widths. A feature width = 2 would have the following *WHERE*-clause:

```javascript
WHERE { ?VID a :Feature0 . ?VID a :Feature1 }
```
