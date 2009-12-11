require 'xml_resource_util'

##
# Copyright (c) 2009 Rahmal Conda <rahmal@gmail.com>
#
# Extension of TrueClass for xml processing.
class TrueClass
  def instance_data_to_xml(element)
    element.try.add_text(to_xml_text)
  end

  def self.from_xml(element)
    element.try.text.to_b
  end

  def to_b
    self
  end

end

##
# Copyright (c) 2009 Rahmal Conda <rahmal@gmail.com>
#
# Extension of FalseClass for xml processing.
class FalseClass
  def instance_data_to_xml(element)
    element.try.add_text(to_xml_text)
  end

  def self.from_xml(element)
    element.try.text.to_b
  end

  def to_b
    self
  end

end
