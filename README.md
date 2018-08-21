About
=====

nim-hashids is a Nim implementation of Hashids (http://hashids.org).

Basic example:

    var hashids: Hashids = createHashids("this is my salt")
    var id: string = hashids.encode(@[1, 2, 3])
    var numbers: seq[int] = hashids.decode(id)

License
=======

nim-hashids is released under the MIT open source license.
