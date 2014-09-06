# Nimrod module to implement hashids (http://www.hashids.org/).

# Written by Adam Chesak.
# Released under the MIT open source license.


import strutils
import sequtils
import re
import math


const defaultAlphabet* : string = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
const minAlphabetLength* : int = 16
const sepDiv : float = 3.5
const guardDiv : float = 12.0


type
    HashidRef* = ref Hashid
    Hashid* = object
        salt : string
        minHashLength : int
        alphabet : string
        seps : string
        guards : string


proc encode(hashid : HashidRef, numbers : seq[int]): string
proc decode(hashid : HashidRef, hash : string, alphabet2 : string): seq[int]
proc consistentShuffle(alphabet2 : string, salt : string): string
proc hash(input2 : int, alphabet : string): string
proc unhash(input : string, alphabet : string): int


proc createHashid*(salt : string, minHashLength : int, alphabet : string): HashidRef = 
    ## Creates and returns a new ``HashidRef`` object with the specified salt, minimum hash length,
    ## and alphabet.
    
    var h : HashidRef = HashidRef(salt: salt, seps : "cfhistuCFHISTU")
    if minHashLength < 0:
        h.minHashLength = 0
    else:
        h.minHashLength = minHashLength
    
    var uniqueAlphabet : string = ""
    for i in 0..high(alphabet):
        if not uniqueAlphabet.contains(alphabet[i]):
            uniqueAlphabet &= $alphabet[i]
    h.alphabet = uniqueAlphabet
    
    doAssert(len(h.alphabet) >= minAlphabetLength, "alphabet must contain at least " & intToStr(minAlphabetLength) & " unique characters")
    doAssert(not h.alphabet.contains(" "), "alphabet cannot contain spaces")
    
    for i in 0..high(h.seps):
        var j : int = h.alphabet.find(h.seps[i])
        if j == -1:
            h.seps = h.seps[0..i-1] & " " & h.seps[i..high(h.seps)]                          ## POSSIBLE BUGFIX: MIGHT NEED TO BE i OR i+1
        else:
            h.alphabet = h.alphabet[0..j-1] & " " & h.alphabet[j..high(h.alphabet)]          ## SAME HERE
    
    var re1 : TRegex = re("\\s+")
    h.alphabet = h.alphabet.replace(re1, "")                                                 ## POSSIBLE BUGFIX: DOES THIS REPLACE ALL?
    h.seps = h.seps.replace(re1, "")
    
    if h.seps == "" or ((len(h.alphabet) / len(h.seps)) > sepDiv):
        var sepsLen : int = int(math.ceil(float(len(h.alphabet)) / sepDiv))
        
        if sepsLen == 1:
            sepsLen += 1
        
        if sepsLen > len(h.seps):
            var diff : int = sepsLen - len(h.seps)
            h.seps &= h.alphabet[0..diff-1]
            h.alphabet = h.alphabet[0..diff-1]
        else:
            h.seps = h.seps[0..sepsLen-1]
    
    h.alphabet = consistentShuffle(h.alphabet, h.salt)
    var guardCount : int = int(math.ceil(float(len(h.alphabet)) / guardDiv))
    
    if len(h.alphabet) < 3:
        h.guards = h.seps[0..guardCount-1]
        h.seps = h.seps[guardCount..high(h.seps)]
    else:
        h.guards = h.alphabet[0..guardCount-1]
        h.alphabet = h.alphabet[guardCount..high(h.alphabet)]
    
    return h


proc encrypt*(hashid : HashidRef, numbers : seq[int]): string = 
    ## Encrypts the specified numbers and returns the encrypted
    ## string.
    
    var retval : string = ""
    if len(numbers) == 0:
        return retval
    return hashid.encode(numbers)


proc decrypt*(hashid : HashidRef, hash : string): seq[int] = 
    ## Decrypts the the encrypted ``hash`` parameter and returns a 
    ## sequence containing the decrypted numbers.
    
    var ret : seq[int] = @[]
    
    if hash == "":
        return ret
    
    return hashid.decode(hash, hashid.alphabet)


