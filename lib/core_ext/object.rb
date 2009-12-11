require 'rexml/document'
require 'xml_resource_util'

##
# Copyright (c) 2009 Rahmal Conda <rahmal@gmail.com>
#
# Extension of Object for xml processing.
class Object

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
  # Adds this instance in string form to the given element.
  def instance_data_to_xml(element)
    element.try.add_text(to_xml_text)
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
