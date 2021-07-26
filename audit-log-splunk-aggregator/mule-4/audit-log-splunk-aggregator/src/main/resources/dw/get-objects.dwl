%dw 2.0
output application/java
---
(payload.data filter $.objectId != "") map {
    ($.objectId): $.objectName
} reduce ($$ ++ $)