# Nim module to implement Hashids (http://www.hashids.org/).

# Written by Adam Chesak.
# Released under the MIT open source license.


import future
import math
import strutils
import sequtils
import re
import unicode


const defaultAlphabet*: string = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
const defaultHashLength*: int = 0
const minAlphabetLength*: int = 16
const separatorRatio: float = 3.5
const guardRatio: float = 12.0


type
    Hashids* = ref object
        salt: string
        minHashLength: int
        alphabet: string
        separators: string
        guards: string

    HashidsException* = object of Exception


proc encode*(hashids: Hashids, numbers: seq[int]): string
proc decode*(hashids: Hashids, hash: string): seq[int]


proc checkNumberValidity(numbers: seq[int]): bool =
    if len(numbers) == 0:
        return false
    for number in numbers:
        if number < 0:
            return false
    return true


proc splitEveryChar(str: string): seq[string] =
    var splitStr: seq[string] = @[]
    for character in str:
        splitStr.add($character)
    return splitStr


proc reorderBySalt(str: string, salt: string): string =
    var changedStr: string = str
    let saltLength: int = len(salt)
    if saltLength != 0:
        var splitStr: seq[string] = splitEveryChar(changedStr)
        var index: int = 0
        var integerSum: int = 0
        for i in countdown(len(splitStr) - 1, 1):
            let integer: int = int(salt[index])
            integerSum += integer
            let j: int = (integer + index + integerSum) mod i
            swap(splitStr[i], splitStr[j])
            index = (index + 1) mod saltLength
        changedStr = splitStr.join()
    return changedStr


proc getIndexFromRatio(dividend: float, divisor: float): int =
    return int(math.ceil(dividend / divisor))


proc hash(number: int, alphabet: string): string =
    var hashValue: string = ""
    let alphabetLength: int = len(alphabet)
    var num: int = number
    while true:
        hashValue = alphabet[num mod alphabetLength] & hashValue
        num = int(num / alphabetLength)
        if num == 0:
            return hashValue


proc unhash(hashValue: string, alphabet: string): int =
    var number: int = 0
    let alphabetLength: int = len(alphabet)
    for character in hashValue:
        let position: int = alphabet.find(character)
        number *= alphabetLength
        number += position
    return number


proc ensureLength(hashids: Hashids, encoded: string, alphabet: string, numbersHash: int): string =
    let guardLength: int = len(hashids.guards)
    var guardIndex: int = int((numbersHash + int(encoded[0])) mod guardLength)
    var extEncoded: string = hashids.guards[guardIndex] & encoded
    var newAlphabet: string = alphabet

    if len(extEncoded) < hashids.minHashLength:
        guardIndex = int((numbersHash + int(extEncoded[2])) mod guardLength)
        extEncoded &= hashids.guards[guardIndex]

    let splitIndex: int = int(len(alphabet) / 2)
    while len(extEncoded) < hashids.minHashLength:
        newAlphabet = reorderBySalt(newAlphabet, newAlphabet)
        extEncoded = newAlphabet[splitIndex..high(newAlphabet)] & extEncoded & newAlphabet[0..<splitIndex]
        let excess: int = len(extEncoded) - hashids.minHashLength
        if excess > 0:
            let fromIndex: int = int(excess / 2)
            extEncoded = extEncoded[fromIndex..<(fromIndex + hashids.minHashLength)]

    return extEncoded


proc splitHash(hash: string, guards: string): seq[string] =
    var parts: seq[string] = @[]
    var part: string = ""
    for character in hash:
        if $character in guards:
            parts.add(part)
            part = ""
        else:
            part &= $character
    parts.add(part)
    return parts


proc encodeHelper(hashids: Hashids, numbers: seq[int]): string =
    var alphabet: string = hashids.alphabet
    let alphabetLength = len(alphabet)
    let separatorLength = len(hashids.separators)

    var numbersMod: seq[int] = newSeq[int](len(numbers))
    for index in 0..high(numbers):
        numbersMod[index] = numbers[index] mod (index + 100)
    let numbersHash: int = math.sum(numbersMod)

    var encoded: string = $alphabet[numbersHash mod alphabetLength]
    let lottery: string = $alphabet[numbersHash mod alphabetLength]

    for index in 0..high(numbers):
        var number: int = numbers[index]
        let alphabetSalt: string = (lottery & hashids.salt & alphabet)[0..<alphabetLength]
        alphabet = reorderBySalt(alphabet, alphabetSalt)
        let last: string = hash(number, alphabet)
        encoded &= last
        number = number mod (int(last[0]) + index)
        encoded &= hashids.separators[number mod separatorLength]

    encoded = encoded[0..<high(encoded)]
    if len(encoded) >= hashids.minHashLength:
        return encoded
    else:
        return ensureLength(hashids, encoded, alphabet, numbersHash)


