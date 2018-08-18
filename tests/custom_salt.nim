import unittest

import test_helper


proc testSalt(salt: string): bool =
    const hashids: Hashids = createHashids(salt)
    const numbers: seq[int] = @[1, 2, 3]

    const id: string = hashids.encode(numbers)
    const decodedNumbers: seq[int] = hashids.decode(id)

    return seqsEqual(numbers, decodedNumbers)


suite "custom salt":
    
    test "works with ''":
        check(testSalt(""))

    test "works with '   '":
        check(testSalt("   "))

    test "works with 'this is my salt'":
        check(testSalt("this is my salt"))

    test "works with a really long salt":
        check(testSalt("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890`~!@#$%^&*()-_=+\\|'\";:/?.>,<{[}]"))

    test "works with a weird salt":
        check(testSalt("`~!@#$%^&*()-_=+\\|'\";:/?.>,<{[}]"))

