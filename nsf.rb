input = ARGV

def header filename
  temporary = File.binread(filename)
  temporary.unpack("A5H2CCH4H4H4A32A32A32H4H16H4B8B8B8")
end

def music filename
  temporary = File.binread(filename)
  temporary.unpack("@128H*")[0].chars
end

def display_header raw_data
    raw_data.map.with_index do |item, i|
        "#{i}: #{item}"
    end
end

def chunk_hex binary
  chunked = 4
  base = 0
  arr = []
  mus = music binary
  mus.each do
    arr << mus[base,chunked].join('') unless mus[base,chunked].nil?
    base += chunked
  end
  arr
end

def main file
  if file[0][0] == "-"
    head = header file[1]
    if file[0].include? "h"
      puts display_header head
    elsif file[0].include? "m"
      p chunk_hex file[1]
    else
      puts "No such option"
    end
  else
    puts header(file[0])[7]
    puts header(file[0])[8]
    puts header(file[0])[9]
  end
end

begin
  main input
rescue
  puts "Usage: ruby nsf.rb <FILE.NSF>"
end
