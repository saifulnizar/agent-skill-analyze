# TypeScript Idioms & Best Practices

Specific coding standards and quality gates for TypeScript implementations.

---

## 1. Type Safety & Strict Mode
- **No `any`**: Strictly **FORBIDDEN** to use `any`. Use `unknown` with runtime validation (Zod, TypeBox, or type guards).
- **Strict Null Checks**: Handle `null` and `undefined` explicitly with optional chaining (`?.`) and nullish coalescing (`??`).
- **Explicit Return Types**: All exported public functions and module APIs must declare explicit return types.

---

## 2. Asynchronous Control Flow
- **Async/Await**: Prefer `async`/`await` over raw `.then()` / `.catch()` callback chains.
- **Promise Rejection Handling**: Every `async` function that can throw or reject must be enclosed in `try`/`catch` or propagated to a centralized error handler.
- **Parallel Execution**: Use `Promise.all()` or `Promise.allSettled()` for independent concurrent operations.

---

## 3. Immutability & Functional Patterns
- **Readonly Data**: Use `Readonly<T>`, `readonly` array properties, or `as const` assertions to prevent unintentional mutation of shared state.
- **Pure Functions**: Write deterministic functions that do not mutate input arguments.

---

## 4. Verification Commands & Quality Gates
- Code must compile with zero errors:
  ```bash
  npx tsc --noEmit
  npm run lint  # eslint
  npm test      # vitest or jest
  ```
