About
=====

nim-hashids is a Nim implementation of Hashids (http://hashids.org).

Basic example:

    let hashids: Hashids = createHashids("this is my salt")
    let id: string = hashids.encode(@[1, 2, 3])
    let numbers: seq[int] = hashids.decode(id)

License
=======

nim-hashids is released under the MIT open source license.
