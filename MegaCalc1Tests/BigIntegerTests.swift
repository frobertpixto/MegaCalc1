//
//  BigIntegerTests.swift
//  Calc1
//
//  Created by Francois Robert on 2016-11-23.
//  Copyright © 2016 Pixtolab. All rights reserved.
//

import Testing
@testable import MegaCalc1

@Suite struct BigIntegerTests {

	@Test func toString0() {
		var target = BigInteger()
		var expected = "0"
		var actual = target.toString()

		#expect(expected == actual)

		target = BigInteger(0)
		expected = "0"
		actual = target.toString()

		#expect(expected == actual)

		target = BigInteger(-0)
		expected = "0"
		actual = target.toString()

		target = BigInteger(0, hasReversedSign: false)
		expected = "0"
		actual = target.toString()

		#expect(expected == actual)

		target = BigInteger(0, hasReversedSign: true)
		expected = "0"
		actual = target.toString()

		#expect(expected == actual)

		target = BigInteger(-0, hasReversedSign: true)
		expected = "0"
		actual = target.toString()

		#expect(expected == actual)

		var targetB = BigInteger("")
		#expect(targetB == nil)

		targetB = BigInteger("-")
		#expect(targetB == nil)

		targetB = BigInteger("+")
		#expect(targetB == nil)

		targetB = BigInteger("+12a")
		#expect(targetB == nil)

		targetB = BigInteger("12a")
		#expect(targetB == nil)

		targetB = BigInteger(" 12")
		#expect(targetB == nil)

		targetB = BigInteger("12 ")
		#expect(targetB == nil)

		targetB = BigInteger("12 123")
		#expect(targetB == nil)

		targetB = BigInteger("12a123")
		#expect(targetB == nil)

		var targetC = BigInteger("0")
		#expect(targetC != nil)
		expected = "0"
		actual = targetC!.toString()

		#expect(expected == actual)

		targetC = BigInteger("+0")
		#expect(targetC != nil)
		expected = "0"
		actual = targetC!.toString()

		#expect(expected == actual)

		targetC = BigInteger("-0")
		#expect(targetC != nil)
		expected = "0"
		actual = targetC!.toString()

		#expect(expected == actual)

		targetC = BigInteger("-0000000000")
		#expect(targetC != nil)
		expected = "0"
		actual = targetC!.toString()

		#expect(expected == actual)

		targetC = BigInteger("0000000000")
		#expect(targetC != nil)
		expected = "0"
		actual = targetC!.toString()

		#expect(expected == actual)

		targetC = BigInteger("-0000000000", hasReversedSign: true)
		#expect(targetC != nil)
		expected = "0"
		actual = targetC!.toString()

		#expect(expected == actual)

		targetC = BigInteger("0000000000", hasReversedSign: false)
		#expect(targetC != nil)
		expected = "0"
		actual = targetC!.toString()

		#expect(expected == actual)
	}

	@Test func toString01() {
		var target = BigInteger(123)
		var expected = "123"
		var actual = target.toString()

		#expect(expected == actual)

		target = BigInteger(12345)
		expected = "12345"
		actual = target.toString()

		#expect(expected == actual)

		target = BigInteger(-12346)
		expected = "-12346"
		actual = target.toString()

		#expect(expected == actual)

		let targetB = BigInteger(target)
		expected = "-12346"
		actual = targetB.toString()

		#expect(expected == actual)

		target = BigInteger(12346, hasReversedSign: true)
		expected = "-12346"
		actual = target.toString()

		target = BigInteger(-12346, hasReversedSign: true)
		expected = "12346"
		actual = target.toString()

		#expect(expected == actual)

		target = BigInteger(-12346, hasReversedSign: false)
		expected = "-12346"
		actual = target.toString()

		#expect(expected == actual)

		let targetc = BigInteger(target, hasReversedSign: true)
		expected = "12346"
		actual = targetc.toString()

		#expect(expected == actual)

		var targetd = BigInteger(targetc, hasReversedSign: false)
		expected = "12346"
		actual = targetd.toString()

		#expect(expected == actual)

		targetd = BigInteger(targetc, hasReversedSign: true)
		expected = "-12346"
		actual = targetd.toString()

		#expect(expected == actual)

		targetd = BigInteger(targetd, hasReversedSign: false)
		expected = "-12346"
		actual = targetd.toString()

		#expect(expected == actual)

		targetd = BigInteger(targetd, hasReversedSign: true)
		expected = "12346"
		actual = targetd.toString()

		#expect(expected == actual)
	}

