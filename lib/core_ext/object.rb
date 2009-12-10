##
# Copyright (c) 2009 Rahmal Conda <rahmal@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
require 'rexml/document'
require 'singleton'
require 'parsedate'
require 'time'


class Object

  ##
  # Call this meta-programming method in a class to give that class
  # xml serializable behaviour such as:
  #
  #   1) product.to_xml
  #   2) Product.from_xml(xml_str)
  #
  # Example call:
  #   class Product
  #     acts_as_xml_resource
  #     ...
  #   end # class
  def self.acts_as_xml_resource *args

  end

  def element_name
    self.class.name.gsub('::', '-')
  end

  ##
  # Create element from class name
  def create_element
    REXML::Element.new(element_name)
  end

  ##
  # Creates xml content in the form of a REXML::Element object
  # from the its instance data.
  def to_xml(root = nil)
    unless root
      element = create_element
    else
      if $xml_util.config[:use_type]
        element = create_element
        root.add_element(element)
      else
        element = root
      end
    end

    instance_data_to_xml(element)

    element
  end

  ##
  # Called by to_xml. Dumps the instance variables of
  # this instance into a string formatted into typed
  # or non-typed xml with the names of the instance
  # variables as tags, and their values as the data.
  def instance_data_to_xml(element)
    return nil unless element
    instance_variables.each do |var|
      var.sub!(/@/, '').sub!(/::/, '-')
      value = self.instance_variable_get("@#{var}")
      unless value.nil?
        elem = element.add_element(var)
        self.instance_eval "value = (@#{var}).to_xml(elem)"
      end
    end
  end

  ##
  # Converts object to string for xml processing.
  def to_xml_text
    self.to_s
  end

  ##
  # Descendant classes can override this to force type elements
  # to be output. Array and Hash use this depending on their contents
  def type_elements_required?
    false
  end


  ##
  # Extremely useful convienence method.
  #
  #   @person ? @person.name : nil
  # vs
  #   @person.try(:name)
  def try(method)
    send method if respond_to? method
  end

  def to_b
    false
  end

end # class Object
