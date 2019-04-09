# Audit Log - Splunk Aggregator

This Mule app extracts the Audit Logging from the Anypoint Platform and send it to Splunk through the HTTP Event Collector

## Requirements
* Mule Runtime 3.9.0
* Anypoint Platform User
  * User must have the **Organization Administrator** role
* Splunk **HTTP Event Collector** enabled
* Splunk **index**, **sourcetype** and **source** configured

## Steps

* Login to Anypoint Platform
* For each Business Group
  * Retrieve User list
  * Retrieve Object list
  * Get the Audit Logs of the last 5 minutes
  * Transform the Logs into an array of Splunk Events
  * Concatenate Events in one String
  * Send bulk of events through HTTP Event Collector endpoint

The integration will run every 5 minutes. The last date of Audit retrieval will be saved as a Watermark. The Audit since that date will be retrieved. If Watermark is empty, the last 5 minutes will be queried.
