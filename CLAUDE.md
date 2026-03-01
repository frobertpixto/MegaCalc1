# MegaCalc1 — Project Memory

## Overview

MegaCalc1 is a macOS arbitrary-precision integer calculator built with SwiftUI. It is a migration from an older AppKit-based `MegaCalc` app. The project implements its own `BigInteger` type from scratch (no external dependencies) and provides operations like addition, subtraction, multiplication, division, modulo, factorial, primality testing, and finding the largest prime ≤ N.

The project has historical roots going back to 1993 (C++ on MS-DOS), and has been reimplemented over the years in C#, Java, and now Swift.

## Architecture

**MVVM pattern:**

- **Model layer** — `BigInteger` (backed by `IntegerList`) stores numbers as lists of 8-digit "octoble" chunks. `MegaDecimalAlgo` provides higher-level algorithms (factorial, isPrime, smallerOrEqualPrime).
- **ViewModel** — `MegaCalcViewModel` bridges the UI and algorithms. Currently uses `ObservableObject`/`@Published` (targeted for migration to `@Observable`).
- **View** — `MegaCalcView` with operand rows and a button grid.

**Concurrency:** Long-running operations (factorial, prime checks) run via `Task.detached` off the main actor, with cancellation propagated through `MegaDecimalAlgo.isCancelled`.

## Key Conventions

- Target: macOS 26.0+, Swift 6.2+ (per AGENTS.md)
- No third-party dependencies
- Custom `BigInteger` type — not Swift's built-in numerics
- Numbers stored internally as octobles (8-digit `Int` chunks) in little-endian order
- Algorithms check `isCancelled` inside tight loops for interruptibility
- TDD approach: unit tests for `BigInteger` and `IntegerList` exist

## Build / Run

- Open `MegaCalc1.xcodeproj` in Xcode
- Build and run targeting macOS
- Unit tests: `MegaCalc1Tests` target (BigInteger, IntegerList tests)
- UI tests: `MegaCalc1UITests` target (stubs)

## Gotchas

- `BigInteger` is a reference type (`class`), not a value type. Operator overloads create new instances to avoid mutation issues.
- Division/modulo convert to a byte array for long-division; this is a different internal representation than the octoble list used elsewhere.
- The `factorialFast` variant in `MegaDecimalAlgo` exists but is not exposed through the ViewModel.
- `MegaDecimalAlgoDelegate` is defined but not wired to the UI — progress reporting is a TODO.
- The square root approximation for large-number primality tests uses a coarse `exp10`-based method. TODOs in the code describe better approaches.

## Modernization Status

The codebase predates several AGENTS.md requirements:
- Uses `ObservableObject`/`@Published`/`@StateObject` — needs migration to `@Observable`
- Uses `foregroundColor()` — should become `foregroundStyle()`
- Uses hardcoded UIKit-style colors — should use SwiftUI semantic colors
- Uses `PreviewProvider` — should migrate to `#Preview` macro
