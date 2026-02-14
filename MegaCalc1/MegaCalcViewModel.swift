import SwiftUI

@MainActor
final class MegaCalcViewModel: ObservableObject {
    // UI-facing state
    @Published var aText: String = "111111"
    @Published var bText: String = "2222"
    @Published var resultText: String = ""
    @Published var isBusy: Bool = false

    // Dependencies
    private let algo = MegaDecimalAlgo()

    // Track the currently running task to support cancellation
    private var currentTask: Task<Void, Never>? = nil

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
            startTask {
                let outcome: Result<String, CalcError> = await self.runBlockingWithCancellation {
                    do {
                        let r = try self.algo.factorial(a.toInt())
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
            startTask {
                let outcome: Result<String, CalcError> = await self.runBlockingWithCancellation {
                    do {
                        let text = try self.algo.isPrime(a) ? "Yes" : "No"
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
            startTask {
                let outcome: Result<String, CalcError> = await self.runBlockingWithCancellation {
                    do {
                        let r = try self.algo.smallerOrEqualPrime(a)
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

    // MARK: - Operation helpers

    private func performBinary(_ op: @escaping (BigInteger, BigInteger) -> BigInteger) {
        // Cancel any long-running task if a quick binary op is requested
        currentTask?.cancel()
        switch parseAB() {
        case .failure(let error):
            resultText = error.localizedDescription
        case .success(let (a, b)):
            let r = op(a, b)
            resultText = r.toString()
        }
    }

    private func performBinaryThrowing(_ op: @escaping (BigInteger, BigInteger) throws -> BigInteger) {
        // Cancel any long-running task if a quick binary op is requested
        currentTask?.cancel()
        switch parseAB() {
        case .failure(let error):
            resultText = error.localizedDescription
        case .success(let (a, b)):
            do {
                let r = try op(a, b)
                resultText = r.toString()
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
        currentTask = Task { [weak self] in
            guard let self = self else { return }
            defer { self.isBusy = false }
            await operation()
        }
    }

    // Runs blocking work off the main actor, with cancellation propagating to the algorithm
    private func runBlockingWithCancellation(_ work: @escaping () -> Result<String, CalcError>) async -> Result<String, CalcError> {
        return await withTaskCancellationHandler {
            // Cancellation handler
            self.algo.cancel()
        } operation: {
            await Task.detached(priority: .userInitiated) { () -> Result<String, CalcError> in
                return work()
            }.value
        }
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
