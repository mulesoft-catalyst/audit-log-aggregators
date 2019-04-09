%dw 1.0
%output application/java
---
{
	splunkIndexAudit: p('splunk.index.audit'),
	splunkSourceTypeAudit: p('splunk.sourcetype.audit'),
	splunkSource: p('splunk.source'),
	organizationIdList: read(p('anypoint.platform.organizationid.list'),"application/json")
}