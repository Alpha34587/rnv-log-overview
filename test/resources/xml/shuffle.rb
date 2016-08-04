require 'nokogiri'

Dir["*.xml"].each do |x|
  doc = Nokogiri.XML(File.read(x))
  doc.xpath("//*/text()").each do |line|
    if (line.content.split("")[0] != "\n")
      line.content = line.content.split("").shuffle.join("")
    end
  end
  p x.class
  File.open(x,"w+").write(doc.to_xml)
end
