# Interview Evidence Map

Use this file to answer interview questions with evidence rather than memorized definitions.

| Interview topic | Evidence story to build |
|---|---|
| Provision a new user | Ticket -> create user -> attributes -> group/license -> verify -> evidence |
| Offboard a user | Authorized request -> disable -> revoke -> remove groups/licenses -> mailbox/data handling -> verify |
| User changed departments | Export old access -> remove obsolete -> add approved new access -> verify least privilege |
| Access request lacks approval | Do not grant; request correct authorization; document ticket |
| High-priority termination | Access cutoff first, exact timestamps, verify disabled state, then cleanup |
| Group membership mistake | Roll back, identify impact, correct membership, document root cause/prevention |
| SLA vs security conflict | Escalate early, preserve control requirements, document dependency/exception |
| Why groups instead of direct permissions | Consistency, scalability, auditability, least privilege, easier offboarding |
| Access review | Compare entitlement to current business need; remove stale/unsupported access |
| Automation | Automate repetitive steps but keep approval, validation, logging and rollback controls |
