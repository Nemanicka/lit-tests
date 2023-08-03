# Results

## Postgres

| Transaction Isolation Level | Lost Update   | Dirty Read                     | Non-Repeatable Read | Phantom Read      |
|----------------------------|----------------|-------------------------------|---------------------|---------------------|
| Repeatable Read            | LOCKED (NO)   | Error                         | NO                  | NO                  |
| Read Committed             | LOCKED (NO)   | NO (returned initial value)   | YES                 | YES                 |
| Read Uncommitted           | LOCKED (NO)   | NO                            | YES                 | YES                 |
| Serializable               | Error         | NO                            | NO                  | NO                  |

## Percona

| Transaction Isolation Level | Lost Update   | Dirty Read                     | Non-Repeatable Read | Phantom Read      |
|----------------------------|----------------|-------------------------------|---------------------|---------------------|
| Repeatable Read            | LOCKED (NO)   | NO                            | NO                  | LOCKED (NO)        |
| Read Committed             | LOCKED (NO)   | NO                            | Yes                 | YES                |
| Read Uncommitted           | LOCKED (NO)   | YES                           | YES                 | YES                |
| Serializable               | LOCKED (NO)   | LOCKED (NO)                   | LOCKED (NO)         | YES                |


# Commads used:

## Postgres

### Lost Update tests:

**Terminal 1:**

```BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ; UPDATE lit_test SET name=name||'tx1append'  where id=2;```

**Terminal 2:**

```BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ; UPDATE lit_test SET name=name||'tx2append'  where id=2;```


### Dirty Reads:

**Terminal 1:**

```BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; SELECT name from lit_test where id=2;```

**Terminal 2:**

```BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; UPDATE lit_test SET name=name||'tx2append' where id=2;```

**Terminal 1:**

```SELECT name from lit_test where id=2;```

### Non-repeatable reads:

**Terminal 1:

```BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; SELECT name from lit_test where id=2;```

**Terminal 2:**

```BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; UPDATE lit_test SET name=name||'tx2append'  where id=2; COMMIT;```

**Terminal 1:**

```SELECT name from lit_test where id=2;```

### Phantom reads:

**Terminal 1:**

```BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED; SELECT name from lit_test where id>=1;```

**Terminal 2:**

```BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED; INSERT INTO lit_test (name)  VALUES('inserted row'); COMMIT;```

**Terminal 1:**

```SELECT * from lit_test where id>=1```

## Percona

### Lost Update:

**Terminal 1:**

```BEGIN; UPDATE lit_test SET name=CONCAT(name, '_tx1')  where id=2;```

**Terminal 2:**

```BEGIN; UPDATE lit_test SET name=CONCAT(name, '_tx2')  where id=2;```

### Dirty Reads:

**Terminal 1:**

```BEGIN; SELECT name from lit_test where id=2;```

**Terminal 2:**

```BEGIN; UPDATE lit_test SET name=CONCAT(name, '_tx2') where id=2;```

**Terminal 1:**

```SELECT name from lit_test where id=2;```

### Non-repeatable reads:

**Terminal 1:**

```BEGIN; SELECT name from lit_test where id=2;```

**Termninal 2:**

```BEGIN; UPDATE lit_test SET name=CONCAT(name, '_tx2') where id=2; COMMIT;```

**Terminal 1:**

```SELECT name from lit_test where id=2;```

### Phantom reads:

**Terminal 1:**

```BEGIN; SELECT name from lit_test where id>=1;```

**Terminal 2:**

```BEGIN; INSERT INTO lit_test (name)  VALUES('inserted row'); COMMIT;```

**Terminal 1:**

```SELECT * from lit_test where id>=1```
