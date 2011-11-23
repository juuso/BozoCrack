import hashlib
import re
from urllib import FancyURLopener
import sys

class MyOpener(FancyURLopener):
    version = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; it; rv:1.8.1.11) Gecko/20071127 Firefox/2.0.0.11'

class BozoCrack(object):
    def __init__(self, filename, *args, **kwargs):
        hash_regex = re.compile("([a-fA-F0-9]{32})")
        self.hashes = []
        self.cache = {}
        
        with open(filename, 'r') as f:
            hashes = [line.replace('\n','') for line in f if hash_regex.match(line)]

        self.hashes = sorted(list(set(hashes)))

        print "Loaded {count} unique hashes".format(count = len(hashes))

        self.load_cache()
                                                     
    def crack(self):
        for h in self.hashes:
            if h in self.cache:
                print "{hash}:{plaintext}".format(hash = h, plaintext = self.cache[h])
                continue

            plaintext = self.crack_single_hash(h)

            if plaintext:
                print "{hash}:{plaintext}".format(hash = h, plaintext=plaintext)
                self.cache[h] = plaintext
                self.append_to_cache(h, plaintext)
                
                

    def dictionary_attack(self, h, wordlist):
        for word in wordlist:
            m = hashlib.md5()
            m.update(word)

            if m.hexdigest() == h:
                return word

        return None
            
    def crack_single_hash(self, h):
        myopener = MyOpener()
        response = myopener.open("http://www.google.com/search?q={hash}".format(hash=h))
        
        wordlist = response.read().replace('.',' ').split(' ')
        plaintext = self.dictionary_attack(h, set(wordlist))
        
        return plaintext

    def load_cache(self, filename='cache'):
        with open(filename, 'a+') as c:
            for line in c:
                line = line.replace('\n','').split(':')
                self.cache[line[0]] = line[1]

    def append_to_cache(self, h, plaintext, filename='cache'):
        with open(filename, 'a+') as c:
            c.write("{hash}:{plaintext}\n".format(hash=h, plaintext=plaintext))

if __name__ == 'main':
    if len(sys.argv) == 1:
        BozoCrack(sys.argv[0]).crack()
    else:
        print "Usage example: python bozocrack.py file_with_md5_hashes.txt"
    
