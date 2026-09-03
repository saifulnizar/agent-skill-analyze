# Enterprise Data Modeling & Tenancy Architecture

Architecture reference for relational data schemas, query indexing, multi-tenancy, and high-concurrency database access.

---

## 1. Indexing Strategy & Performance Rules (PostgreSQL / MySQL)
- **B-Tree Index Invariants**:
  - Always index foreign keys and columns used in `WHERE`, `JOIN`, and `ORDER BY`.
  - **Leftmost Prefix Rule**: A composite index `(tenant_id, status, created_at)` accelerates queries filtering on `(tenant_id)` or `(tenant_id, status)`, but NOT `(status)` alone.
- **Avoid Over-Indexing**: Every additional index penalizes `INSERT`, `UPDATE`, and `DELETE` throughput due to index tree rebalancing.
- **Partial Indexes**: For status-driven workflows, index only active rows:
  ```sql
  CREATE INDEX idx_orders_unprocessed ON orders (created_at) WHERE status = 'PENDING';
  ```

---

## 2. Multi-Tenancy Isolation Models

| Isolation Model | Data Separation | Resource Efficiency | Operational Complexity |
| :--- | :--- | :--- | :--- |
| **Separate Database Per Tenant** | Complete physical separation | Lowest (many idle connection pools) | High (migrations must run across $N$ DBs). Required for strict healthcare/banking compliance. |
| **Separate Schema Per Tenant** | Schema isolation in single DB | Medium | Moderate. Supported natively by PostgreSQL schemas. |
| **Shared Database & Shared Schema (Tenant Column)** | Logical separation via `tenant_id` | Highest (single connection pool, high density) | Low infrastructure cost, but application code MUST strictly enforce `tenant_id` filtering on every query (Row-Level Security / RLS). |

---

## 3. High Concurrency Locking & Contention
- **Pessimistic Locking (`SELECT FOR UPDATE`)**:
  - Locks row until transaction commits.
  - *Risk*: Deadlocks under high concurrency; serialize traffic. Use `SKIP LOCKED` for queue-worker patterns:
    ```sql
    SELECT * FROM outbox WHERE status = 'PENDING' ORDER BY id LIMIT 10 FOR UPDATE SKIP LOCKED;
    ```
- **Optimistic Locking (`version` column)**:
  - Non-blocking. Update succeeds only if version matches:
    ```sql
    UPDATE accounts SET balance = balance - 100, version = version + 1 WHERE id = 123 AND version = 5;
    ```
  - If 0 rows affected, client retries. Best for read-heavy, low-collision environments.

---

## 4. Advanced PostgreSQL Performance & Scaling

### A. Declarative Table Partitioning
When table sizes exceed ~50M–100M rows, indexes become too large to fit in RAM, degrading write and query performance.
- **Range Partitioning**: Partition by temporal bounds (`created_at` per month). Best for log/audit/timeseries data where old partitions can be dropped instantly via `DROP TABLE` without heavy vacuum overhead.
- **Hash Partitioning**: Partition by `hash(tenant_id)` across $N$ physical partition buckets. Distributes IOPS evenly across multi-tenant databases.

### B. Connection Pool Sizing (HikariCP / PgBouncer Formula)
- Over-allocating database connections leads to context switching thrashing on the database CPU.
- **PostgreSQL Recommended Formula**:
  $$\text{Max Pool Size} = (\text{CPU Cores} \times 2) + \text{Effective Spindle Count}$$
  *Example: A 16-core PostgreSQL server with NVMe SSDs reaches optimal throughput at around 32–40 connections. Scale application traffic using PgBouncer in Transaction Pooling mode.*
