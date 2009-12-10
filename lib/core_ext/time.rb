##
# Copyright (c) 2009 Rahmal Conda <rahmal@gmail.com>
#
# Extension of Time for xml processing.
class Time

  @format = $xml_util.config['formats']['time']

  def to_xml_text
    self.strftime(@format)
  rescue Exception => e
    $stderr.puts "Error converting Time to String: format: #{@format}, time: #{this.to_s}"
    nil
  end

  def instance_data_to_xml(element)
    element.try.add_text(to_xml_text)
  end

  def self.from_xml(element)
    return nil unless element
    Time.parse(element.text)
  rescue Exception => e
    $stderr.puts "Error converting element text to Time: [#{element.inspect}]"
    nil
  end

end
