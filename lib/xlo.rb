require 'open3'

class Xlo
  attr_accessor :rnv, :xmllint, :csv

  def initialize(*args)
    @rnv = []
    @xmllint = []

    if args.size == 1
      @csv = File.new(args[0],"w+")
      @csv << "type; error; freq; files \n"
    end

    @error = {}
    @mutex = Mutex.new
  end

  def get_error
    return @error
  end

  def rnv_wrapper (_rnc, _file)
    rnv = []
    stdout = Open3.capture3("rnv #{_rnc} #{_file}")
    stdout = stdout[1].split("\n")
    stdout.each do |line|
      rnv << line
    end
    return rnv
  end

  def rnv_aggregate(_rnv)
    _rnv.each do |el|
      if (el.include?("error") && !el.include?("are invalid"))

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
        @mutex.synchronize do
          if (@error.has_key?(key))
            @error[key] <<  " || " + filename
          else
            @error[key] = filename
          end
        end
      end
    end
  end

  def xmllint_wrapper (_file)
    xmllint = []
    stdout = Open3.capture3("xmllint #{_file}")
    stdout = stdout[1].split("\n")
    stdout.each do |line|
      xmllint << line
    end
    return xmllint
  end

  def xmllint_aggregate(_xmllint)
    _xmllint.delete_if {|el| el.include?("^")}
    _xmllint.map { |e| e.chomp  }
    _xmllint = _xmllint.values_at(* _xmllint.each_index.select {|i| i.even?})
    _xmllint.each do |el|
      split_el = el.split(" ")
      type = el[/element|attribute|parser error/]
      key = type + ";" + el.split(":")[-1]
      filename =  File.basename(split_el[0])[0..-2]
      @mutex.synchronize do
        if (@error.has_key?(key))
          @error[key] <<  " || " + filename
        else
          @error[key] = filename
        end
      end
    end
  end

  def csv_writer
    @error.each do |entry|
      line =  entry.dup
      line[-1] = line[-1].split("||")[0..50].join
      freq = entry[1].split("||").length
      @csv.write(line.insert(1, freq.to_s).join(";")[0..-2] +  "\n" )
    end
  end

  def run(_rnv_arg, _folder_arg, _pool_size = 1)
    jobs = Queue.new
    Dir[_folder_arg + "/" + "*.xml"].each {|f| jobs.push f}

    workers = (_pool_size).times.map do
      Thread.new do
        while jobs.size != 0
          file = jobs.pop
          rnv_aggregate(rnv_wrapper(_rnv_arg,file))
          xmllint_aggregate(xmllint_wrapper(file))
        end
      end
    end
    workers.map(&:join)
  end

  def self.main(_rnv_arg,_folder_arg)
    require 'facter'
    xlo = Xlo.new("error.csv")
    xlo.run(_rnv_arg, _folder_arg, Facter.value('processors')['count'])
    xlo.csv_writer
  end
end
