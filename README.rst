===============================
PyBozoCrack
===============================

.. image:: https://badge.fury.io/py/pybozocrack.png
   :target: http://badge.fury.io/py/pybozocrack
    
.. image:: https://travis-ci.org/ikkebr/PyBozoCrack.svg
   :target: https://travis-ci.org/ikkebr/PyBozoCrack
   
.. image:: https://coveralls.io/repos/ikkebr/PyBozoCrack/badge.png 
   :target: https://coveralls.io/r/ikkebr/PyBozoCrack

.. image:: https://pypip.in/d/pybozocrack/badge.png
   :target: https://pypi.python.org/pypi/pybozocrack


PyBozoCrack is a depressingly effective MD5 password hash cracker with almost zero CPU/GPU load written in Python. Instead of rainbow tables, dictionaries, or brute force, PyBozoCrack simply *finds* the plaintext password. Specifically, it googles the MD5 hash and hopes the plaintext appears somewhere on the first page of results.

* Free software: BSD license
* Documentation: http://pybozocrack.rtfd.org.

It works way better than it ever should.


How?
----
Basic usage:

   **$ python pybozocrack.py -f my_md5_hashes.txt**

Or:

    **$ python pybozocrack.py -s fcf1eed8596699624167416a1e7e122e**

The input file has no specified format. BozoCrack automatically picks up strings that look like MD5 hashes. A single line shouldn't contain more than one hash.


Example with output:

    **$ python pybozocrack.py -f example.txt**
    
        Loaded 5 unique hashes
    
        fcf1eed8596699624167416a1e7e122e:octopus
    
        bed128365216c019988915ed3add75fb:passw0rd
    
        d0763edaa9d9bd2a9516280e9044d885:monkey
    
        dfd8c10c1b9b58c8bf102225ae3be9eb:12081977
    
        ede6b50e7b5826fe48fc1f0fe772c48f:1q2w3e4r5t6y



    **$ python pybozocrack.py -s fcf1eed8596699624167416a1e7e122e**

        fcf1eed8596699624167416a1e7e122e:octopus


Why?
----
To show just how bad an idea it is to use plain MD5 as a password hashing mechanism. Honestly, if the passwords can be cracked with *this software*, there are no excuses.


Who?
----
BozoCrack was originally written by Juuso Salonen (http://twitter.com/juusosalonen).

PyBozoCrack was rewritten in Python by Henrique Pereira (http://twitter.com/ikkebr).
