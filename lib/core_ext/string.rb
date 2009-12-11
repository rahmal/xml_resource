require 'xml_resource_util'

##
# Copyright (c) 2009 Rahmal Conda <rahmal@gmail.com>
#
# Extension of String for xml processing.
class String

  # Shortcut method to true string into boolean
  # Returns the result of interpreting leading 
  # characters in str as a boolean.
  def to_b
    self.lstrip[0..3] == 'true'
  end

  ##
  # Return the string as xml text. Since string is already xml-ready,
  # this method just returns the string.  In case it's frozen, return 
  # dup to avoid errors if string is altered during xml processing.
  def to_xml_text
    self.dup
  end

  ##
  # Adds the string value to the given element.
  def instance_data_to_xml(element)
    element.try.add_text(to_xml_text)
  end

  ##
  # Returns the string text from the given element. As with
  # to_xml_text method, it return a dup to aviod conflicts.
  def self.from_xml(element)
    element.try.text.dup
  end

end
