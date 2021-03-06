import unittest

import test_helper

import ../hashids


proc testAlphabet(alphabet: string): bool =
    let hashids: Hashids = createHashids("", 0, alphabet)
    let numbers: seq[int] = @[1, 2, 3]

    let id: string = hashids.encode(numbers)
    let decodedNumbers: seq[int] = hashids.decode(id)

    return seqsEqual(numbers, decodedNumbers)    


suite "custom alphabet":

    test "works with the worst alphabet":
        check(testAlphabet("cCsSfFhHuUiItT01"))

    test "works with half alphabet being separators":
        check(testAlphabet("abdegjklCFHISTUc"))

    test "works with exactly two separators":
        check(testAlphabet("abdegjklmnopqrSF"))

    test "works with no separators":
        check(testAlphabet("abdegjklmnopqrvwxyzABDEGJKLMNOPQRVWXYZ1234567890"))

    test "works with super long alphabet":
        check(testAlphabet("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890`~!@#$%^&*()-_=+\\|'\";:/?.>,<{[}]"))

    test "works with weird alphabet":
        check(testAlphabet("`~!@#$%^&*()-_=+\\|'\";:/?.>,<{[}]"))

