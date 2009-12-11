require 'xml_resource_util'

##
# Copyright (c) 2009 Rahmal Conda <rahmal@gmail.com>
#
# Extension of Array for xml processing.
class Array

  @delimiter =  ","

  def instance_data_to_xml(element)
    return nil unless element

    use_type =  $xml_util.config['use_type'] || type_required?

    if use_type
      # If use_type is set to false, but type is required for a
      # non-simple class type, override it, then reset it later.
      orig = $xml_util.config['use_type']
      $xml_util.config['use_type'] = true

      each do |item|
        item.to_xml(element)
      end

      $xml_util.config['use_type'] = orig
    else
      text = collect{|item| item.to_xml_text }.join(@delimiter)
      element.add_text(text)
    end
  end

  def self.from_xml(element)
    return nil unless element
    result = []
    if element.has_elements?
      element.elements.each do |item|
        child = item
        type = child.name
        result << $xml_util.class_for(type).from_xml(child)
      end
    else
      text = element.text
      if text != nil
        result = text.split(@delimiter)
        result.collect!{|item| $xml_util.simple_type(item) }
      end
    end
    result
  end


private

  def type_required?
    not all_elems_simple?
  end

  def all_elems_simple?
    all? {|item| $xml_util.simple_type? item }
  end

end


