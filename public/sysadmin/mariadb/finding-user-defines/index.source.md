---
date: '2025-06-16T13:33:46+01:00'
draft: false
title: 'Finding User Defines'
author: Simon Avery
categories:
  - mariadb
  - databases
  - sysadmin
---

### Finding out if a user has any defines**

Before DROPping an sql user, it's sensible to check whether they have ever created any VIEWs, added a TRIGGER or written a stored PROCEDURE. If you don't, and they did, then deleting the user will result in errors such as `MySQL error 1449: The user specified as a definer does not exist`

### Why does this happen?

MariaDb / MySql uses the definer's permissions to check whether they have authorisation to use that VIEW (which may select from multiple tables), run that STORED PROCEDURE (which may INSERT or DELETE from a table) or run a TRIGGER (again, it may need read/write privs anywhere). It's not a bad system and works well, but doesn't protect itself when that user disappears.

### How to check whether it's safe to DROP the user?

Fortunately, this information is stored in the meta database, `INFORMATION_SCHEMA`, so we can run a query to search it for a given user. Change USERNAME in this for the user you want to check (leaving the % wildcard at the end) and run it. If it returns results, then you will need to reconsider DROPping this user. (GUI tools will let you recreate the PROCEDURE etc, but beware that they usally DROP the routine before recreating it. Fine – except that **any grants given specifically to that VIEW/PROCEDURE/TRIGGER will be automatically removed from any users that have them.**

```
SET @uname = 'USERNAME%';

USE INFORMATION_SCHEMA;

SELECT 'VIEW' AS OBJECT_TYPE, TABLE_SCHEMA, TABLE_NAME, DEFINER FROM views WHERE DEFINER LIKE @uname
UNION ALL
SELECT 'TRIGGER' AS OBJECT_TYPE, TRIGGER_SCHEMA, TRIGGER_NAME, DEFINER FROM TRIGGERS WHERE DEFINER LIKE @uname
UNION ALL
SELECT ROUTINE_TYPE AS OBJECT_TYPE, ROUTINE_SCHEMA, ROUTINE_NAME, DEFINER FROM ROUTINES WHERE DEFINER LIKE @uname
```

Credit to [Pythian](https://www.pythian.com/blog/technical-track/properly-removing-users-mysql) for the original idea, although I've changed this check a fair bit to suit my needs.
