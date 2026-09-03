# Distributed Transactions & Workflow Integrity

Architecture reference for microservices data consistency, dual-write prevention, and distributed transaction patterns (derived from Chris Richardson's Microservices Patterns).

---

## 1. The Dual-Write Problem
When a microservice needs to **update its local database AND publish an event to a message broker (Kafka/RabbitMQ)**:
- Writing DB first, then sending Kafka message $\implies$ If message broker fails, DB committed but event is lost.
- Sending Kafka message first, then writing DB $\implies$ If DB transaction rolls back, external world processed phantom event.

### The Canonical Solution: Transactional Outbox Pattern
1. Within the **same local ACID database transaction**, insert the business entity into `orders` table AND write an event record into `outbox` table.
2. A separate background process (Change Data Capture / Debezium, or Polling Publisher) reads `outbox` and publishes to Kafka with at-least-once delivery.
3. Once confirmed by Kafka, the outbox record is marked published or deleted.

---

## 2. Distributed Saga Patterns (Cross-Service Workflows)

When a business transaction spans multiple independent microservices (e.g. Order Service $\rightarrow$ Payment Service $\rightarrow$ Inventory Service), Two-Phase Commit (2PC) is usually avoided due to blocking lock overhead. Instead, use **Sagas**:

### A. Orchestration-Based Saga
- **Mechanics**: A central Saga Orchestrator coordinates the workflow. It sends command messages to participant services and waits for reply events.
- **Compensating Transactions**: If Step 3 (Inventory reservation) fails, the orchestrator issues explicit compensating requests to roll back Step 2 (Refund payment) and Step 1 (Cancel order).
- **Best For**: Complex multi-step workflows with strict audit trails (e.g. loan approval, travel booking, checkout).

### B. Choreography-Based Saga
- **Mechanics**: Participant services publish and subscribe to each other's domain events without a central coordinator.
- **Best For**: Simple 2–3 step workflows.
- **Accepted Trade-Offs**: Harder to debug, risk of cyclic event loops.
