require 'xml_resource_util'

##
# Copyright (c) 2009 Rahmal Conda <rahmal@gmail.com>
#
# Extension of Numeric for xml processing.
class Numeric

  ##
  # Adds the numeric value in string form to the given element.
  def instance_data_to_xml(element)
    element.try.add_text(to_xml_text)
  end

end

class Integer
  def self.from_xml(element)
    element.try.text.to_i
  end
end

class Float
  def self.from_xml(element)
    element.try.text.to_f
  end
end


