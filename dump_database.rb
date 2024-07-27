def dump_data(key)
  items = load_data("Data/#{key}.rxdata")
  File.open("InternalDataBase/#{key}.yaml", "w") do |f|
    for i in 1...items.size
      item = items[i]
      f.write("- id: #{i}\n")
      variables = item.instance_variables.collect{|x| x.to_s}.sort
      for var in variables
        next if var == "@id"
        key = var.to_s.sub(/^@/, '')
        value = item.instance_variable_get(var)
        case value
        when Array
          if value.empty?
            f.write("  #{key}: []\n")
          else
            f.write("  #{key}:\n")
            for v in value
              f.write("    - #{v}\n")
            end
          end
        when String, Fixnum, Integer, Float, TrueClass, FalseClass, NilClass
          f.write("  #{key}: #{value}\n")
        else
          f.write("  #{key}: null\n")
        end
      end
    end
  end
end

if $DEBUG
  Dir.mkdir("InternalDataBase") unless File.exist?("InternalDataBase")
  dump_data("Actors")
  dump_data("Classes")
  dump_data("Items")
  dump_data("Skills")
  dump_data("Armors")
  dump_data("Weapons")
end
