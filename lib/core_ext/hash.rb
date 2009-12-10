class Hash

  @pair_delimiter =  ","
  @key_value_delimiter = "="


  def instance_data_to_xml(element)

    use_type =  $xml_util.config['use_type'] || type_required?

    if use_type
      # If use_type is set to false, but type is required for a
      # non-simple class type, override it, then reset it later.
      orig = $xml_util.config['use_type']
      $xml_util.config['use_type'] = true
      each do |key, value|
        key_elem = REXML::Element.new('Key')
        key.to_xml(key_elem)

        val_elem = REXML::Element.new('Value')
        value.to_xml(val_elem)

        pair = REXML::Element.new('Pair')
        pair.add_element(key_elem)
        pair.add_element(val_elem)

        element.add_element(pair)
      end
      $xml_util.config['use_type'] = orig
    else
      text = ''
      each do |key, value|
        text = text + Hash.pair_delimiter if !text.empty?
        text = text + key.to_xml_text + Hash.key_value_delimiter + value.to_xml_text
      end

      element.add_text(text)
    end
  end



  def self.from_xml(element)
    result = {}
    if element.has_elements?
      element.each_element do |pair|
        key_elem = pair.elements[1]
        key_type = key_elem.elements[1]
        key = $xml_util.class_for(key_type.name).from_xml(key_type)
        val_elem = pair.elements[2]
        val_type = val_elem.elements[1]
        val = $xml_util.class_for(val_type.name).from_xml(val_type)
        result[key] = val
      end
    else
      text = element.text
      if text != nil
        pairs = text.split(@pair_delimiter)
        pairs.each do |pair|
          key, value = pair.split(@key_value_delimiter)
          key = $xml_util.simple_type(key)
          val = $xml_util.simple_type(val)
          result[key] = val
        end
      end
    end

    result
  end


private

  def type_required?
    not all_elems_simple?
  end

  def all_elems_simple?
    all? {|key, val| $xml_util.simple_type?(key) && $xml_util.simple_type?(val) }
  end

end


