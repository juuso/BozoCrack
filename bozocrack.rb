#!/usr/bin/env ruby

require 'digest/md5'
require 'net/http'

HASHES = {
    :md5 => {
        :require => 'digest/md5',
        :size    => 32,
        :class   => Digest::MD5
    },
    :sha1 => {
        :require => 'digest/sha1',
        :size    => 40,
        :class   => Digest::SHA1        
    },
    :sha2 => {
        :require => 'digest/sha2',
        :size    => 64,
        :class   => Digest::SHA2        
    },
}

class BozoCrack

  def initialize(filename, hash=:md5)
    @hashes = Array.new
    @cache = Hash.new
    @hash  = HASHES[hash]
    raise "Unknown hash function #{hash} - try one of #{HASHES.keys.join(', ')}\n" unless @hash
    require @hash[:require]    
    @hash_regex = "\\b([a-fA-F0-9]{#{@hash[:size]}})\\b"

    File.new(filename).each_line do |line|
      if m = line.chomp.match(/#{@hash_regex}/)
        @hashes << m[1]
      end
    end
    @hashes.uniq!
    puts "Loaded #{@hashes.count} unique hashes"

    load_cache
  end

  def crack
    @hashes.each do |hash|
      if plaintext = @cache[hash]
        puts "#{hash}:#{plaintext}"
        next
      end
      if plaintext = crack_single_hash(hash)
        puts "#{hash}:#{plaintext}"
        append_to_cache(hash, plaintext)
      end
      sleep 1
    end
  end

  private

  def crack_single_hash(hash)
    response = Net::HTTP.get URI("http://www.google.com/search?q=#{hash}")
    wordlist = response.split(/\s+/)
    if plaintext = dictionary_attack(hash, wordlist)
      return plaintext
    end
    nil
  end

  def dictionary_attack(hash, wordlist)
    wordlist.each do |word|
      if @hash[:class].hexdigest(word) == hash.downcase
        return word
      end
    end
    nil
  end

  def load_cache(filename = "cache")
    if File.file? filename
      File.new(filename).each_line do |line|
        if m = line.chomp.match(/^(#{@hash_regex}):(.*)$/)
          @cache[m[1]] = m[2]
        end
      end
    end
  end

  def append_to_cache(hash, plaintext, filename = "cache")
    File.open(filename, "a") do |file|
      file.write "#{hash}:#{plaintext}\n"
    end
  end

end

hash = :md5
while ARGV[0] =~ /^--/ do
    opt = ARGV.shift
    if opt == "--hash"
        raise "#{opt} needs a parameter" if ARGV.empty?
        hash = ARGV.shift.to_sym
    else
        raise "Unknown option #{opt}"
    end
end

if ARGV.size == 1
  BozoCrack.new(ARGV.shift, hash).crack
else
  puts "Usage example: ruby #{File.basename($0)} [arg[s]] file_with_md5_hashes.txt"
end
