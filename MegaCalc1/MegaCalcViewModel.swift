import SwiftUI

@MainActor
@Observable
final class MegaCalcViewModel {
    // UI-facing state
    var aText: String = "111111"
    var bText: String = "2222"
    var resultText: String = ""
    var isBusy: Bool = false

    /// Formatted duration of the last completed operation
    var durationText: String = ""
    /// Factorial progress (0.0 … 1.0), only meaningful while a factorial is running
    var factorialProgress: Double = 0.0
    /// Whether a factorial operation is currently running (drives progress bar visibility)
    var isFactorialRunning: Bool = false

    // Dependencies
    private let algo = MegaDecimalAlgo()

    // Track the currently running task to support cancellation
    private var currentTask: Task<Void, Never>? = nil
    // Timer task that polls algo.progress for factorial operations
    private var progressPollTask: Task<Void, Never>? = nil

    // Errors (localize later)
    enum CalcError: LocalizedError {
        case invalidA
        case invalidB
        case divideByZero
        case tooBigForOperation
        case cancelled
        case doesNotExist
        case other(String)

        var errorDescription: String? {
            switch self {
            case .invalidA: return "Invalid number A"
            case .invalidB: return "Invalid number B"
            case .divideByZero: return "Divide by Zero"
            case .tooBigForOperation: return "Number too Big for operation"
            case .cancelled: return "Cancelled"
            case .doesNotExist: return "Does Not exists"
            case .other(let message): return message
            }
        }
    }

    // MARK: - Public UI actions

    func setResultToA() { aText = resultText }
    func setResultToB() { bText = resultText }

    func cancel() {
        // Cancel any running task and propagate to the algorithm
        currentTask?.cancel()
        algo.cancel()
    }

    // Binary operations (fast/synchronous)
    func add() { performBinary { $0 + $1 } }
    func subtract() { performBinary { $0 - $1 } }
    func multiply() { performBinary { $0 * $1 } }

    func divide() {
        performBinaryThrowing { a, b in
            do { return try a / b }
            catch BigIntegerError.divideByZero { throw CalcError.divideByZero }
            catch { throw CalcError.other(error.localizedDescription) }
        }
    }

    func modulo() {
        performBinaryThrowing { a, b in
            do { return try a % b }
            catch BigIntegerError.divideByZero { throw CalcError.divideByZero }
            catch { throw CalcError.other(error.localizedDescription) }
        }
    }

    // Unary / long‑running operations (use Swift Concurrency)
    func factorial() {
        switch parseA() {
        case .failure(let error):
            resultText = error.localizedDescription
        case .success(let a):
            let algo = self.algo
            startFactorialTask {
                let outcome: Result<String, CalcError> = await self.runBlockingWithCancellation { [algo] in
                    do {
                        let r = try algo.factorial(a.toInt())
                        return .success(r.toString())
                    }
                    catch MegaDecimalAlgoError.cancelled { return .failure(.cancelled) }
                    catch BigIntegerError.tooBigForInt64 { return .failure(.tooBigForOperation) }
                    catch { return .failure(.other(error.localizedDescription)) }
                }
                self.apply(outcome)
            }
        }
    }

    func isPrime() {
        switch parseA() {
        case .failure(let error):
            resultText = error.localizedDescription
        case .success(let a):
            let algo = self.algo
            startTask {
                let outcome: Result<String, CalcError> = await self.runBlockingWithCancellation { [algo] in
                    do {
                        let text = try algo.isPrime(a) ? "Yes" : "No"
                        return .success(text)
                    }
                    catch MegaDecimalAlgoError.cancelled { return .failure(.cancelled) }
                    catch { return .failure(.other(error.localizedDescription)) }
                }
                self.apply(outcome)
            }
        }
    }

    func primeSmallerOrEqual() {
        switch parseA() {
        case .failure(let error):
            resultText = error.localizedDescription
        case .success(let a):
            let algo = self.algo
            startTask {
                let outcome: Result<String, CalcError> = await self.runBlockingWithCancellation { [algo] in
                    do {
                        let r = try algo.smallerOrEqualPrime(a)
                        return .success(r.toString())
                    }
                    catch MegaDecimalAlgoError.cancelled { return .failure(.cancelled) }
                    catch MegaDecimalAlgoError.doesNotExists { return .failure(.doesNotExist) }
                    catch { return .failure(.other(error.localizedDescription)) }
                }
                self.apply(outcome)
            }
        }
    }

