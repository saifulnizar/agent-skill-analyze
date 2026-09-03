# Python Idioms & Best Practices

Specific coding standards and quality gates for Python implementations.

---

## 1. Type Hints & Validation
- **Mandatory Typing**: All public functions and methods must have complete type annotations (`from typing import Optional, List, Dict`, or Python 3.10+ native pipe `int | str`).
- **Data Modeling**: Use `dataclasses` (with `frozen=True` where applicable) or `Pydantic` models for structured data.

---

## 2. Resource Management
- **Context Managers**: Always use `with` statements (or `async with`) for files, sockets, database transactions, and lock acquisitions to guarantee deterministic cleanup.

---

## 3. Exception Handling
- **Specific Exceptions**: Never catch bare `except:`. Catch the narrowest specific exception class.
- **Custom Exceptions**: Inherit domain exceptions from a base `AppError(Exception)` class.

---

## 4. Verification Commands & Quality Gates
- Code must pass with zero errors:
  ```bash
  ruff check .
  mypy --strict .
  pytest -v
  ```
