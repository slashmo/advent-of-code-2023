struct Day02: AdventDay {
    let data: String

    init(data: String) {
        self.data = data
    }

    func part1() -> Any {
        let input = data[...].utf8
        return input.withContiguousStorageIfAvailable { part1(input: $0) } ?? part1(input: input)
    }

    private func part1<Input>(input: Input) -> Int where Input: Collection<UTF8.CodeUnit> {
        var startIndex = input.startIndex
        var sum = 0

        while let newLineIndex = input[startIndex...].firstIndex(of: 10) {
            let line = input[startIndex ..< newLineIndex]
            sum += summand(in: line)
            startIndex = input.index(after: line.endIndex)
        }

        // look at final line if needed
        if startIndex < input.endIndex {
            let line = input[startIndex...]
            sum += summand(in: line)
        }

        return sum
    }

    func part2() -> Any {
        let input = data[...].utf8
        return input.withContiguousStorageIfAvailable { part2(input: $0) } ?? part2(input: input)
    }

    private func part2<Input>(input: Input) -> Int where Input: Collection<UTF8.CodeUnit> {
        var startIndex = input.startIndex
        var sum = 0

        while let newLineIndex = input[startIndex...].firstIndex(of: 10) {
            let line = input[startIndex ..< newLineIndex]
            sum += power(of: line)
            startIndex = input.index(after: line.endIndex)
        }

        // look at final line if needed
        if startIndex < input.endIndex {
            let line = input[startIndex...]
            sum += power(of: line)
        }

        return sum
    }

    private let colorLookup: [Color: [UTF8.CodeUnit]] = [
        .red: [101, 100],
        .green: [114, 101, 101, 110],
        .blue: [108, 117, 101]
    ]

    private let singleDigitCodeUnitRange = UTF8.CodeUnit(48) ... UTF8.CodeUnit(57)

    private func summand<Line>(in line: Line) -> Int where Line: Collection<UTF8.CodeUnit> {
        var index = line.startIndex
        let gameID = parseGameID(line: line, index: &index)

        while let (color, count) = parseNextCubeCount(line: line, index: &index) {
            if count > color.availableCount {
                return 0
            }
        }

        return gameID
    }

    private func power<Line>(of line: Line) -> Int where Line: Collection<UTF8.CodeUnit> {
        var index = line.startIndex
        parseGameID(line: line, index: &index)

        var redMultiplier = 0
        var greenMultiplier = 0
        var blueMultiplier = 0

        while let (color, count) = parseNextCubeCount(line: line, index: &index) {
            switch color {
            case .red:
                redMultiplier = max(redMultiplier, count)
            case .green:
                greenMultiplier = max(greenMultiplier, count)
            case .blue:
                blueMultiplier = max(blueMultiplier, count)
            }
        }

        return redMultiplier * greenMultiplier * blueMultiplier
    }

    @discardableResult
    private func parseGameID<Line>(line: Line, index: inout Line.Index) -> Int where Line: Collection<UTF8.CodeUnit> {
        let colon: UTF8.CodeUnit = 58
        var idStartIndex: Line.Index?
        var idEndIndex: Line.Index?

        while index < line.endIndex, line[index] != colon {
            let codeUnit = line[index]
            if singleDigitCodeUnitRange ~= codeUnit {
                if idStartIndex == nil {
                    idStartIndex = index
                    idEndIndex = index
                } else {
                    idEndIndex = index
                }
            }
            line.formIndex(after: &index)
        }

        // skip ": "
        line.formIndex(&index, offsetBy: 2)

        guard let idStartIndex, let idEndIndex else {
            fatalError(#"Line does not contain game ID: \#(String(decoding: line, as: UTF8.self))"#)
        }

        let gameID = Int(String(decoding: line[idStartIndex ... idEndIndex], as: UTF8.self))!
        return gameID
    }

    private func parseNextCubeCount<Line>(
        line: Line,
        index: inout Line.Index
    ) -> (color: Color, count: Int)? where Line: Collection<UTF8.CodeUnit> {
        var cubeCountStartIndex: Line.Index?
        var cubeCountEndIndex: Line.Index?

        while index < line.endIndex {
            let codeUnit = line[index]

            if singleDigitCodeUnitRange ~= codeUnit {
                if cubeCountStartIndex == nil {
                    cubeCountStartIndex = index
                    cubeCountEndIndex = index
                } else {
                    cubeCountEndIndex = index
                }
            } else if let color = Color(rawValue: codeUnit) {
                // consume color
                let colorNameRemainder = colorLookup[color]!
                var colorNameRemainderIndex = colorNameRemainder.startIndex
                line.formIndex(after: &index)

                while colorNameRemainderIndex < colorNameRemainder.endIndex {
                    if line[index] == colorNameRemainder[colorNameRemainderIndex] {
                        if colorNameRemainderIndex + 1 < colorNameRemainder.endIndex {
                            line.formIndex(after: &index)
                        }
                    } else {
                        fatalError(#"Unknown color in line "\#(line)"."#)
                    }

                    colorNameRemainder.formIndex(after: &colorNameRemainderIndex)
                }

                guard let countStartIndex = cubeCountStartIndex, let countEndIndex = cubeCountEndIndex else {
                    fatalError(#"Unknown count in line "\#(line)"."#)
                }
                cubeCountStartIndex = nil
                cubeCountEndIndex = nil
                let count = Int(String(decoding: line[countStartIndex...countEndIndex], as: UTF8.self))!
                return (color, count)
            }

            line.formIndex(after: &index)
        }

        return nil
    }

    enum Color: UTF8.CodeUnit {
        case red = 114
        case green = 103
        case blue = 98

        var availableCount: Int {
            switch self {
            case .red: 12
            case .green: 13
            case .blue: 14
            }
        }
    }
}
