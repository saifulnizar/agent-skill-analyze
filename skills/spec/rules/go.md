# Go (Golang) Idioms & Best Practices

Specific coding standards and quality gates for Go implementations.

---

## 1. Error Handling & Wrapping
- **Explicit Error Checks**: Always check `if err != nil`.
- **Error Wrapping**: Use `%w` when wrapping errors with additional context:
  ```go
  if err := wal.Sync(); err != nil {
      return fmt.Errorf("failed to sync wal file: %w", err)
  }
  ```
- **Custom Errors**: Define sentinel errors (`var ErrNotFound = errors.New("...")`) or domain error structs implementing the `error` interface.
- **No Naked Panics**: Never call `panic()` in production logic; use `panic` only during application bootstrap for fatal configuration errors.

---

## 2. Context Propagation
- **First Parameter**: Always accept `ctx context.Context` as the first argument in any function performing I/O, database queries, RPC, or long-running operations.
- **Respect Cancellation**: Periodically inspect `ctx.Done()` or pass `ctx` directly to standard library primitives.

---

## 3. Concurrency & Goroutines
- **Leak Prevention**: Every spawned goroutine must have a deterministic termination condition (context cancellation, done channel, or worker pool shutdown).
- **Synchronization**:
  - Prefer channel communication for data handoff.
  - Use `sync.Mutex` / `sync.RWMutex` for localized critical sections.
  - Use `sync.WaitGroup` or `errgroup.Group` to wait for background workers.

---

## 4. Struct Design & Receivers
- **Receiver Consistency**: Don't mix value and pointer receivers on the same type. If the struct holds state or synchronization primitives (like `sync.Mutex`), always use pointer receivers (`*Type`).
- **Zero Values**: Design structs so their zero value is useful where practical.

---

## 5. Verification Commands & Quality Gates
- Code must pass with zero issues:
  ```bash
  go vet ./...
  golangci-lint run
  go test -race -v ./...
  ```
