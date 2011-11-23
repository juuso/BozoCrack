#!/usr/bin/env python
import hashlib
import re
from urllib import FancyURLopener
import sys

HASH_REGEX = re.compile("([a-fA-F0-9]{32})")

class MyOpener(FancyURLopener):
    version = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; it; rv:1.8.1.11) Gecko/20071127 Firefox/2.0.0.11'

def dictionary_attack(h, wordlist):
    for word in wordlist:
        m = hashlib.md5()
        m.update(word)

        if m.hexdigest() == h:
            return word

    return None

def crack_single_hash(h):
    myopener = MyOpener()
    response = myopener.open("http://www.google.com/search?q={hash}".format(hash=h))
    
    wordlist = response.read().replace('.',' ').replace(':',' ').replace('?','').split(' ')
    plaintext = dictionary_attack(h, set(wordlist))
    
    return plaintext

class BozoCrack(object):
    def __init__(self, filename, *args, **kwargs):
        self.hashes = []
        self.cache = {}
        
        with open(filename, 'r') as f:
            hashes = [x for line in f if HASH_REGEX.match(line) for x in HASH_REGEX.findall(line.replace('\n',''))]

        self.hashes = sorted(list(set(hashes)))

        print "Loaded {count} unique hashes".format(count=len(self.hashes))

        self.load_cache()
                                                     
    def crack(self):
        for h in self.hashes:
            if h in self.cache:
                print "{hash}:{plaintext}".format(hash=h, plaintext=self.cache[h])
                continue

            plaintext = crack_single_hash(h)

            if plaintext:
                print "{hash}:{plaintext}".format(hash=h, plaintext=plaintext)
                self.cache[h] = plaintext
                self.append_to_cache(h, plaintext)
            
    def load_cache(self, filename='cache'):
        with open(filename, 'a+') as c:
            for line in c:
                line = line.replace('\n','').split(':')
                self.cache[line[0]] = line[1]

    def append_to_cache(self, h, plaintext, filename='cache'):
        with open(filename, 'a+') as c:
            c.write("{hash}:{plaintext}\n".format(hash=h, plaintext=plaintext))

if __name__ == '__main__':
    
    if len(sys.argv) == 2:
        target = sys.argv[1]
        if HASH_REGEX.match(target):
            plaintext = crack_single_hash(target)

            if plaintext:
                print "{hash}:{plaintext}".format(hash=target, plaintext=plaintext)
        else:
            BozoCrack(target).crack()
    else:
        print """Usage example: 
\tpython bozocrack.py file_with_md5_hashes.txt
OR:
\tpython bozocrack.py fcf1eed8596699624167416a1e7e122e

"""
    
