# Audit Log - Splunk Aggregator

This Mule app extracts the Audit Logging from the Anypoint Platform and send it to Splunk through the HTTP Event Collector.

# Audit Log - Cloudhub Alert

The final objective of this application is sending Email Alerts when a not expected behavior ocurrs on the Anypoint Platform. This application obtains the Audit Logs from the Access Manager and filter them based on a rules file contained inside the Mule Application. For each Log matching a rule, it will send a Cloudhub notification. Then, an alert in the Anypoint Platform can be set up to send an email when a notification is sent.

The Rules file can raise an alert based on any of these fields:
- User ID (UUID)
- User name
- User email
- Client IP address
- Server IP address (Depends on which server of the Anypoint Platform is hit)
- Platform (The section of the Platform being consumed: CoreServices, RuntimeManager)
- Action (Login, update, modify)
- Object Type (Application, Server, API)
- Object ID
- Object Name (The name of the API, Application, Server or Exchange Asset)
- Parent Object Type (Some Objects are related to a Parent Object, e.g.: an API Version and an API)
- Parent Object ID
- Parent Object Name
