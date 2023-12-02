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
}