proc encode(hashid : HashidRef, numbers : seq[int]): string = 
    ## Encodes the numbers. Internal proc.
    
    var numberHashInt : int = 0
    for i in 0..high(numbers):
        numberHashInt += numbers[i] mod (i + 100)
    
    var alphabet : string = hashid.alphabet
    var ret : string = alphabet[numberHashInt mod len(alphabet)] & ""
    var lottery : string = ret
    var num : int
    var sepsIndex : int
    var guardIndex : int
    var buffer : string = ret
    var retStr : string = ret
    var guard : string
    
    for i in 0..high(numbers):
        num = numbers[i]
        buffer = lottery & hashid.salt & alphabet
        
        alphabet = consistentShuffle(alphabet, buffer[0..len(alphabet)-1])
        var last : string = hash(num, alphabet)
        
        retStr &= last
        
        if i + 1 < len(numbers):
            num = num mod (int(last[0]) + i)
            sepsIndex = int(num mod len(hashid.seps))
            retStr &= (hashid.seps[sepsIndex] & "")
    
    if len(retStr) < hashid.minHashLength:
        guardIndex = (numberHashInt + int(retStr[0])) mod len(hashid.guards)
        guard = hashid.guards[guardIndex] & ""
        
        retStr = guard & retStr
        
        if len(retStr) < hashid.minHashLength:
            guardIndex = (numberHashInt + int(retStr[2])) mod len(hashid.guards)
            guard = hashid.guards[guardIndex] & ""
            
            retStr &= guard
    
    var halfLen : int = int(len(alphabet) / 2)
    while len(retStr) < hashid.minHashLength:
        alphabet = consistentShuffle(alphabet, alphabet)
        retStr = alphabet[halfLen..high(alphabet)] & retStr & alphabet[0..halfLen-1]
        var excess : int = len(retStr) - hashid.minHashLength
        if excess > 0:
            var startPos : int = int(excess / 2)
            retStr = retStr[startPos..startPos + hashid.minHashLength - 1]
    
    return retStr


proc decode(hashid : HashidRef, hash : string, alphabet2 : string): seq[int] = 
    ## Decodes the hash. Internal proc.
    
    var alphabet : string = alphabet2
    
    var ret : seq[int] = @[]
    
    var i : int = 0
    var regexp : string = "[" & hashid.guards & "]"
    var hashBreakdown : string = hash.replace(re(regexp), " ")
    var hashArray : seq[string] = hashBreakdown.split(" ")
    
    if len(hashArray) == 3 or len(hashArray) == 2:
        i = 1
    
    hashBreakdown = hashArray[i]
    
    var lottery : string = hashBreakdown[0] & ""
    hashBreakdown = hashBreakdown[1..high(hashBreakdown)]
    hashBreakdown = hashBreakdown.replace(re("[" & hashid.seps & "]"), " ")
    hashArray = hashBreakdown.split(" ")
    
    var subHash : string = ""
    var buffer : string = ""
    for j in 0..high(hashArray):
        subHash = hashArray[j]
        buffer = lottery & hashid.salt & alphabet
        alphabet = consistentShuffle(alphabet, buffer[0..len(alphabet)-1])
        ret = ret.concat(@[unhash(subHash, alphabet)])
    
    return ret
    

proc consistentShuffle(alphabet2 : string, salt : string): string = 
    ## Shuffles. Internal proc.
    
    var alphabet : string = alphabet2
    
    if len(salt) <= 0:
        return alphabet
    
    var arr : string = alphabet
    var ascVal : int
    var j : int
    var temp : string
    var i : int = len(alphabet) - 1
    var v : int = 0
    var p : int = 0
    while i > 0:
        
        v = v mod len(salt)
        ascVal = int(salt[v])
        p += ascVal
        j = (ascVal + v + p) mod i
        
        temp = alphabet[j] & ""
        alphabet = alphabet[0..i-1] & alphabet[i] & alphabet[(j + 1)..high(alphabet)]
        alphabet = alphabet[0..i-1] & temp & alphabet[(i + 1)..high(alphabet)]
        
        i -= 1
        v += 1
    
    return alphabet


proc hash(input2 : int, alphabet : string): string = 
    ## Hashes the input. Internal proc.
    
    var input : int = input2
    var hash : string = ""
    var alphabetLen : int = len(alphabet)
    
    hash = alphabet[int(input mod alphabetLen)] & hash
    input = int(input / alphabetLen)
    
    while input > 0:
        hash = alphabet[int(input mod alphabetLen)] & hash
        input = int(input / alphabetLen)
    
    return hash


proc unhash(input : string, alphabet : string): int = 
    ## Unhashes the input. Internal proc.
    
    var number : int = 0
    var pos : int
    
    for i in 0..high(input):
        pos = alphabet.find(input[i])
        number += pos * int(math.pow(float(len(alphabet)), float(len(input) - i - 1)))
    
    return number
