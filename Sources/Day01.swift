import Algorithms

struct Day01: AdventDay {
    let data: String

    func part1() -> Any {
        let input = data[...].utf8
        return input.withContiguousStorageIfAvailable({ part1(input: $0) }) ?? part1(input: input)
    }

    private func part1<Input>(input: Input) -> Int where Input: BidirectionalCollection<UTF8.CodeUnit> {
        var sum = 0

        var startIndex = input.startIndex
        let singleDigitCodeUnitRange = UTF8.CodeUnit(49) ... UTF8.CodeUnit(57)

        func value(in line: Input.SubSequence) -> Int {
            let firstValue = line.first(where: { singleDigitCodeUnitRange ~= $0 })!
            let lastValue = line.last(where: { singleDigitCodeUnitRange ~= $0 })!
            return Int(String(decoding: [firstValue, lastValue], as: UTF8.self))!
        }

        while let newLineIndex = input[startIndex...].firstIndex(of: 10) {
            let line = input[startIndex ..< newLineIndex]
            sum += value(in: line)
            startIndex = input.index(after: line.endIndex)
        }

        // look at final line if needed
        if startIndex < input.endIndex {
            let line = input[startIndex...]
            sum += value(in: line)
        }

        return sum
    }

    func part2() -> Any {
        let input = data[...].utf8
        return input.withContiguousStorageIfAvailable({ part2(input: $0) }) ?? part2(input: input)
    }

    private func part2<Input>(input: Input) -> Int where Input: BidirectionalCollection<UTF8.CodeUnit> {
        let singleDigitCodeUnitRange = UTF8.CodeUnit(49) ... UTF8.CodeUnit(57)
        let spelledOutNumbersLookup: [UTF8.CodeUnit: [[UTF8.CodeUnit]: UTF8.CodeUnit]] = [
            // o -> ne=1
            111: [[110, 101]: 49],
            // t -> wo=2 / hree=3
            116: [[119, 111]: 50, [104, 114, 101, 101]: 51],
            // f -> our=4 / ive=5
            102: [[111, 117, 114]: 52, [105, 118, 101]: 53],
            // s -> ix=6 / even=7
            115: [[105, 120]: 54, [101, 118, 101, 110]: 55],
            // e -> ight=8
            101: [[105, 103, 104, 116]: 56],
            // n -> ine=9
            110: [[105, 110, 101]: 57],
        ]
        let reversedSpelledOutNumbersLookup: [UTF8.CodeUnit: [[UTF8.CodeUnit]: UTF8.CodeUnit]] = [
            // e -> no=1 / erht=3 / vif=5 / nin
            101: [[110, 111]: 49, [101, 114, 104, 116]: 51, [118, 105, 102]: 53, [110, 105, 110]: 57],
            // o -> wt=2
            111: [[119, 116]: 50],
            // r -> uof=4
            114: [[117, 111, 102]: 52],
            // x -> is=6
            120: [[105, 115]: 54],
            // n -> eves=7
            110: [[101, 118, 101, 115]: 55],
            // t -> hgie=8
            116: [[104, 103, 105, 101]: 56]
        ]

        var sum = 0
        var startIndex = input.startIndex

        while let newLineIndex = input[startIndex...].firstIndex(of: 10) {
            let line = input[startIndex ..< newLineIndex]
            sum += value(in: line)
            startIndex = input.index(after: line.endIndex)
        }

        // look at final line if needed
        if startIndex < input.endIndex {
            let line = input[startIndex...]
            sum += value(in: line)
        }

        return sum

        func match(
            codeUnit: UTF8.CodeUnit,
            lookup: [UTF8.CodeUnit: [[UTF8.CodeUnit]: UTF8.CodeUnit]],
            candidateGroups: inout [Int: [[UTF8.CodeUnit]: UTF8.CodeUnit]]
        ) -> UTF8.CodeUnit? {
            if singleDigitCodeUnitRange ~= codeUnit {
                return codeUnit
            } else {
                var groups = candidateGroups
                for (candidateKeyIndex, var candidates) in candidateGroups.sorted(by: { $0.key > $1.key }) {
                    // advance group if at least one candidate still matches
                    var advanceGroupIndex = false

                    for (key, value) in candidates {
                        if candidateKeyIndex < key.endIndex {
                            if key[candidateKeyIndex] == codeUnit {
                                if key.endIndex == candidateKeyIndex + 1 {
                                    // return value if candidate key fully matches
                                    return value
                                }
                                advanceGroupIndex = true
                            }
                        } else {
                            candidates.removeValue(forKey: key)
                        }
                    }

                    if advanceGroupIndex {
                        groups.removeValue(forKey: candidateKeyIndex)
                        groups[candidateKeyIndex + 1] = candidates
                    }
                }

                groups[0] = lookup[codeUnit]
                candidateGroups = groups
            }

            return nil
        }

        func firstValue(in line: Input.SubSequence) -> UTF8.CodeUnit {
            var lineStartIndex = line.startIndex

            // index -> candidates
            var candidateGroups = [Int: [[UTF8.CodeUnit]: UTF8.CodeUnit]]()

            while lineStartIndex < line.endIndex {
                let codeUnit = line[lineStartIndex]

                if let value = match(
                    codeUnit: codeUnit,
                    lookup: spelledOutNumbersLookup,
                    candidateGroups: &candidateGroups
                ) {
                    return value
                }

                line.formIndex(after: &lineStartIndex)
            }

            fatalError(#"Received invalid line of input: "\#(String(decoding: line, as: UTF8.self))""#)
        }

        func lastValue(in line: Input.SubSequence) -> UTF8.CodeUnit {
            var lineEndIndex = line.index(before: line.endIndex)

            // index -> candidates
            var candidateGroups = [Int: [[UTF8.CodeUnit]: UTF8.CodeUnit]]()

            while lineEndIndex >= line.startIndex {
                let codeUnit = line[lineEndIndex]

                if let value = match(
                    codeUnit: codeUnit,
                    lookup: reversedSpelledOutNumbersLookup,
                    candidateGroups: &candidateGroups
                ) {
                    return value
                }

                line.formIndex(before: &lineEndIndex)
            }

            fatalError(#"Received invalid line of input: "\#(String(decoding: line, as: UTF8.self))""#)
        }

        func value(in line: Input.SubSequence) -> Int {
            let firstValue = firstValue(in: line)
            let lastValue = lastValue(in: line)

            return Int(String(decoding: [firstValue, lastValue], as: UTF8.self))!
        }
    }
}