	@Test func toString02() {
		var target = BigInteger("123")
		#expect(target != nil)
		var expected = "123"
		var actual = target!.toString()

		#expect(expected == actual)

		target = BigInteger("12345")
		#expect(target != nil)
		expected = "12345"
		actual = target!.toString()

		#expect(expected == actual)

		target = BigInteger("12345", hasReversedSign: true)
		#expect(target != nil)
		expected = "-12345"
		actual = target!.toString()

		#expect(expected == actual)

		target = BigInteger("12345678901234567890")
		#expect(target != nil)
		expected = "12345678901234567890"
		actual = target!.toString()

		#expect(expected == actual)

		target = BigInteger("100000000010000000001")
		#expect(target != nil)
		expected = "100000000010000000001"
		actual = target!.toString()

		#expect(expected == actual)
	}

	@Test func toInt() throws {
		let target = BigInteger("123")
		#expect(target != nil)

		var actual = try target!.toInt()
		#expect(actual == 123)

		let target2 = BigInteger("-123")
		#expect(target2 != nil)

		actual = try target2!.toInt()
		#expect(actual == -123)

		let target3 = BigInteger()
		actual = try target3.toInt()
		#expect(actual == 0)

		let target4 = BigInteger("123456789012345678")
		#expect(target4 != nil)

		actual = try target4!.toInt()
		#expect(actual == 123456789012345678)

		let target5 = BigInteger("12345678901234567890123")
		#expect(target5 != nil)

		#expect(throws: BigIntegerError.tooBigForInt64) {
			_ = try target5!.toInt()
		}

		let target6 = BigInteger("-12345678901234567890123")
		#expect(target6 != nil)