proc decodeHelper(hashids: Hashids, hash: string): seq[int] =
    let parts: seq[string] = splitHash(hash, hashids.guards)
    var decodeHash: string
    if len(parts) >= 2 and len(parts) <= 3:
        decodeHash = parts[1]
    else:
        decodeHash = parts[0]

    if decodeHash == "":
        return @[]

    let lottery: string = $decodeHash[0]
    decodeHash = decodeHash[1..high(decodeHash)]

    let hashParts: seq[string] = splitHash(decodeHash, hashids.separators)
    var alphabet: string = hashids.alphabet
    var decoded: seq[int] = @[]
    for part in hashParts:
        let alphabetSalt: string = (lottery & hashids.salt & alphabet)[0..high(alphabet)]
        alphabet = reorderBySalt(alphabet, alphabetSalt)
        decoded.add(unhash(part, alphabet))

    if hashids.encode(decoded) != hash:
        return @[]

    return decoded


proc createHashids*(salt: string, minHashLength: int, hashidsAlphabet: string): Hashids =
    ## Creates and returns a new ``Hashids`` object with the specified salt, minimum hash length,
    ## and alphabet.

    let hashids: Hashids = Hashids(salt: salt)
    hashids.minHashLength = max(minHashLength, 0)

    var separators: string = lc[x | (x <- "cfhistuCFHISTU", x in hashidsAlphabet), char].join()
    var alphabet: string = ""
    for index in 0..high(hashidsAlphabet):
        let letter: char = hashidsAlphabet[index]
        if not (letter in separators):
           alphabet &= letter

    let separatorLength: int = len(separators)
    var alphabetLength: int = len(alphabet)
    if separatorLength + alphabetLength < minAlphabetLength:
        raise newException(HashidsException, "alphabet must contain at least 16 unique characters")
    if alphabet.contains(" "):
        raise newException(HashidsException, "alphabet cannot contain spaces")

    separators = reorderBySalt(separators, salt)
    let minSeparators: int = getIndexFromRatio(float(alphabetLength), separatorRatio)
    let missingSeparatorCount: int = minSeparators - separatorLength
    if missingSeparatorCount > 0:
        separators &= alphabet[0..<missingSeparatorCount]
        alphabet = alphabet[missingSeparatorCount..high(alphabet)]
        alphabetLength = len(alphabet)

    alphabet = reorderBySalt(alphabet, salt)
    let numGuards: int = getIndexFromRatio(float(alphabetLength), guardRatio)
    var guards: string
    if alphabetLength < 3:
        guards = separators[0..<numGuards]
        separators = separators[numGuards..high(separators)]
    else:
        guards = alphabet[0..<numGuards]
        alphabet = alphabet[numGuards..high(alphabet)]

    hashids.alphabet = alphabet
    hashids.guards = guards
    hashids.separators = separators

    return hashids


proc createHashids*(salt: string, minHashLength: int): Hashids =
    ## Creates and returns a new ``Hashids`` object with the specified salt, minimum hash length,
    ## and the default alphabet.

    return createHashids(salt, minHashLength, defaultAlphabet)


proc createHashids*(salt: string): Hashids =
    ## Creates and returns a new ``Hashids`` object with the specified salt and the default hash
    ## length and alphabet.

    return createHashids(salt, 0, defaultAlphabet)


proc createHashids*(): Hashids =
    ## Creates and returns a new ``Hashids`` object with an empty string salt and the default hash
    ## length and alphabet.

    return createHashids("", 0, defaultAlphabet)


proc encode*(hashids: Hashids, numbers: seq[int]): string =
    ## Encodes the specified numbers and returns the encoded string.

    if not checkNumberValidity(numbers):
        return ""
    return hashids.encodeHelper(numbers)


proc decode*(hashids: Hashids, hash: string): seq[int] =
    ## Decodes the ``hash`` parameter and returns a
     ## sequence containing the original numbers.

    if len(hash) == 0:
        return @[]
    let validChars: string = hashids.alphabet & hashids.guards & hashids.separators
    for c in validChars:
        if validChars.find(c) == -1:
            return @[]
    return hashids.decodeHelper(hash)


proc encodeHex*(hashids: Hashids, hexString: string): string =
    ## Encodes the specified hex string and returns the encoded string.
    ##
    if not hexString.match(re"^[0-9a-fA-F]+$"):
        return ""

    var hexComponents: seq[string] = @[]
    for index in countup(0, high(hexString), 12):
        hexComponents.add("1" & hexString[index..<min(index + 12, len(hexString))])
    var numbers: seq[int] = @[]
    for component in hexComponents:
        numbers.add(parseHexInt(component))

    return hashids.encode(numbers)


proc decodeHex*(hashids: Hashids, hash: string): string =
    ## Decodes the ``hash`` parameter and returns the original hex string.

    let numbers: seq[int] = hashids.decode(hash)
    var hex: string = ""

    for number in numbers:
        hex &= toHex(number, 12)

    return unicode.toLower(hex)