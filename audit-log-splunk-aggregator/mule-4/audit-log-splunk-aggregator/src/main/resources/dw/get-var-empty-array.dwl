%dw 2.0 
output application/java
---
// First page already retrieved
// Ratio is not decreased because of integer division mod
(1 to (vars.totalRecords / vars.offset.limitRecords))