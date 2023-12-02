import XCTest
@testable import AdventOfCode

final class Day01Tests: XCTestCase {
    func testPart1() throws {
        let testData = """
        1abc2
        pqr3stu8vwx
        a1b2c3d4e5f
        treb7uchet
        """

        let challenge = Day01(data: testData)

        XCTAssertEqual(try XCTUnwrap(challenge.part1() as? Int), 142)
    }

    func testPart2() throws {
        let testData = """
        two1nine
        eightwothree
        abcone2threexyz
        xtwone3four
        4nineeightseven2
        zoneight234
        7pqrstsixteen
        """

        let challenge = Day01(data: testData)

        XCTAssertEqual(try XCTUnwrap(challenge.part2() as? Int), 281)
    }
}
