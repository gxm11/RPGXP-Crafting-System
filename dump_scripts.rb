if $DEBUG
  Dir.mkdir("InternalScripts") unless File.exist?("InternalScripts")
  for x in load_data("Data/Scripts.rxdata"):
    name = x[1].gsub(" ", "_")
    encoded = x[2]
    scripts = Zlib::Inflate.inflate(encoded)
    scripts.gsub!("\r\n", "\n")
    File.open("InternalScripts/#{name}.rb", "w") { |f| f.write(scripts) }
  end
  exit
end
