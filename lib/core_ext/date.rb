require 'xml_resource_util'

##
# Copyright (c) 2009 Rahmal Conda <rahmal@gmail.com>
#
# Extension of Date for xml processing.
class Date

  @format = $xml_util.config['formats']['date']

  def to_xml_text
    self.strfdate(@format)
  rescue Exception => e
    $stderr.puts "Error converting Date to String: format: #{@format}, date: #{self.to_s}"
    nil
  end

  def instance_data_to_xml(element)
    element.try.add_text(to_xml_text)
  end

  def self.from_xml(element)
    return nil unless element
    Date.parse(element.text)
  rescue Exception => e
    $stderr.puts "Error converting element text to Date: [#{element.inspect}]"
    nil
  end

end
