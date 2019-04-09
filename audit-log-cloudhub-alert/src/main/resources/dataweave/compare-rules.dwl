%dw 1.0
%output application/java

%var satisfiesRule = (auditLogField, ruleField) -> (
	(ruleField.include == null or auditLogField == ruleField.include)
	and (ruleField.exclude == null or auditLogField != ruleField.exclude)
)

%var nonEmptyFields = (object) -> (
	object mapObject (
		'$$': ($ when ($ != null and $ != "") otherwise "-")
	)
)
---
flatten (
	(payload default []) map ( (auditLog) ->
		(flowVars.rules default []) map ( (rule) ->
			(
				{
					ruleId: rule.ruleId,
					ruleName: rule.ruleName
				} ++ nonEmptyFields(auditLog)
			) when (
				satisfiesRule(auditLog.userName, rule.userName)
				and satisfiesRule(auditLog.userId, rule.userId)
				and satisfiesRule(auditLog.userEmail, rule.userEmail)
				and satisfiesRule(auditLog.clientIP, rule.clientIP)
				and satisfiesRule(auditLog.serverIP, rule.serverIP)
				and satisfiesRule(auditLog.platform, rule.platform)
				and satisfiesRule(auditLog.action, rule.action)
				and satisfiesRule(auditLog.objectId, rule.objectId)
				and satisfiesRule(auditLog.objectName, rule.objectName)
				and satisfiesRule(auditLog.objectType, rule.objectType)
				and satisfiesRule(auditLog.parentObjectId, rule.parentObjectId)
				and satisfiesRule(auditLog.parentObjectName, rule.parentObjectName)
				and satisfiesRule(auditLog.parentObjectType, rule.parentObjectType)
			) otherwise null
		)
	)
) filter ($ != null)