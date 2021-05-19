%dw 2.0
output application/java
---
flatten(
	payload.targets map ((target) -> do {
	    var serverName = (vars.servers filter ($.id as String == target.id))[0].name
	    ---
	    (
	        flatten(
	            target.metrics pluck ((metricContent,metricName) ->
	                metricContent.values map {
	                    timestamp: $.time,
	                    (metricName): $.avg
	                }
	            )
	        ) groupBy $.timestamp
	    ) pluck (metrics,timestamp) ->  {
	        timestamp: timestamp,
	        businessGroup: vars.businessGroup.name,
	        environment: vars.environment.name,
	        server: serverName
	    } ++ (
	        metrics map ($ - "timestamp") reduce ($$ ++ $)
	    )
	})
)