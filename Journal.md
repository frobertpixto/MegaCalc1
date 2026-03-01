# MegaCalc1 — Engineering Journal

## The Big Picture

Imagine you're doing math on a regular calculator and you hit the limit — 19 digits, maybe 20 if you're lucky. Now imagine you want to multiply two numbers with *500,000 digits each*. That's MegaCalc.

MegaCalc1 is an arbitrary-precision integer calculator for macOS. It doesn't care how big your numbers are. Want to compute `50000!`? Go ahead. Want to check if a 30-digit number is prime? Be our guest. It handles numbers that would make `Int64` cry.

This project has a fascinating lineage: Francois Robert first built it in 1993 in C++ on MS-DOS, motivated by a magazine article about a world record for large-number multiplication (22,000 digits in 24 hours). He beat that record by multiplying two 500,000-digit numbers. Since then, MegaCalc has been reimplemented in C#, Java, and Swift. This SwiftUI version is the latest chapter.

## Architecture Deep Dive

Think of MegaCalc like a restaurant:

**The Kitchen (BigInteger + IntegerList)** — This is where the real cooking happens. `BigInteger` is the head chef who knows how to add, subtract, multiply, and divide numbers of any size. It doesn't store numbers the way you'd write them on paper. Instead, it chops them into 8-digit chunks called "octobles" and stores them in reverse order. So `123456789` becomes `[23456789, 1]`. Why? Because when you add numbers, you start from the right — and having the least-significant chunk at index 0 makes the math loop naturally from `0` to `n`.

`IntegerList` is the pantry — a thin wrapper around `[Int]` that `BigInteger` uses to store its octobles. It's intentionally simple and portable (the same concept was used in the C# and Java versions).

**The Sous Chef (MegaDecimalAlgo)** — Handles the fancier operations that build on basic arithmetic: factorial, primality testing, and finding primes. These are the long-running operations that can take seconds, minutes, or even hours. The sous chef periodically checks if the head waiter has told them to stop (`isCancelled`), which is how the app stays responsive.

**The Head Waiter (MegaCalcViewModel)** — Translates between what the kitchen can do and what the customer (UI) wants. Takes text input, parses it into `BigInteger`, dispatches work, and serves results back as strings. For quick operations (add, subtract, multiply), the waiter handles it synchronously. For the slow stuff (factorial, prime checks), the waiter kicks off a background task and puts up a "please wait" sign.

**The Dining Room (MegaCalcView)** — The customer-facing UI. Three text fields (A, B, Result) and a grid of operation buttons. Simple, functional, not flashy — like a diner that serves incredible food.

## The Codebase Map

```
MegaCalc1/
├── BigInteger/
│   ├── BigInteger.swift      -- The star of the show. ~1000 lines of arbitrary-precision math.
│   └── IntegerList.swift     -- Simple array wrapper for portability across languages.
├── Algo/
│   └── MegaDecimalAlgo.swift -- Factorial, isPrime, smallerOrEqualPrime. The heavy lifters.
├── Components/
│   ├── ButtonStyles.swift    -- Custom button styles (operation buttons, calc buttons).
│   └── BorderedViewModifier.swift -- Blue bordered text field modifier.
├── MegaCalcView.swift        -- The main SwiftUI view.
├── MegaCalcViewModel.swift   -- MVVM bridge. Parsing, dispatch, cancellation.
├── ViewExtension.swift       -- Convenience view extensions (.bordered(), .addButtonBorder()).
└── MegaCalc1App.swift        -- App entry point.
```

## Tech Stack & Why

- **Swift** — Because this is the modern Apple-platform language, and the project is a migration from an older AppKit version.
- **SwiftUI** — Because the goal is to learn SwiftUI by migrating a real app, not by building yet another todo list.
- **No external dependencies** — The entire `BigInteger` implementation is hand-rolled. This is deliberate. The project is partly an exercise in algorithm design, and partly a portable concept that's been implemented across four languages.
- **Swift Concurrency (Task/async/await)** — Long-running calculations need to be cancellable and off the main thread. The ViewModel uses `Task.detached` with `withTaskCancellationHandler` to bridge between structured concurrency and the algorithm's `isCancelled` flag.

## The Journey

### Entry: Session 1 — First Contact (2026-03-01)

**What we found:** A working calculator with a solid `BigInteger` implementation and a SwiftUI UI that's functional but uses older patterns (`ObservableObject`, `foregroundColor()`, `PreviewProvider`).

**Key observations:**
- The `BigInteger` multiplication algorithm is genuinely clever — it uses a diagonal-traversal approach across octoble pairs with overflow handling for `Int64` accumulators. There's even a `factorialFast` variant that batches native `Int64` multiplications before touching `BigInteger`.
- The division algorithm converts to a byte array and does long division digit-by-digit. Different internal representation than the rest of the class — worth noting.
- Cancellation is cooperative: algorithms check `isCancelled` inside their loops. No locks, which the code explicitly acknowledges is fine for a calculator context.
- The `MegaDecimalAlgoDelegate` protocol exists for progress reporting but isn't hooked up to the UI yet.

**Modernization needed:** The codebase needs to catch up with AGENTS.md requirements (macOS 26, `@Observable`, modern SwiftUI APIs). That's the next chapter.

## Engineer's Wisdom

### Patterns Worth Noting

1. **Cooperative cancellation over thread killing** — The algo doesn't get force-terminated. It checks a flag and throws. This is the right pattern: clean, predictable, no resource leaks.

2. **Portability through simplicity** — `IntegerList` seems over-engineered for Swift (it's just wrapping an array), but it exists because the same concept maps to `ArrayList<Integer>` in Java and `List<int>` in C#. The abstraction serves cross-language portability.

3. **Octobles as a performance choice** — Storing 8 digits per chunk means fewer iterations for large numbers compared to digit-by-digit. The 8-digit limit keeps each chunk within `Int` range while maximizing digits per slot. The multiplication code carefully handles `Int64` overflow when multiplying two octobles.

4. **TDD as a safety net** — Having `BigIntegerTests` and `IntegerListTests` means we can modernize the code with confidence. If we break the math, the tests will catch it.

## If I Were Starting Over...

- `BigInteger` as a `class` (reference type) is a historical choice. A `struct` with copy-on-write semantics might be more Swifty, but the operator overloads already create new instances, so mutation isn't a practical concern today.
- The `String` extension with integer subscripting is convenient but fragile. Modern Swift's `String` APIs or a dedicated digit-extraction method might be cleaner.
- `MegaDecimalAlgo` being a class with mutable `isCancelled` state means it's not `Sendable`. Under strict concurrency, this will need attention — possibly by making cancellation flow entirely through Swift's `Task.isCancelled` instead of a custom flag.
