# Reliability, Resiliency & API Protection Patterns

Architecture reference for robust, fault-tolerant enterprise APIs and payment/critical services (derived from AWS Well-Architected & Google SRE).

---

## 1. Idempotency Keys (IETF Standard)
- **Problem**: Network timeouts during payment or order creation cause clients to retry, risking duplicate charging.
- **Pattern**:
  1. Client sends header: `Idempotency-Key: <UUIDv4>`.
  2. Server checks Redis / PostgreSQL:
     - If key exists with `status: SUCCESS`: return cached response immediately.
     - If key exists with `status: IN_PROGRESS`: return HTTP `409 Conflict` (concurrent duplicate request).
     - If key does not exist: insert key with `status: IN_PROGRESS` and 24-hour TTL, execute business logic, update key with response payload and `status: SUCCESS`.

---

## 2. Circuit Breaker Pattern (Martin Fowler / Netflix Hystrix)
Protects against cascading failures when downstream dependencies (e.g. payment gateway or third-party API) slow down or fail.

```
       +---------+   Failures > Threshold   +------+
       | Closed  | -----------------------> | Open |
       +---------+                          +------+
            ^                                  |
            | Successes > Threshold            | Sleep window expires
            |                                  v
       +---------------+                 +-----------+
       |   Half-Open   | <-------------- | Half-Open |
       +---------------+                 +-----------+
```
- **Closed**: Requests pass through normally. Tracks error rates.
- **Open**: Short-circuits immediately. Fails fast without hitting the degraded dependency, returning fallback or `503 Service Unavailable`.
- **Half-Open**: Allows canary probe requests to verify if downstream recovered.

---

## 3. Rate Limiting & Shedding Algorithms
- **Token Bucket**: Allows bursts up to capacity while refilling at a steady rate. Standard for public REST APIs.
- **Leaky Bucket**: Smooths out traffic into a constant output rate. Best for egress traffic to strict external vendors.
- **Exponential Backoff with Full Jitter**:
  $$t = \text{random}(0, \min(t_{\text{max}}, t_{\text{base}} \times 2^{\text{attempt}}))$$
  *Adding jitter prevents the "Thundering Herd" problem where all retrying clients hammer the recovering server simultaneously.*

---

## 4. Advanced Resilience & Isolation Patterns

### A. Bulkhead Isolation Pattern (Michael Nygard / Netflix)
- **Problem**: If one downstream service (e.g. legacy SMS vendor or analytics API) slows down from 50ms to 10 seconds, all HTTP server worker threads/goroutines become occupied waiting for it, starving unrelated critical endpoints (like login or checkout).
- **Solution**: Partition thread pools, semaphore bounds, and connection pools per downstream dependency:
  - *Payment Pool*: Max 50 concurrent connections.
  - *SMS Vendor Pool*: Max 10 concurrent connections.
  - *Analytics Pool*: Max 5 concurrent connections.
  - If the SMS vendor hangs, only its 10 slots block; the rest of the application continues operating smoothly.

### B. Graceful Degradation & Fallback Strategies
- When a non-critical subsystem fails:
  - **Static / Cached Fallback**: Return cached product recommendations or stale shipping rates with a degraded status flag rather than failing the whole user checkout.
  - **Feature Toggles**: Dynamically disable expensive UI widgets under heavy load (Load Shedding).
