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
f = File.new("error.csv",  "w+")
f.write("type; error; files \n")
create_error_dict(fill_list(ARGV[0])).each do |entry|
  f.write(entry.join("; ")[0..-2] + "\n" )
end
