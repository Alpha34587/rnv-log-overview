require 'open3'

class Xlo

  def self.rnv_wrapper (_rnc, _dir)
    list = []
    Dir[_dir + "/" + "*.xml"].each do |file|
      stdout = Open3.capture3("rnv #{_rnc} #{file}")
      stdout = stdout[1].split("\n")
      stdout.each do |line|
          if (line.include?("error") && !line.include?("are invalid"))
            list << line
          end
      end
    end
    return list
  end

  def self.rnv_error_dict (_list)
    error = {}
    _list.each do |el|
      type = el.split("error")[1].split(" ")[1]
      if (type == "attribute" || type == "element")
        key =  type + "; " + el[/\^.*/][1..-1]
        filename = File.basename(el.split("error")[0])
        filename[filename.length - 2] = ""
      else
        type = "other"
        key = type + "; " + el.split("error:")[1]
        filename = File.basename(el.split("error")[0])
        filename[filename.length - 2] = ""
      end
      if (error.has_key?(key))
        error[key] <<  " || " + filename
      else
        error[key] = filename
      end
    end
    return error
  end

  def self.xmllint_wrapper (_dir)
    list = []
    Dir[_dir + "/" + "*.xml"].each do |file|
      stdout = Open3.capture3("xmllint #{file}")
      stdout = stdout[1].split("\n")
      stdout.each do |line|
        if (!line.include?("                 ^"))
            list << line.chomp
        end
      end
    end

    error = {}
    list = list.values_at(* list.each_index.select {|i| i.even?})
    list.each do |el|
      split_el = el.split(" ")
      type = el[/element|attribute/]
      key = type + ";" + el.split(":")[-1]
      filename =  File.basename(split_el[0])[0..-2]
      if (error.has_key?(key))
        error[key] <<  " || " + filename
      else
        error[key] = filename
      end
    end
    return error
  end

  def self.main(_rnv_arg,_folder_arg)

    error = []
    f = File.new("error.csv",  "w+")
    f.write("type; error; freq; files \n")

    list = self.rnv_wrapper(_rnv_arg, _folder_arg)
    error << self.rnv_error_dict(list)

    error << self.xmllint_wrapper(_folder_arg)

    error.each do |dict|
      dict.each do |entry|
        freq = entry[1].split("||").length.to_s
        f.write(entry.insert(1, freq).join("; ")[0..-2] +  "\n" )
      end
    end
  end
end
