require 'digest/md5'
require 'net/http'

class BozoCrack

  def initialize(filename)
    @hashes = Array.new
    @cache = Hash.new

    File.new(filename).each_line do |line|
      if m = line.chomp.match(/\b([a-fA-F0-9]{32})\b/)
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
    if plaintext = crack_single_hash_with_website(hash, "http://www.google.com/search?q=#{hash}")
      return plaintext
    end
    if plaintext = crack_single_hash_with_website(hash, "http://www.google.com/search?q=md5+#{hash}")
      return plaintext
    end
    nil
  end

  def crack_single_hash_with_website(hash, url)
    response = Net::HTTP.get URI(url)
    wordlist = response.split(/\s+/)
    if plaintext = dictionary_attack(hash, wordlist)
      return plaintext
    end
    nil
  end

  def dictionary_attack(hash, wordlist)
    wordlist.each do |word|
      if Digest::MD5.hexdigest(word) == hash.downcase
        return word
      end
      sub_wordlist = word.split(/[^a-zA-Z0-9]+/)
      if (sub_wordlist.size > 1)
        if plaintext = dictionary_attack(hash, sub_wordlist)
          return plaintext
        end
      end
    end
    nil
  end

  def load_cache(filename = "cache")
    if File.file? filename
      File.new(filename).each_line do |line|
        if m = line.chomp.match(/^([a-fA-F0-9]{32}):(.*)$/)
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
