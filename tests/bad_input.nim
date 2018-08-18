import unittest


suite "bad input":

    setup:
        const hashids: Hashids = createHashids()

    test "raises error when small alphabet":
        expect HashidsAlphabetException:
            discard createHashids("", 0, "1234567890")

    test "raises error when alphabet has spaces":
        expect HashidsAlphabetException:
            discard createHashids("", 0, "a cdefghijklmnopqrstuvwxyz")

    test "returns empty string when encoding empty seq":
        const id: string = hashids.encode(@[])
        check(id == "")

    test "returns empty string when encoding negative number":
        const id: string = hashids.encode(@[-1])
        check(id == "")

    test "returns empty string when encoding nil":
        const id: string = hashids.encode(nil)
        check(id == "")

    test "returns empty string when encoding nil in seq":
        const id: string = hashids.encode(@[nil])
        check(id == "")

    test "returns empty seq when decoding empty string":
        const numbers: seq[int] = hashids.decode("")
        check(len(numbers) == 0)

    test "returns empty seq when decoding invalid id":
        const numbers: seq[int] = hashids.decode("f")
        check(len(numbers) == 0)

    test "returns empty string when encoding non-hex input":
        const id: string = hashids.encodeHex("z")
        check(id == "")

    test "returns empty seq when hex-decoding invalid id":
        const numbers: seq[int] = hashids.decodeHex("f")
        check(len(numbers) == 0)

