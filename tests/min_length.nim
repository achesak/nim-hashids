import unittest

import test_helper


proc testMinLength(minLength: int): bool =
    const hashids: Hashids = createHashids("", min_length)
    const numbers: seq[int] = @[1, 2, 3]

    const id: string = hashids.encode(numbers)
    const decodedNumbers: seq[int] = hashids.decode(id)

    return seqsEqual(numbers, decodedNumbers) and len(id) >= minLength


suite "min length":
    
    test "works with min length 0":
        check(testMinLength(0))

    test "works with min length 1":
        check(testMinLength(1))

    test "works with min length 10":
        check(testMinLength(10))

    test "works with min length 999":
        check(testMinLength(999))

    test "works with min length 1000":
        check(testMinLength(1000))

