#!/usr/bin/env ruby

require 'digest/md5'
require 'net/http'

class BozoCrack

  def initialize(filename)
    @hashes = Hash.new
    @cache = Hash.new

    File.new(filename).each_line do |line|
      if m = line.chomp.match(/\b(.*):([a-f0-9]{32})\b/i)
        @hashes[m[1]] = m[2].downcase
      end
    end
    puts "Loaded #{@hashes.count} unique hashes"

    load_cache
  end

  def crack
    puts "%16s | %16s | %32s" % %w(User Password Hash)
    puts "-" * 72
    @hashes.each do |user, hash|
      if plaintext = @cache[hash]
        puts "%16s | %16s | %32s" % [user, plaintext, hash]
        next
      end
      if plaintext = crack_single_hash(hash)
        puts "%16s | %16s| %32s" % [user, plaintext, hash]
        append_to_cache(hash, plaintext)
      end
      sleep 1
    end
  end

  private

  def crack_single_hash(hash)
    response = Net::HTTP.get(URI("http://www.google.com/search?q=#{hash}"))
    wordlist = response.split(/\s+/)
    dictionary_attack(hash, wordlist)
  end

  def dictionary_attack(hash, wordlist)
    wordlist.each do |word|
      return word if Digest::MD5.hexdigest(word) == hash
    end
    nil
  end

  def load_cache(filename = "cache")
    if File.file? filename
      File.new(filename).each_line do |line|
        if m = line.chomp.match(/^([a-f0-9]{32}):(.*)$/i)
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

if ARGV.size == 1
  BozoCrack.new(ARGV[0]).crack
else
  puts "Usage example: ruby bozocrack.rb file_with_md5_hashes.txt"
end
