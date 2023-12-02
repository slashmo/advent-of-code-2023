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
}
