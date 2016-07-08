require 'open3'

class Xlo
  attr_accessor :rnv, :xmllint, :csv

  def initialize(_file)
    @rnv = []
    @xmllint = []
    @csv = _file
    @csv << "type; error; freq; files \n"
    @error = {}
  end

  def rnv_wrapper (_rnc, _dir)
    Dir[_dir + "/" + "*.xml"].each do |file|
      stdout = Open3.capture3("rnv #{_rnc} #{file}")
      stdout = stdout[1].split("\n")
      stdout.each do |line|
        @rnv << line
      end
    end
  end

  def rnv_aggregate
    @rnv.each do |el|
      if (line.include?("error") && !line.include?("are invalid"))

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

        if (@error.has_key?(key))
          @error[key] <<  " || " + filename
        else
          @error[key] = filename
        end

      end
    end
  end

  def xmllint_wrapper (_dir)
    Dir[_dir + "/" + "*.xml"].each do |file|
      stdout = Open3.capture3("xmllint #{file}")
      stdout = stdout[1].split("\n")
      stdout.each do |line|
        if (!line.include?("                 ^"))
          @xmllint << line.chomp
        end
      end
    end
  end

  def xmllint_aggregate
    @xmllint = @xmllint.values_at(* list.each_index.select {|i| i.even?})

    @xmllint.each do |el|
      split_el = el.split(" ")
      type = el[/element|attribute/]
      key = type + ";" + el.split(":")[-1]
      filename =  File.basename(split_el[0])[0..-2]
      if (@error.has_key?(key))
        @error[key] <<  " || " + filename
      else
        @error[key] = filename
      end
    end
  end

  def csv_writer
    @error.each do |dict|
      dict.each do |entry|
        freq = entry[1].split("||").length.to_s
        f.write(entry.insert(1, freq).join("; ")[0..-2] +  "\n" )
      end
    end
  end

  def self.main(_rnv_arg,_folder_arg)

    xlo = Xlo.new(File.new("error.csv",  "w+"))

    xlo.rnv_wrapper(_rnv_arg, _folder_arg)
    xlo.aggregate_rnv

    xlo.xmllint_wrapper(_folder_arg)
    xlo.xmllint_aggregate

    xlo.csv_writer
  end
end
