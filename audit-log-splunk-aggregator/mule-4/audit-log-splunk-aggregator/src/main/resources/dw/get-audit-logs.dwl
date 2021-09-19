%dw 2.0
output application/json  
---
payload.data map (log) -> {
  time : log.timestamp as String,
  event : log
}