		#expect(throws: BigIntegerError.tooBigForInt64) {
			_ = try target6!.toInt()
		}
	}

	@Test func isZero() {
		var target = BigInteger()
		#expect(target.isNumberZero() == true)

		target = BigInteger(0)
		#expect(target.isNumberZero() == true)

		target = BigInteger(0)
		#expect(target.isNumberZero() == true)

		target = BigInteger(123)
		#expect(target.isNumberZero() == false)

		target = BigInteger(-12346)
		#expect(target.isNumberZero() == false)
	}

	@Test func negate() {
		var target = BigInteger(0)
		target = -target
		var expected = "0"
		var actual = target.toString()

		#expect(expected == actual)

		target = BigInteger(123)
		target = -target
		expected = "-123"
		actual = target.toString()

		#expect(expected == actual)

		target = BigInteger(-12346)
		target = -target
		expected = "12346"
		actual = target.toString()

		#expect(expected == actual)
	}

	@Test func add01() {
		var a = BigInteger(123456)
		var b = BigInteger(111111)

		var expected = "234567"
		var actual = (a + b).toString()
		#expect(expected == actual)

		a = BigInteger(123456)
		b = BigInteger(0)

		expected = "123456"
		actual = (a + b).toString()
		#expect(expected == actual)

		a = BigInteger("123456")!
		b = BigInteger("0")!

		expected = "123456"
		actual = (a + b).toString()
		#expect(expected == actual)

		a = BigInteger("900000000001")!
		b = BigInteger("111111111111")!

		expected = "1011111111112"
		actual = (a + b).toString()
		#expect(expected == actual)

		a = BigInteger("12345999999999999999999999999995999999999999999999999999999999")!
		b = BigInteger(1)

		expected = "12345999999999999999999999999996000000000000000000000000000000"
		actual = (a + b).toString()
		#expect(expected == actual)
	}

	@Test func add02() {
		var a = BigInteger(123456)
		a += BigInteger(111111)

		var expected = "234567"
		var actual = a.toString()
		#expect(expected == actual)

		a = BigInteger(123456)
		a += BigInteger(0)

		expected = "123456"
		actual = a.toString()
		#expect(expected == actual)

		a = BigInteger(-123456)
		a += BigInteger(0)

		expected = "-123456"
		actual = a.toString()
		#expect(expected == actual)

		a = BigInteger(123456)
		a += BigInteger(1111111111)

		expected = "1111234567"
		actual = a.toString()
		#expect(expected == actual)

		a = BigInteger(-1)
		a += BigInteger(1)

		expected = "0"
		actual = a.toString()
		#expect(expected == actual)

		a = BigInteger(1)
		a += BigInteger(-1)

		expected = "0"
		actual = a.toString()
		#expect(expected == actual)
	}

	@Test func add03() {
		var a = BigInteger(123456)
		var b = BigInteger(-111111)

		var expected = "12345"
		var actual = (a + b).toString()
		#expect(expected == actual)

		a = BigInteger(-123456)
		b = BigInteger(-111111)

		expected = "-234567"
		actual = (a + b).toString()
		#expect(expected == actual)

		a = BigInteger(-123456)
		b = BigInteger(+111111)

		expected = "-12345"
		actual = (a + b).toString()
		#expect(expected == actual)

		a = BigInteger("9999999")!
		b = BigInteger("-11111111")!

		expected = "-1111112"
		actual = (a + b).toString()
		#expect(expected == actual)

		a = BigInteger("10000000000000000000000000000000000000000000000000000001")!
		b = BigInteger("122")!

		expected = "10000000000000000000000000000000000000000000000000000123"
		actual = (a + b).toString()
		#expect(expected == actual)
	}

	@Test func subtract01() {
		var a = BigInteger(123456)
		var b = BigInteger(111111)

		var expected = "12345"
		var actual = (a - b).toString()
		#expect(expected == actual)

		a = BigInteger(12)
		b = BigInteger(12)

		expected = "0"
		actual = (a - b).toString()
		#expect(expected == actual)

		a = BigInteger(-12)
		b = BigInteger(123)

		expected = "-135"
		actual = (a - b).toString()
		#expect(expected == actual)

		a = BigInteger(0)
		b = BigInteger(123)

		expected = "-123"
		actual = (a - b).toString()
		#expect(expected == actual)

		a = BigInteger(-2)
		b = BigInteger(-5)

		expected = "3"
		actual = (a - b).toString()
		#expect(expected == actual)

		a = BigInteger(-2)
		b = BigInteger(5)

		expected = "-7"
		actual = (a - b).toString()
		#expect(expected == actual)

		a = BigInteger(-2)
		b = BigInteger(-5)

		expected = "3"
		actual = (a - b).toString()
		#expect(expected == actual)

		a = BigInteger(2)
		b = BigInteger(-5)

		expected = "7"
		actual = (a - b).toString()
		#expect(expected == actual)

		a = BigInteger(2)
		b = BigInteger(5)

		expected = "-3"
		actual = (a - b).toString()
		#expect(expected == actual)

		a = BigInteger(2)
		b = BigInteger(55555)

		expected = "-55553"
		actual = (a - b).toString()
		#expect(expected == actual)

		a = BigInteger("-12345600000000000000000000000000000000000000000000000002")!
		b = BigInteger("-1111100000000000000000000000000000000000000000000000003")!

		expected = "-11234499999999999999999999999999999999999999999999999999"
		actual = (a - b).toString()
		#expect(expected == actual)
	}

	@Test func multiply01() {
		var a = BigInteger(0)
		var b = BigInteger(0)

		var expected = "0"
		var actual = (a * b).toString()
		#expect(expected == actual)

		a = BigInteger(12)
		b = BigInteger(12)

		expected = "144"
		actual = (a * b).toString()
		#expect(expected == actual)

		a = BigInteger(-11111)
		b = BigInteger(11111)

		expected = "-123454321"
		actual = (a * b).toString()
		#expect(expected == actual)

		a = BigInteger("-785412354123")!
		b = BigInteger("-123456789123456785101")!

		expected = "96964487377920975265633722321423"
		actual = (a * b).toString()
		#expect(expected == actual)

		a = BigInteger("10010000000000000000000000000001001")!
		b = BigInteger("999999999999999999999999999999999999999999999999999999999")!

		expected = "10010000000000000000000000000001000999999999999999999999989989999999999999999999999999998999"
		actual = (a * b).toString()
		#expect(expected == actual)

		a = BigInteger("0069157773088223225864010172804473666134839612717689")!
		b = BigInteger("0069157773088223225864010172804473666134839612717689")!

		expected = "4782797578522172663045226382857279875811551873069814817049653711727111813236706913604357108413500721"
		actual = (a * b).toString()
		#expect(expected == actual)

		a = BigInteger("0069157773088223225864010172804473666134839612717689")!
		b = BigInteger("0")!

		expected = "0"
		actual = (a * b).toString()
		#expect(expected == actual)

		a = BigInteger("9999999999999999999999999999999999999")!
		b = BigInteger("9999999999999999999999999999999999999")!

		expected = "99999999999999999999999999999999999980000000000000000000000000000000000001"
		actual = (a * b).toString()
		#expect(expected == actual)

		a = BigInteger("9999999999999999999999999999999999999")!
		b = BigInteger("1111111111111111111111111111111111111")!

		expected = "11111111111111111111111111111111111108888888888888888888888888888888888889"
		actual = (a * b).toString()
		#expect(expected == actual)

		a = BigInteger("1111111111111111111111111111111111111111111111111111111111")!
		b = BigInteger("1111111111111111111111111111111111111111111111111111111111")!

		expected = "1234567901234567901234567901234567901234567901234567901234320987654320987654320987654320987654320987654320987654321"
		actual = (a * b).toString()
		#expect(expected == actual)

		a = BigInteger("1")!
		b = BigInteger("2")!

		expected = "120"
		actual = (a * b * BigInteger(3) * BigInteger(4) * BigInteger(5)).toString()
		#expect(expected == actual)
	}

	@Test func divide01() throws {
		let a = BigInteger(0)
		let b = BigInteger(0)

		#expect(throws: BigIntegerError.divideByZero) {
			_ = try (a / b).toString()
		}

		let a2 = BigInteger(66)
		let b2 = BigInteger(2)

		let actual = try (a2 / b2).toString()
		#expect(actual == "33")
	}

	@Test func divide02() throws {
		var a = BigInteger("99999999999999999999999999")!
		var b = BigInteger(3)

		var actual = try (a / b).toString()
		#expect(actual == "33333333333333333333333333")

		a = BigInteger("99999999999999999999999999")!
		b = BigInteger("-9")!

		actual = try (a / b).toString()
		#expect(actual == "-11111111111111111111111111")

		a = BigInteger("60000000000000000000")!
		b = BigInteger("50")!

		actual = try (a / b).toString()
		#expect(actual == "1200000000000000000")

		a = BigInteger("-600000000000000000000")!
		b = BigInteger("50")!

		actual = try (a / b).toString()
		#expect(actual == "-12000000000000000000")

		a = BigInteger("6000000000000000000000001")!
		b = BigInteger("-500000")!

		actual = try (a / b).toString()
		#expect(actual == "-12000000000000000000")

		a = BigInteger("66666666666666666666666666666666666666666666666666666666666660001")!
		b = BigInteger("6666666666666666666666666666666666666666666666666666666666666")!

		actual = try (a / b).toString()
		#expect(actual == "10000")

		a = BigInteger("-987654321123456789987654")!
		b = BigInteger("-65432189")!

		actual = try (a / b).toString()
		#expect(actual == "15094318808796948")

		a = BigInteger("11111111111111111111111111111111111108888888888888888888888888888888888889")!
		b = BigInteger("9999999999999999999999999999999999999")!

		actual = try (a / b).toString()
		#expect(actual == "1111111111111111111111111111111111111")
	}

	@Test func modulo01() throws {
		let a = BigInteger(5)
		let b = BigInteger(0)

		#expect(throws: BigIntegerError.divideByZero) {
			_ = try (a % b).toString()
		}

		let a2 = BigInteger(-67)
		let b2 = BigInteger(2)

		var actual = try (a2 % b2).toString()
		#expect(actual == "-1")

		let a3 = BigInteger(30)
		let b3 = BigInteger(50)

		actual = try (a3 % b3).toString()
		#expect(actual == "30")

		let a4 = BigInteger(0)
		let b4 = BigInteger(50)

		actual = try (a4 % b4).toString()
		#expect(actual == "0")
	}

	@Test func modulo02() throws {
		var a = BigInteger("128000000000000000000000000000000000000000000000345")!
		var b = BigInteger("-50000000000000000000000000000000000000000000")!

		var actual = try (a % b).toString()
		#expect(actual == "345")

		a = BigInteger("-128000000000000000000000000000000000000000345")!
		b = BigInteger("100")!

		actual = try (a % b).toString()
		#expect(actual == "-45")

		a = BigInteger("128000000000000000000000000000000000000000345")!
		b = BigInteger("100000000000000000000000000000000000000")!

		actual = try (a % b).toString()
		#expect(actual == "345")

		a = BigInteger("128000000000000000000000000000000000000000345")!
		b = BigInteger("128000000000000000000000000000000000000000000")!

		actual = try (a % b).toString()
		#expect(actual == "345")
	}

	@Test func greaterThan() {
		var a = BigInteger(123456)
		var b = BigInteger(111111)

		#expect(a > b)

		a = BigInteger(+123456)
		b = BigInteger(-511111)

		#expect(a > b)

		a = BigInteger(+123456)
		b = BigInteger(0)

		#expect(a > b)

		a = BigInteger(-523456)
		b = BigInteger(+111111)

		#expect(!(a > b))

		a = BigInteger(-123456)
		b = BigInteger(0)

		#expect(!(a > b))

		a = BigInteger(-123456)
		b = BigInteger(-111111)

		#expect(!(a > b))

		a = BigInteger(-111111)
		b = BigInteger(-123456)

		#expect(a > b)

		a = BigInteger(-111111)
		b = BigInteger(-111111)

		#expect(!(a > b))

		a = BigInteger("123456740000000000000000000000000000000000000000000000000000000000000000000000005")!
		b = BigInteger("123456740000000000000000000000000000000000000000000000000000000000000000000000006")!

		#expect(!(a > b))

		a = BigInteger("12345674000000000000000000000000000000000000000000005")!
		b = BigInteger("123456740000000000000000000000000000000000000000000000000000000000000000000000006")!

		#expect(!(a > b))
	}

	@Test func smallerThan() {
		var a = BigInteger(123456)
		var b = BigInteger(111111)

		#expect(!(a < b))

		a = BigInteger(+123456)
		b = BigInteger(-511111)

		#expect(!(a < b))

		a = BigInteger(+123456)
		b = BigInteger(0)

		#expect(!(a < b))

		a = BigInteger(-523456)
		b = BigInteger(+111111)

		#expect(a < b)

		a = BigInteger(-123456)
		b = BigInteger(0)

		#expect(a < b)

		a = BigInteger(-123456)
		b = BigInteger(-111111)

		#expect(a < b)

		a = BigInteger(-111111)
		b = BigInteger(-123456)

		#expect(!(a < b))

		a = BigInteger(-111111)
		b = BigInteger(-111111)

		#expect(!(a < b))
	}

	@Test func equal() {
		var a = BigInteger(123456)
		var b = BigInteger(111111)

		#expect(!(a == b))

		a = BigInteger(+511111)
		b = BigInteger(-511111)

		#expect(!(a == b))

		a = BigInteger(+123456)
		b = BigInteger(0)

		#expect(!(a == b))

		a = BigInteger(111111)
		b = BigInteger(+111111)

		#expect(a == b)

		a = BigInteger(0)
		b = BigInteger(0)

		#expect(a == b)
	}

	@Test func greaterEqual() {
		var a = BigInteger(123456)
		var b = BigInteger(111111)

		#expect(a >= b)

		a = BigInteger(+511111)
		b = BigInteger(-511111)

		#expect(a >= b)

		a = BigInteger(+123456)
		b = BigInteger(0)

		#expect(a >= b)

		a = BigInteger(111111)
		b = BigInteger(+111111)

		#expect(a >= b)

		a = BigInteger(0)
		b = BigInteger(0)

		#expect(a >= b)

		a = BigInteger(-13)
		b = BigInteger(-11)

		#expect(!(a >= b))
	}

	@Test func smallerEqual() {
		var a = BigInteger(123456)
		var b = BigInteger(1111111)

		#expect(a <= b)

		a = BigInteger(-511111)
		b = BigInteger(511111)

		#expect(a <= b)

		a = BigInteger(0)
		b = BigInteger(1234567890)

		#expect(a <= b)

		a = BigInteger(111111)
		b = BigInteger(+111111)

		#expect(a <= b)

		a = BigInteger(0)
		b = BigInteger(0)

		#expect(a <= b)

		a = BigInteger(13)
		b = BigInteger(11)

		#expect(!(a <= b))
	}

	@Test func different() {
		var a = BigInteger(123456)
		var b = BigInteger(1111111)

		#expect(a != b)

		a = BigInteger(-511111)
		b = BigInteger(511111)

		#expect(a != b)

		a = BigInteger(0)
		b = BigInteger(1234567890)

		#expect(a != b)

		a = BigInteger(111111)
		b = BigInteger(+111111)

		#expect(!(a != b))

		a = BigInteger(0)
		b = BigInteger(0)

		#expect(!(a != b))

		a = BigInteger(13)
		b = BigInteger(11)

		#expect(a != b)
	}

	@Test func testMin() {
		var a = BigInteger(123456)
		var b = BigInteger(1111111)

		var expected = "123456"
		var actual = min(a, b).toString()
		#expect(expected == actual)

		a = BigInteger(123456)
		b = BigInteger(0)

		expected = "0"
		actual = min(a, b).toString()
		#expect(expected == actual)

		a = BigInteger(-123456)
		b = BigInteger(0)

		expected = "-123456"
		actual = min(a, b).toString()
		#expect(expected == actual)
	}

	@Test func testMax() {
		var a = BigInteger(123456)
		var b = BigInteger(1111111)

		var expected = "1111111"
		var actual = max(a, b).toString()
		#expect(expected == actual)

		a = BigInteger(-123456)
		b = BigInteger(0)

		expected = "0"
		actual = max(a, b).toString()
		#expect(expected == actual)

		a = BigInteger(-123456)
		b = BigInteger(-12)

		expected = "-12"
		actual = max(a, b).toString()
		#expect(expected == actual)
	}

	@Test func abs() {
		var a = BigInteger(123456)

		var expected = "123456"
		var actual = BigInteger.abs(a).toString()

		#expect(expected == actual)

		a = BigInteger(-123456)

		expected = "123456"
		actual = BigInteger.abs(a).toString()

		#expect(expected == actual)

		a = BigInteger(0)

		expected = "0"
		actual = BigInteger.abs(a).toString()

		#expect(expected == actual)
	}

	@Test func hashable() {
		var dict = [BigInteger: String]()

		let a = BigInteger(123456)
		let b = BigInteger(1111111)

		dict[a] = a.toString()
		dict[b] = b.toString()

		var expected = a.toString()
		var actual = dict[a]

		#expect(expected == actual)

		expected = b.toString()
		actual = dict[b]

		#expect(expected == actual)
	}

	@Test func other() {
		let _ = BigInteger(integerLiteral: 5)
	}

	@Test func digitCount() {
		var a = BigInteger(123456)

		var expected = 6
		var actual = a.digitCount()

		#expect(expected == actual)

		a = BigInteger(-123456789)

		expected = 9
		actual = a.digitCount()

		#expect(expected == actual)

		a = BigInteger(0)

		expected = 1
		actual = a.digitCount()

		#expect(expected == actual)

		a = BigInteger(100)

		expected = 3
		actual = a.digitCount()

		#expect(expected == actual)
	}

	@Test func exp100000000() {
		var a = BigInteger(123456)

		var expected = "12345600000000"
		var actual = a.exp100000000(1).toString()

		#expect(expected == actual)

		a = BigInteger(1234567890)

		expected = "12"
		actual = a.exp100000000(-1).toString()

		#expect(expected == actual)

		a = BigInteger(123456789)

		expected = "0"
		actual = a.exp100000000(-2).toString()

		#expect(expected == actual)

		a = BigInteger(1234)

		expected = "0"
		actual = a.exp100000000(-1).toString()

		#expect(expected == actual)

		a = BigInteger(123456)

		expected = "123456"
		actual = a.exp100000000(0).toString()

		#expect(expected == actual)

		a = BigInteger(123456)

		expected = "123456000000000000000000000000"
		actual = a.exp100000000(3).toString()

		#expect(expected == actual)

		a = BigInteger(-123456)

		expected = "-123456000000000000000000000000"
		actual = a.exp100000000(3).toString()

		#expect(expected == actual)
	}

	@Test func exp10() {
		var a = BigInteger(123456)

		var expected = "1234560"
		var actual = a.exp10(1).toString()

		#expect(expected == actual)

		a = BigInteger(123456)

		expected = "12345"
		actual = a.exp10(-1).toString()

		#expect(expected == actual)

		a = BigInteger(123456)

		expected = "1"
		actual = a.exp10(-5).toString()

		#expect(expected == actual)

		a = BigInteger(123456)

		expected = "0"
		actual = a.exp10(-6).toString()

		#expect(expected == actual)

		a = BigInteger(123456)

		expected = "0"
		actual = a.exp10(-7).toString()

		#expect(expected == actual)

		a = BigInteger(123456)

		expected = "123456"
		actual = a.exp10(0).toString()

		#expect(expected == actual)

		a = BigInteger(123456)

		expected = "1234560000000000"
		actual = a.exp10(10).toString()

		#expect(expected == actual)

		a = BigInteger(-123456)

		expected = "-1234560000000000"
		actual = a.exp10(10).toString()

		#expect(expected == actual)
	}

	@Test func leastSignificantDigit() {
		var a = BigInteger(123456)

		var expected = 6
		var actual = a.leastSignificantDigit()

		#expect(expected == actual)

		a = BigInteger(-123456789)

		expected = 9
		actual = a.leastSignificantDigit()

		#expect(expected == actual)

		a = BigInteger(0)

		expected = 0
		actual = a.leastSignificantDigit()

		#expect(expected == actual)

		a = BigInteger(123)

		expected = 3
		actual = a.leastSignificantDigit()

		#expect(expected == actual)

		a = BigInteger("128000000000000000000000000000000000000000000000345")!

		expected = 5
		actual = a.leastSignificantDigit()

		#expect(expected == actual)
	}
}
