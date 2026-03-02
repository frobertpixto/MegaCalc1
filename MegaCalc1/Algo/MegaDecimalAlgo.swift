//
//  MegaDecimalAlgo.swift
//  Calc1
//
//  Created by Francois Robert on 2016-12-02.
//  Copyright © 2016 Pixtolab. All rights reserved.
//

import Foundation
import Synchronization

enum MegaDecimalAlgoError: Error {
	case cancelled
	case doesNotExists
}

final class MegaDecimalAlgo: Sendable {
	private let _isCancelled = Mutex(false)
	/// Progress of the current factorial operation, 0.0 to 1.0
	private let _progress = Mutex(0.0)

	var isCancelled: Bool {
		_isCancelled.withLock { $0 }
	}

	/// Current factorial progress (0.0 … 1.0). Thread-safe.
	var progress: Double {
		_progress.withLock { $0 }
	}

	func cancel() {
		_isCancelled.withLock { $0 = true }
	}

	func factorial(_ a: Int64) throws -> BigInteger {
		prepare()

		// Early exits
		if a < 1 {
			return BigInteger(0)
		}

		if a < 3 {
			_progress.withLock { $0 = 1.0 }
			return BigInteger(a)
		}

		var fact = BigInteger(2)
		let total = Double(a - 2) // number of iterations (3...a)

		// Iterate
		for number in 3...a {
			fact *= BigInteger(number)

			// Update progress periodically (every 100 iterations to reduce lock contention)
			if number % 100 == 0 || number == a {
				let current = Double(number - 2)
				_progress.withLock { $0 = current / total }
			}

			if isCancelled {
				throw MegaDecimalAlgoError.cancelled
			}
		}

		return fact
	}

	func factorialFast(_ a: Int64) throws -> BigInteger {
		prepare()

		// Early exits
		if a < 1 {
			return BigInteger(0)
		}

		if a < 3 {
			return BigInteger(a)
		}

		var fact = BigInteger(2)

		var multAccumulator: Int64 = 1

		let maxAccumulatorValue: Int64 = INT64_MAX / 100_000

		// Iterate
		outerFor: for number in 3...a {
			while multAccumulator < maxAccumulatorValue && number < a {
				multAccumulator *= number
				continue outerFor
			}

			fact *= BigInteger(multAccumulator)

			if number == a {
				fact *= BigInteger(a)
			}

			multAccumulator = number

			if isCancelled {
				throw MegaDecimalAlgoError.cancelled
			}
		}

		return fact
	}

	func isPrime(_ a: BigInteger) throws -> Bool {
		prepare()

		guard a > BigInteger(1) else {
			return false
		}

		let zero  = BigInteger(0)
		let two   = BigInteger(2)
		let three = BigInteger(3)

		// 2 and 3 are prime
		if a == two || a == three {
			return true
		}

		// Eliminate even numbers and multiples of 3
		if try a % two == zero {
			return false
		}
		if try a % three == zero {
			return false
		}

		// Calculate the upper bound for trial division (√a)
		var maxCheck = BigInteger()
		let digitCount = a.digitCount()

		if digitCount < 19 {
			if let aNum = Double(a.toString()) {
				maxCheck = BigInteger(Int64(floor(sqrt(aNum))))
			} else {
				assert(false, "Double(a.toString()) failed")
			}
		} else {
			maxCheck = try getUpperSquareRootApproximation(a: a)
		}

		// Trial division using 6k±1 optimization:
		// All primes > 3 are of the form 6k±1, so we only need to check those candidates.
		var factor = BigInteger(5)
		let six = BigInteger(6)

		while factor <= maxCheck {
			// Check 6k-1
			if try a % factor == zero {
				return false
			}

			// Check 6k+1
			let factorPlus2 = factor + two
			if factorPlus2 <= maxCheck {
				if try a % factorPlus2 == zero {
					return false
				}
			}

			factor += six

			if isCancelled {
				throw MegaDecimalAlgoError.cancelled
			}
		}

		return true
	}

