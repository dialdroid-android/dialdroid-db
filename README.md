# dialdroid-db

1. DIALDroid.sql: Script to create the entire database

2. categorytest.sql: SQL procedure implementing Android category matching rules (ref: https://developer.android.com/guide/components/intents-filters.html#Resolution )

3. datatest.sql: SQL procedure implemention Android url matching rules (ref: https://developer.android.com/guide/components/intents-filters.html#Resolution)

4. CalculateAllICCLinks.sql: SQL procedure to compute all sensitive ICC links.

5. ICCBasedLeaks.sql: SQL query to compute inter-app and intra-app ICC based leaks. This query will work only after computing all sensitive ICC links.

6. PrivEscalations.sql: SQL query to compute all privilege escalation cases. This query will work only after computing all sensitive ICC links.
