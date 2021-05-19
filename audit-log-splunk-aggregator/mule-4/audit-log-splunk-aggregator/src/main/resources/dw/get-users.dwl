%dw 2.0
output application/java
---
payload.data map {
	id: $.id,
	username: $.username,
	email: $.email
}