	func smallerOrEqualPrime(_ a: BigInteger) throws -> BigInteger {
		prepare()

		guard a > BigInteger(1) else {
			throw MegaDecimalAlgoError.doesNotExists
		}

		let zero  = BigInteger(0)
		let one   = BigInteger(1)
		let two   = BigInteger(2)
		let three = BigInteger(3)
		let six   = BigInteger(6)

		var currentValue = a

		while currentValue.isPositive {
			// Handle small values directly
			if currentValue == two || currentValue == three {
				break
			}

			// Quick rejection: divisible by 2 or 3
			if try currentValue % two == zero || currentValue % three == zero {
				currentValue -= one
				continue
			}

			// Calculate upper bound for trial division (√currentValue)
			var maxCheck = BigInteger()

			if currentValue.digitCount() < 19 {
				if let aNum = Double(currentValue.toString()) {
					maxCheck = BigInteger(Int64(floor(sqrt(aNum))))
				} else {
					assert(false, "Double(currentValue.toString()) failed")
				}
			} else {
				maxCheck = try getUpperSquareRootApproximation(a: currentValue)
			}

			// Trial division using 6k±1 optimization
			var factor = BigInteger(5)
			var foundFactor = false

			while factor <= maxCheck {
				// Check 6k-1
				if try currentValue % factor == zero {
					foundFactor = true
					break
				}

				// Check 6k+1
				let factorPlus2 = factor + two
				if factorPlus2 <= maxCheck {
					if try currentValue % factorPlus2 == zero {
						foundFactor = true
						break
					}
				}

				factor += six

				if isCancelled {
					throw MegaDecimalAlgoError.cancelled
				}
			}

			if foundFactor {
				currentValue -= one
			} else {
				// No factor found — currentValue is prime
				break
			}
		}

		return currentValue
	}

	///
	/// We want an approximation of the root number, something like BigInteger(Int64(floor(sqrt(a))))
	/// Required to set a upper limit for Prime number evaluation as the max factor of a is the square root of a.
	///
	/// - parameter a:  The Operand
	/// - returns:  a good fast approximation
	private func getUpperSquareRootApproximation(a: BigInteger) throws -> BigInteger {
		// Find a Exp10 value that is fast.
		// Use the following approximation. Fast to compute and smaller than a division by 2.
		// 0..10				: 10
		// 11..100				: 10
		// 101..1_000			: 100
		// 1_001..10_000		: 100
		// 10_001..100_000		: 1000
		// 100_001..1_000_000	: 1000
		// and so on...
		let nbDigits = a.digitCount()
		let exponent = ((nbDigits - 1) / 2) + 1
		let upperSquareRootApproximation = BigInteger(1).exp10(exponent)

		return upperSquareRootApproximation

		// TODO Calculate a better approximation using a table of the squares between 1 and 10 that we are going to apply to the the first 2 non-zero digits. Lets call this sqrt100 (upper square based on table)
		// Ex: sqrt100(33) = 6, sqrt100(36) = 6, sqrt100(37) = 7
		// 0..100					: 1*sqrt100.      Ex: 55     -> 8   > Actual Max: 7
		// 101..10_000  			: 10*sqrt100      Ex: 5512   -> 80  > Actual Max: 74
		// 10_001..1_000_000	   : 100*sqrt100     Ex: 551234 -> 800 > Actual Max: 742
		// and so on...

		// Maybe we could do something even better by extracting the first 18 digits DDD (well find the biggest integer size for which we can evaluate the square root using a standard method),
		// Then we compute SSS = int(sqrt(DDD)+1) and we approximate the upper square root of BigInteger `a` as `a` where DDD is replaced by AAA.
		// TODO: verify the impact of a even number of digit vs odd number for `a`
	}

	private func prepare() {
		_isCancelled.withLock { $0 = false }
		_progress.withLock { $0 = 0.0 }
	}
}