    // MARK: - Parsing

    private func parseAB() -> Result<(BigInteger, BigInteger), CalcError> {
        guard let a = aText.isEmpty ? BigInteger(0) : BigInteger(aText) else {
            return .failure(.invalidA)
        }
        guard let b = bText.isEmpty ? BigInteger(0) : BigInteger(bText) else {
            return .failure(.invalidB)
        }
        return .success((a, b))
    }

    private func parseA() -> Result<BigInteger, CalcError> {
        guard let a = aText.isEmpty ? BigInteger(0) : BigInteger(aText) else {
            return .failure(.invalidA)
        }
        return .success(a)
    }

    // MARK: - Duration formatting

    private static func formatDuration(_ seconds: Double) -> String {
        if seconds < 1.0 {
            let ms = Int(seconds * 1000)
            return "\(ms) ms"
        } else if seconds < 60.0 {
            return String(format: "%.1f s", seconds)
        } else {
            let totalSeconds = Int(seconds)
            let m = totalSeconds / 60
            let s = totalSeconds % 60
            return "\(m)m \(s)s"
        }
    }

    // MARK: - Operation helpers

    private func performBinary(_ op: (BigInteger, BigInteger) -> BigInteger) {
        // Cancel any long-running task if a quick binary op is requested
        currentTask?.cancel()
        switch parseAB() {
        case .failure(let error):
            resultText = error.localizedDescription
        case .success(let (a, b)):
            let start = ContinuousClock.now
            let r = op(a, b)
            let elapsed = ContinuousClock.now - start
            resultText = r.toString()
            durationText = Self.formatDuration(elapsed.seconds)
        }
    }

    private func performBinaryThrowing(_ op: (BigInteger, BigInteger) throws -> BigInteger) {
        // Cancel any long-running task if a quick binary op is requested
        currentTask?.cancel()
        switch parseAB() {
        case .failure(let error):
            resultText = error.localizedDescription
        case .success(let (a, b)):
            do {
                let start = ContinuousClock.now
                let r = try op(a, b)
                let elapsed = ContinuousClock.now - start
                resultText = r.toString()
                durationText = Self.formatDuration(elapsed.seconds)
            } catch let e as CalcError {
                resultText = e.localizedDescription
            } catch {
                resultText = error.localizedDescription
            }
        }
    }

    // Starts a new Task, ensures only one long-running task at a time
    private func startTask(_ operation: @escaping () async -> Void) {
        currentTask?.cancel()
        isBusy = true
        durationText = ""
        currentTask = Task {
            defer { isBusy = false }
            await operation()
        }
    }

    /// Starts a factorial-specific task with progress polling
    private func startFactorialTask(_ operation: @escaping () async -> Void) {
        currentTask?.cancel()
        progressPollTask?.cancel()
        isBusy = true
        isFactorialRunning = true
        factorialProgress = 0.0
        durationText = ""

        // Poll algo.progress at ~20 Hz for smooth UI updates
        let algo = self.algo
        progressPollTask = Task {
            while !Task.isCancelled {
                self.factorialProgress = algo.progress
                try? await Task.sleep(for: .milliseconds(50))
            }
        }

        currentTask = Task {
            defer {
                isBusy = false
                isFactorialRunning = false
                factorialProgress = 1.0
                progressPollTask?.cancel()
                progressPollTask = nil
            }
            await operation()
        }
    }

    // Runs blocking work off the main actor, with cancellation propagating to the algorithm
    private func runBlockingWithCancellation(_ work: @escaping @Sendable () -> Result<String, CalcError>) async -> Result<String, CalcError> {
        let localAlgo = self.algo
        let start = ContinuousClock.now
        let result = await withTaskCancellationHandler(operation: {
            // Run the blocking work off the main actor
            await Task.detached(priority: .userInitiated) { () -> Result<String, CalcError> in
                return work()
            }.value
        }, onCancel: { [localAlgo] in
            localAlgo.cancel()
        })
        let elapsed = ContinuousClock.now - start
        durationText = Self.formatDuration(elapsed.seconds)
        return result
    }

    private func apply(_ outcome: Result<String, CalcError>) {
        switch outcome {
            case .success(let text):
                self.resultText = text
            case .failure(let error):
                self.resultText = error.localizedDescription
        }
    }
}

// MARK: - Duration extension

private extension Duration {
    var seconds: Double {
        let (s, atto) = self.components
        return Double(s) + Double(atto) * 1e-18
    }
}
