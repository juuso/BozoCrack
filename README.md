# BozoCrack
BozoCrack is a depressingly effective MD5 password hash cracker with almost zero CPU/GPU load. Instead of rainbow tables, dictionaries, or brute force, BozoCrack simply *finds* the plaintext password. Specifically, it googles the MD5 hash and hopes the plaintext appears somewhere on the first page of results.

It works way better than it ever should.


## How?
Basic usage:

    $ python bozocrack.py my_md5_hashes.txt

Or:

    $ python bozocrack.py fcf1eed8596699624167416a1e7e122e

The input file has no specified format. BozoCrack automatically picks up strings that look like MD5 hashes. A single line shouldn't contain more than one hash.

Example with output:

    $ python bozocrack.py example.txt
    Loaded 5 unique hashes
    fcf1eed8596699624167416a1e7e122e:octopus
    bed128365216c019988915ed3add75fb:passw0rd
    d0763edaa9d9bd2a9516280e9044d885:monkey
    dfd8c10c1b9b58c8bf102225ae3be9eb:12081977
    ede6b50e7b5826fe48fc1f0fe772c48f:1q2w3e4r5t6y

    $ python bozocrack.py fcf1eed8596699624167416a1e7e122e
    fcf1eed8596699624167416a1e7e122e:octopus


## Why?
To show just how bad an idea it is to use plain MD5 as a password hashing mechanism. Honestly, if the passwords can be cracked with *this software*, there are no excuses.


## Who?
BozoCrack was originally written by [Juuso Salonen](http://twitter.com/juusosalonen), the guy behind [Radio Silence](http://radiosilenceapp.com) and [Private Eye](http://radiosilenceapp.com/private-eye). BozoCrack was rewritten in Python by [Henrique Pereira](http://twitter.com/ikkebr), the guy behind [Ruby Brasil](http://www.ruby-br.com.br).


## License
Do whatever you wish. Public domain, yadda yadda.
