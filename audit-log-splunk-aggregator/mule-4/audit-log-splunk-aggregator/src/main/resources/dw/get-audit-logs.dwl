%dw 2.0
output application/java
---
flatten(
	payload.data map ((log) ->
		log.objects map ((object) ->
			{
				timestamp: log.timestamp,
				user: {
	                id: log.userId,
				    name: log.userName,
				    email: (vars.users filter ($.id == log.userId))[0].name
	            },
	            ipAddress: log.clientIP,
				failed: log.failed,
				failedCause: log.failedCause,
				platform: log.platform,
				action: log.action,
	            businessGroup: vars.businessGroup.name,
	            environment: object.environmentName,
				objectType: object.objectType,
				object: {
	                "type": object.objectType,
	                id: object.objectId,
	                name: object.objectName
	            },
	            parent: {
	                "type": object.parentType,
	                id: object.parentId,
	                name: vars.objectNames[object.parentId default ""]
	            }
			}
		)
	)
)