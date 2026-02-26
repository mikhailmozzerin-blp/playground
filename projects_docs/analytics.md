## Analytics

1. Investigation
    - Analytics v2 schema
    - Tested about 20 on dummy data – need to test it on more or less real data
    - Review analytics v2 schema changes
      - add version table between task and field and document_metadata, remove version_start and end dates
      - remove metadata from field table
      - add document_fields table with all data fields instead of view
      - link version to task edit(optional?)
2. POC/MVP
    - Init new analytics schema v2 in document-api
        - (or just ask someone to run it from his local and create one more schema in dms-dev??)
    - How to fill the schema with data?
        - Implement events and logic to persist the metrics
          1. New document → **NewDocumentAnalyticsEvent** is that the same as TaskStartedAnalyticsEventMsg??
             - insert into analytics_v2.document
             - insert into tasks
             - parse the prediction object and propagate task_exceptions, task_edits(?), prediction_fields, document_status, task_actions
          2. New document version committed → **NewDocumentVersionAnalyticsEvent** is that the same as TaskFinishedAnalyticsEventMsg??
             - insert into analytics_v2.document_version
             - insert into document_fields
        - Generate some random data based on existing datasync data + dms data
    - In a dev environment we can join with _dms tables, but what to do with _datasync?
        - Copy datasync db snapshot to _dms db?
        - Create a new db for analytics
    - Integration with dashboard provider: basedash/metabase/lightdash/apache superset
3. MVP
    - Sync db schemas (_dms and _datasync) into one db/datalake
    - Integrate with dashboard provider
    - Prepare release plan(customer by customer)

   
Technical design:
1. create env varibale to enable v2 analytics only for spcific orgIds
2. Can we reuse the existing analytics events, is that enough?
3. How to fetch the prediction data?
4. 