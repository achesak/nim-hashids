import tables
import unittest

import test_helper

import ../hashids


const map = {
    "nej1m3d5a6yn875e7gr9kbwpqol02q": @[0],
    "dw1nqdp92yrajvl9v6k3gl5mb0o8ea": @[1],
    "onqr0bk58p642wldq14djmw21ygl39": @[928728],
    "18apy3wlqkjvd5h1id7mn5ore2d06b": @[1, 2, 3],
    "o60edky1ng3vl9hbfavwr5pa2q8mb9": @[1, 0, 0],
    "o60edky1ng3vlqfbfp4wr5pa2q8mb9": @[0, 0, 1],
    "qek2a08gpl575efrfd7yomj9dwbr63": @[0, 0, 0],
    "m3d5a6yn875rae8y81a94gr9kbwpqo": @[1000000000000.int],
    "1q3y98ln48w96kpo0wgk314w5mak2d": @[9007199254740991.int],
    "op7qrcdc3cgc2c0cbcrcoc5clce4d6": @[5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5],
    "5430bd2jo0lxyfkfjfyojej5adqdy4": @[10000000000.int, 0, 0, 0, 999999999999999.int],
    "aa5kow86ano1pt3e1aqm239awkt9pk380w9l3q6": @[9007199254740991.int, 9007199254740991.int, 9007199254740991.int],
    "mmmykr5nuaabgwnohmml6dakt00jmo3ainnpy2mk": @[1000000001, 1000000002, 1000000003, 1000000004, 1000000005],
    "w1hwinuwt1cbs6xwzafmhdinuotpcosrxaz0fahl": @[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
}.toTable


suite "encode/decode using custom params":
    
    setup:
        let minLength: int = 30
        let hashids: Hashids = createHashids("this is my salt", minLength, "xzal86grmb4jhysfoqp3we7291kuct5iv0nd")

    test "encode using custom params":
        for id, numbers in pairs(map):
            let actualId: string = hashids.encode(numbers)
            check(id == actualId)

    test "encode and decode back correctly using default params":
        for id, numbers in pairs(map):
            let actualId: string = hashids.encode(numbers)
            let actualNumbers: seq[int] = hashids.decode(actualId)

            check(seqsEqual(numbers, actualNumbers))
    
    test "id length should be at least 30":
        for id, numbers in pairs(map):
            check(len(hashids.encode(numbers)) >= minLength)

