Postgres

Lost Update tests:
Terminal 1:
BEGIN TRANSACTION ISOLATION LEVEL EPEATABLE READ; UPDATE lit_test SET name=name||'tx1append'  where id=2;
Terminal 2:
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ; UPDATE lit_test SET name=name||'tx2append'  where id=2;

Dirty Reads:
Terminal 1:
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; SELECT name from lit_test where id=2;
Terminal 2:
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; UPDATE lit_test SET name=name||'tx2append'  where id=2;
Terminal 1:
SELECT name from lit_test where id=2;

Non-repeatable reads:
Terminal 1:
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; SELECT name from lit_test where id=2;
Termninal 2:
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; UPDAT
E lit_test SET name=name||'tx2append'  where id=2; COMMIT;
Terminal 1:
SELECT name from lit_test where id=2;

Phantom reads:
Terminal 1:
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED; SELECT name fro
m lit_test where id>=1;
Terminal 2:
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED; INSERT INTO lit_test (name)  VALUES('inserted row'); COMMIT;
Terminal 1:
SELECT * from lit_test where id>=1

Percona
update lit_test set name='test row 2' where id=2;
select * from lit_test;
SET GLOBAL tx_isolation = 'REPEATABLE-READ';
SHOW VARIABLES LIKE 'transaction_isolation'

Lost Update:
Terminal 1:
BEGIN; UPDATE lit_test SET name=CONCAT(name, '_tx1')  where id=2;
Terminal 2:
BEGIN; UPDATE lit_test SET name=CONCAT(name, '_tx2')  where id=2;

Dirty Reads:
Terminal 1:
BEGIN; SELECT name from lit_test where id=2;
Terminal 2:
BEGIN; UPDATE lit_test SET name=CONCAT(name, '_tx2') where id=2;
Terminal 1:
SELECT name from lit_test where id=2;

Non-repeatable reads:
Terminal 1:
BEGIN; SELECT name from lit_test where id=2;
Termninal 2:
BEGIN; UPDATE lit_test SET name=CONCAT(name, '_tx2') where id=2; COMMIT;
Terminal 1:
SELECT name from lit_test where id=2;

Phantom reads:
Terminal 1:
BEGIN; SELECT name from lit_test where id>=1;
Terminal 2:
BEGIN; INSERT INTO lit_test (name)  VALUES('inserted row'); COMMIT;
Terminal 1:
SELECT * from lit_test where id>=1
