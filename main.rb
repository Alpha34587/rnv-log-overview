def fill_list (_dir)
  list = []
  Dir[_dir + "/" + "*.log"].each do |file|
    p file
    File.open(file, 'r') do |f1|
      while line = f1.gets
        if (line.include?("error") && !line.include?("are invalid"))
          list << line
        end
      end
    end
  end
  return list
end

def create_error_dict (_list)
  error = {}
  _list.each do |el|
    type = el.split("error")[1].split(" ")[1]
    key = type + "; " + el[/\^.*/][1..-1]
    filename = File.basename(el.split("error")[0])
    filename[filename.length - 2] = ""
    if (error.has_key?(key))
      error[key] <<  " || " + filename
    else
      error[key] = filename
    end
  end
  return error
end

def xmllint_error (_file,_error_dict)
  list = []
  File.open(_file).each do |line|
    if (!line.include?("^\n"))
      list << line.chomp
    end
  end

  list = list.values_at(* list.each_index.select {|i| i.even?})
  list.each do |el|
    split_el = el.split(" ")
    type = el[/element|attribute/]
    key = type + ";" + el.split(":")[-1]
    filename =  File.basename(split_el[0])[0..-2]
    if (_error_dict.has_key?(key))
      _error_dict[key] <<  " || " + filename
    else
      _error_dict[key] = filename
    end
  end
end

rnv_arg = ARGV.shift
xmllint_arg = ARGV.shift
raise "missing argument" unless rnv_arg

f = File.new("error.csv",  "w+")
f.write("type; error; freq; files \n")
error = create_error_dict(fill_list(rnv_arg))

if (xmllint_arg != nil)
  xmllint_error(xmllint_arg, error)
end
error.each do |entry|
  freq = entry[1].split("||").length.to_s
  f.write(entry.insert(1, freq).join("; ")[0..-2] +  "\n" )
end
