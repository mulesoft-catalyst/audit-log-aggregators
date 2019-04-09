# Audit Log - Cloudhub Alert

The final objective of this application is sending Email Alerts when a not expected behavior ocurrs on the Anypoint Platform. This Mule app obtains the Audit Logs from the Access Manager and filter them based on a rules file contained inside the Application. For each Log matching a rule, it will send a Cloudhub notification. Then, an alert in the Anypoint Platform can be set up to send an email when a notification is sent.

## Requirements
* Mule Runtime 3.9.x
* Anypoint Platform User
* User must have the **Organization Administrator** role
* Cloudhub vCores available

## Rules

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

Each field can be inclusive or exclusive, this means, a Log can be matched if it has a given value or if it doesn't.

![Rules file](/audit-log-cloudhub-alert/images/01-rules-file.png)

For example, here we can see two rules:
- USER_DAMIAN: Raise an alert when the user name is "damian-calabresi" and the object type is an application.
- USER_NO_DAMIAN: Send a notification when a user different than "damian-calabresi" does a Login in the platform.

## Steps

* Load Rules file
* Login to Anypoint Platform
* For each Business Group
  * Retrieve User list
  * Retrieve Object list
  * Get the Audit Logs of the last 5 minutes
  * Enrich the Audit Logs with the User and Object names
  * Compare the Audit Logs against the Rules (Add Rule ID and Rule Name to the validated Logs)
  * For each Log matching a Rule
    * Send a Cloudhub Notification (Only works on Cloudhub)

The integration will run every 5 minutes. The last date of Audit retrieval will be saved as a Watermark. The Audit since that date will be retrieved. If Watermark is empty, the last 5 minutes will be queried.

An Alert in Runtime Manager should be configured to send an email when this notification is received.

## Walkthrough

The Mule app has a configuration file for each environment. It will need a user, password and the list of business groups that we want to audit.

![Configuration file](/audit-log-cloudhub-alert/images/02-configuration-file.png)

We'll deploy the application to Cloudhub and set up the parameters directly on Runtime Manager.

![Cloudhub properties](/audit-log-cloudhub-alert/images/03-cloudhub-properties.png)

After deploying the application, we can see the logs:

```
09:36:56.889     05/23/2018     Worker-0     qtp1573879225-33     INFO
Starting Audit Log Retrieval
09:36:56.890     05/23/2018     Worker-0     qtp1573879225-33     INFO
Login to Anypoint Platform
09:36:57.051     05/23/2018     Worker-0     qtp1573879225-33     INFO
Authentication token retrieved
09:36:57.052     05/23/2018     Worker-0     qtp1573879225-33     INFO
Starting sync process for organizationId: 66c44113-86fb-4e48-8d5a-e9dc61ad0469
09:36:57.052     05/23/2018     Worker-0     qtp1573879225-33     INFO
Retrieving users - organizationId: 66c44113-86fb-4e48-8d5a-e9dc61ad0469
09:36:57.112     05/23/2018     Worker-0     qtp1573879225-33     INFO
Retrieved users - organizationId: 66c44113-86fb-4e48-8d5a-e9dc61ad0469 - Number of users: 10
09:36:57.112     05/23/2018     Worker-0     qtp1573879225-33     INFO
Retrieving objects - organizationId: 66c44113-86fb-4e48-8d5a-e9dc61ad0469
09:36:57.281     05/23/2018     Worker-0     qtp1573879225-33     INFO
Retrieved objects - organizationId: 66c44113-86fb-4e48-8d5a-e9dc61ad0469 - Number of objects: 104
09:36:57.281     05/23/2018     Worker-0     qtp1573879225-33     INFO
Retrieving audit logs - organizationId: 66c44113-86fb-4e48-8d5a-e9dc61ad0469 - from: 2018-05-23T12:31:52.577Z - to 2018-05-23T12:36:57.052Z
09:36:57.340     05/23/2018     Worker-0     qtp1573879225-33     INFO
Retrieved audit logs - organizationId: 66c44113-86fb-4e48-8d5a-e9dc61ad0469 - from: 2018-05-23T12:31:52.577Z - to 2018-05-23T12:36:57.052Z - Number of entries: 1
09:36:57.341     05/23/2018     Worker-0     qtp1573879225-33     INFO
Comparing audit logs against alert rules - Number of logs: 1 - Number of rules: 2
09:36:57.342     05/23/2018     Worker-0     qtp1573879225-33     WARN
Splitter returned no results. If this is not expected, please check your split expression
09:36:57.342     05/23/2018     Worker-0     qtp1573879225-33     INFO
Comparing audit logs against alert rules - Rules matched: 0
```
Now, when an Audit Log matches a Rule, a Cloudhub notification will be sent. This is why we'll create an Alert based on these Cloudhub notifications.

![Runtime Manager alerts](/audit-log-cloudhub-alert/images/04-runtime-manager-alert.png)

The email body will contain all the Audit Log information. This parameters will be sent by the Mule Application in the Cloudhub Notification.

```
Hello,
You are receiving this alert because a validation has failed:

Rule ID: ${ruleId}
Rule Name: ${ruleName}
Time: ${time}
User ID: ${userId}
User Name: ${userName}
User Email: ${userEmail}
Client IP: ${clientIP}
Server IP: ${serverIP}
Action: ${action}
Failed: ${failed}
Failed Cause: ${failedCause}
Platform: ${platform}
Object Type: ${objectType}
Object ID: ${objectId}
Object Name: ${objectName}
Parent Object Type: ${parentObjectType}
Parent Object ID: ${parentObjectId}
Parent Object Name: ${parentObjectName}
```

Now that everything has been set up, we can login to the Platform with a different user so the rule "USER_NO_DAMIAN" raise an alert. After a few minutes, we can see the notification and the email alert:

![Cloudhub notification](/audit-log-cloudhub-alert/images/05-cloudhub-notification.png)

![Email alerts](/audit-log-cloudhub-alert/images/06-email-alert.png)

