# Rust Idioms & Best Practices

Specific coding standards and quality gates for Rust implementations.

---

## 1. Safety & Unsafe Code
- **Forbid Unsafe**: Add `#![forbid(unsafe_code)]` at the crate root unless explicitly authorized by the TRD.
- **Audited Unsafe**: If `unsafe` is strictly required (e.g. specialized SIMD or lock-free internals):
  - Must include a preceding `// SAFETY: ...` comment explaining why the invariants hold.
  - Must be tested and verified with Miri (`cargo miri test`).

---

## 2. Error Handling
- **No Unwraps**: Strictly **FORBIDDEN** to use `.unwrap()` or `.expect()` in production/non-test code paths.
- **Custom Error Types**: Use `thiserror` for library crates and `anyhow` for CLI/binaries:
  ```rust
  #[derive(Debug, thiserror::Error)]
  pub enum StorageError {
      #[error("I/O failure: {0}")]
      Io(#[from] std::io::Error),
      #[error("Corrupted record at offset {0}")]
      CorruptedRecord(u64),
  }
  ```
- **Option/Result Propagation**: Use the `?` operator for clean error propagation.

---

## 3. Concurrency & Asynchronous Runtime (Tokio)
- **No Blocking in Async**: Never call blocking functions (such as `std::thread::sleep`, `std::fs::File`, or compute-heavy loops > 1ms) directly inside Tokio async tasks.
  - Use `tokio::fs` or `tokio::task::spawn_blocking` for blocking I/O.
- **Lock Contention**:
  - Prefer `parking_lot::RwLock` or lock-free structures (`crossbeam`, `arc-swap`) over `std::sync::Mutex` where read-heavy workloads exist.
  - Never hold a lock across an `.await` point (causes deadlock or runtime stall).

---

## 4. Memory Efficiency & Zero-Copy
- **Buffer Handling**: Use `bytes::Bytes` and `bytes::BytesMut` for network frames and slicing instead of deep `Vec<u8>::clone()`.
- **Borrowing**: Accept `&str` instead of `&String`, and `&[T]` instead of `&Vec<T>`.

---

## 5. Advanced Distributed & Systems Patterns

- **Async Cancellation Safety (`tokio::select!`)**:
  - In `tokio::select!` branches or timeout wrappers, dropping a future cancels it at any `.await` point.
  - Operations performing framing, TCP reads, or multi-step disk mutations must be cancellation-safe (e.g. state preserved in a struct) or isolated in a dedicated `tokio::spawn` worker task.
- **Bounded Channels & Graceful Shutdown**:
  - Strictly **FORBIDDEN** to use `unbounded_channel()` for inter-task communication (causes OOM under load).
  - Use bounded channels (`tokio::sync::mpsc::channel(capacity)`) to apply backpressure.
  - Use `tokio_util::sync::CancellationToken` or `tokio::sync::watch` for clean, cooperative cluster/node shutdown.
- **Type-Safe Domain Modeling (Newtype Pattern)**:
  - Do not pass raw primitive `u64` values for domain identifiers. Wrap them in strongly typed newtypes to prevent argument ordering bugs at compile time:
    ```rust
    #[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
    pub struct NodeId(pub u64);

    #[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
    pub struct Term(pub u64);

    #[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
    pub struct LogIndex(pub u64);
    ```

---

## 6. Verification Commands & Quality Gates
- Code must pass with zero warnings:
  ```bash
  cargo fmt -- --check
  cargo clippy --all-targets -- -D warnings
  cargo test --all-targets
  ```
