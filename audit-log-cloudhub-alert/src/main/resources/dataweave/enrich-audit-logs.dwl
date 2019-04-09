%dw 1.0
%output application/java
---
flatten (payload.data map ((log) ->
	log.objects map ((object) ->
		{
			time: log.timestamp as :string,
			userId: log.userId default "",
			userName: flowVars.users[log.userId].userName default "",
			userEmail: flowVars.users[log.userId].userEmail default "",
			clientIP: log.clientIP default "",
			serverIP: log.serverIP default "",
			action: log.action default "",
			failed: log.failed as :string,
			failedCause: log.failedCause default "",
			platform: log.platform default "",
			objectType: object.objectType default "",
			objectId: object.objectId as :string,
			objectName: object.objectName default "",
			parentObjectType: object.parentType default "",
			parentObjectId: object.parentId default "",
			parentObjectName: flowVars.objects[object.parentId] default ""
		}
	)
))