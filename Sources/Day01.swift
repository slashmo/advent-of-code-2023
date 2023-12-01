import Algorithms

struct Day01: AdventDay {
    let data: String

    func part1() -> Any {
        /*
         Get mutable substring of input so we can pop the next character
         until we reached the end of the input.
         */
        var input = data[...]

        // The first number character of the currently inspected line
        var firstValue: Character?
        // The last number character of the currently inspected line
        var lastValue: Character?

        var sum = 0

        while let next = input.popFirst() {
            if next.isWholeNumber {
                if firstValue == nil {
                    firstValue = next
                    lastValue = next
                } else {
                    lastValue = next
                }
            }

            if next.isNewline || input.isEmpty {
                guard let first = firstValue, let last = lastValue else {
                    fatalError("Received malformed input.")
                }
                sum += Int(String([first, last]))!

                firstValue = nil
                lastValue = nil
            }
        }

        return sum
    }
}
