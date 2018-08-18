proc seqsEqual(expected: seq[int], actual: seq[int]): boolean = 
    if len(expected) != len(actual):
        return false
    for val in expected:
        if val not in actual:
            return false
    for val in actual:
        if val not in expected:
            return false
    return true
