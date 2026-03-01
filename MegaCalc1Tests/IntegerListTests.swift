//
//  IntegerListTests.swift
//  IntegerListTests
//
//  Created by Francois Robert on 2016-11-22.
//  Copyright © 2016 Pixtolab. All rights reserved.
//

import Testing
@testable import MegaCalc1

@Suite struct IntegerListTests {

	@Test func base01() {
		let integerList = IntegerList()

		#expect(integerList.count == 0)
		#expect(integerList.description == "0")
	}

	@Test func base02() {
		let integerList = IntegerList()
		_ = integerList.add(123); _ = integerList.add(345)

		#expect(integerList.count == 2)
		#expect(integerList.description == "123;345")

		_ = integerList.add(1); _ = integerList.add(2)

		#expect(integerList.count == 4)
		#expect(integerList.description == "123;345;1;2")

		integerList.empty()
		#expect(integerList.count == 0)
		#expect(integerList.description == "0")
	}

	@Test func count() {
		let integerList = IntegerList()

		#expect(integerList.count == 0)

		_ = integerList.add(1); _ = integerList.add(2); _ = integerList.add(3); _ = integerList.add(4)

		#expect(integerList.count == 4)
	}

	@Test func setAt() {
		let integerList = IntegerList()
		_ = integerList.add(1); _ = integerList.add(2); _ = integerList.add(3); _ = integerList.add(4)

		integerList.setAt(0, value: 322)
		#expect(integerList.description == "322;2;3;4")

		integerList.setAt(3, value: 11)
		#expect(integerList.description == "322;2;3;11")

		integerList[1] = 123
		#expect(integerList.description == "322;123;3;11")

		integerList[0] = 42
		#expect(integerList.description == "42;123;3;11")
	}

	@Test func removeAt() {
		let integerList = IntegerList()
		_ = integerList.add(1); _ = integerList.add(2); _ = integerList.add(3); _ = integerList.add(4); _ = integerList.add(5); _ = integerList.add(6)

		integerList.removeAt(0)
		#expect(integerList.description == "2;3;4;5;6")

		integerList.removeAt(3)
		#expect(integerList.description == "2;3;4;6")

		integerList.removeAt(3)
		#expect(integerList.description == "2;3;4")
	}

	@Test func getAt() {
		let integerList = IntegerList()
		_ = integerList.add(1); _ = integerList.add(2); _ = integerList.add(3); _ = integerList.add(4); _ = integerList.add(5); _ = integerList.add(6)

		#expect(integerList.getAt(2) == 3)
		#expect(integerList.getAt(0) == 1)
		#expect(integerList.getAt(5) == 6)

		#expect(integerList[2] == 3)
		#expect(integerList[0] == 1)
		#expect(integerList[5] == 6)
	}

	@Test func add() {
		let integerList = IntegerList()
		_ = integerList.add(1); _ = integerList.add(2); _ = integerList.add(3); _ = integerList.add(4); _ = integerList.add(5); _ = integerList.add(6)

		let actual = integerList.add(322)
		#expect(actual == 6)

		#expect(integerList.description == "1;2;3;4;5;6;322")
	}

	@Test func insertRange() {
		let integerList = IntegerList()
		_ = integerList.add(1); _ = integerList.add(2); _ = integerList.add(3); _ = integerList.add(4); _ = integerList.add(5); _ = integerList.add(6)

		let subList = IntegerList()
		_ = subList.add(11); _ = subList.add(12); _ = subList.add(13)

		integerList.insertRange(atIndex: 0, arrayToInsert: subList)
		#expect(integerList.description == "11;12;13;1;2;3;4;5;6")

		integerList.insertRange(atIndex: 8, arrayToInsert: subList)
		#expect(integerList.description == "11;12;13;1;2;3;4;5;11;12;13;6")
	}

	@Test func removeRange() {
		let integerList = IntegerList()
		_ = integerList.add(1); _ = integerList.add(2); _ = integerList.add(3); _ = integerList.add(4); _ = integerList.add(5); _ = integerList.add(6)

		integerList.removeRange(atIndex: 3, count: 2)
		#expect(integerList.description == "1;2;3;6")

		integerList.removeRange(atIndex: 0, count: 2)
		#expect(integerList.description == "3;6")
	}
}
