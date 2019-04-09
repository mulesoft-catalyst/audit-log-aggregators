%dw 1.0
%output application/java
---
{
	organizationIdList: read(p('anypoint.platform.organizationid.list'),"application/json")
}