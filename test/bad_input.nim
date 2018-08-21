import unittest

import ../hashids


suite "bad input":

    test "raises error when small alphabet":
        expect HashidsException:
            discard createHashids("", 0, "1234567890")

    test "raises error when alphabet has spaces":
        expect HashidsException:
            discard createHashids("", 0, "a cdefghijklmnopqrstuvwxyz")

    test "returns empty string when encoding empty seq":
        const id: string = createHashids().encode(@[])
        check(id == "")

    test "returns empty string when encoding negative number":
        const id: string = createHashids().encode(@[-1])
        check(id == "")

    test "returns empty string when encoding nil":
        const id: string = createHashids().encode(nil)
        check(id == "")

    test "returns empty seq when decoding empty string":
        const numbers: seq[int] = createHashids().decode("")
        check(len(numbers) == 0)

    test "returns empty seq when decoding invalid id":
        const numbers: seq[int] = createHashids().decode("f")
        check(len(numbers) == 0)

    test "returns empty string when encoding non-hex input":
        const id: string = createHashids().encodeHex("z")
        check(id == "")

    test "returns empty seq when hex-decoding invalid id":
        const hex: string = createHashids().decodeHex("f")
        check(hex == "")

