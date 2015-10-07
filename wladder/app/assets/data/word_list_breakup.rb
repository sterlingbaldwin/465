out = File.open("./words_out.txt", "w")
File.open("./words.txt", "r") do |f|
  f.each_line do |line|
    line = line.split " "
    line.each do |x|
      out.write(x + "\n")
    end
  end
end
