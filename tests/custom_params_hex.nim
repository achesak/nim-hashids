import tables
import unicode
import unittest

import test_helper


const map = {
    "0dbq3jwa8p4b3gk6gb8bv21goerm96": "deadbeef",
    "190obdnk4j02pajjdande7aqj628mr": "abcdef123456",
    "a1nvl5d9m3yo8pj1fqag8p9pqw4dyl": "ABCDDD6666DDEEEEEEEEE",
    "1nvlml93k3066oas3l9lr1wn1k67dy": "507f1f77bcf86cd799439011",
    "mgyband33ye3c6jj16yq1jayh6krqjbo": "f00000fddddddeeeee4444444ababab",
    "9mnwgllqg1q2tdo63yya35a9ukgl6bbn6qn8": "abcdef123456abcdef123456abcdef123456",
    "edjrkn9m6o69s0ewnq5lqanqsmk6loayorlohwd963r53e63xmml29": "f000000000000000000000000000000000000000000000000000f",
    "grekpy53r2pjxwyjkl9aw0k3t5la1b8d5r1ex9bgeqmy93eata0eq0": "fffffffffffffffffffffffffffffffffffffffffffffffffffff"
}.toTable


suite "encode/decode hex using custom params":
    
    setup:
        const minLength: int = 30
        const hashids: Hashids = createHashids("this is my salt", minLength, "xzal86grmb4jhysfoqp3we7291kuct5iv0nd")

    test "encode using custom params":
        for id, hex in pairs(map):
            const actualId: string = hashids.encodeHex(hex)
            check(id == actualId)

    test "encode and decode back correctly using custom params":
        for id, hex in pairs(map):
            const actualId: string = hashids.encodeHex(hex)
            const actualHex: string  = hashids.decodeHex(actualId)

            check(hex.toLower() == actualHex)
    
    test "id length should be at least 30":
        for id, hex in pairs(map):
            check(len(hashids.encodeHex(hex)) >= 30)

