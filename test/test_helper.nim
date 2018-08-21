proc seqsEqual*(expected: seq[int], actual: seq[int]): bool = 
    if len(expected) != len(actual):
        return false
    for val in expected:
        if not val in actual:
            return false
    for val in actual:
        if not val in expected:
            return false
    return true
