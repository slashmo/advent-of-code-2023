import XCTest
@testable import AdventOfCode

final class Day01Tests: XCTestCase {
    let testData = """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """

    func testPart1() throws {
        let challenge = Day01(data: testData)
        XCTAssertEqual("\(challenge.part1())", "142")
    }
}
