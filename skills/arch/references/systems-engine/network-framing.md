# Binary Network Framing & Socket I/O Architecture

Architecture reference for custom wire protocols, socket multiplexing, and zero-copy data pipelines.

---

## 1. Frame Layout Principles

TCP is a continuous byte stream without packet boundaries. Custom protocols must solve message delimitation:

```
+-------------------------------------------------------------+
| Fixed-Length Header (e.g. 16 Bytes)                         |
| [Magic: 2B][Ver: 1B][OpCode: 1B][Flags: 4B][CorrID: 4B][Len]|
+-------------------------------------------------------------+
| Variable-Length Payload ([Len] Bytes)                       |
| [Body Data ...]                                             |
+-------------------------------------------------------------+
| Optional Trailer (e.g. CRC32 Checksum: 4 Bytes)             |
+-------------------------------------------------------------+
```

### Essential Invariants:
1. **Magic Number**: Distinct 2–4 byte sequence (e.g. `0x524B`) at offset 0 to immediately drop invalid connections or misrouted HTTP scanners.
2. **Explicit Payload Length**: Always fixed-width (e.g. `u32` in Big-Endian).
3. **Correlation ID**: Supports asynchronous multiplexing (responses do not need to arrive in the exact order of requests on the same connection).
4. **Data Integrity Checksum**: CRC32 or xxHash placed after payload to detect memory corruption or partial socket writes.

---

## 2. Zero-Copy Buffer Architecture
- **Avoid Repeated Allocation**: Use reference-counted contiguous buffer pools (`bytes::Bytes` in Rust, `sync.Pool` / buffer slices in Go).
- **Buffer Reservation**: When reading from a socket, if `available_bytes < header.length`, reserve the remaining deficit in one allocation rather than incremental resizing.
- **Backpressure & Max Frame Limits**: Always enforce a hard ceiling (e.g. `MAX_PAYLOAD_SIZE = 16MB`). If a client declares `payload_len = 2GB`, immediately abort connection to prevent memory exhaustion DoS.
