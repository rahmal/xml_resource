module XmlResource

  if self.class.kind_of?(ActiveRecord::Base)
    ##
    # Extra method for models that extend ActiveRecord::Base
    # Called by instance_data_to_xml. Dumps the attribute data
    # of this instance into a string formatted into typed or
    # non-typed xml with the names of the attributes as tags,
    # and their values as the data.
    def attributes_to_xml(element)
      return nil unless element
      attributes.each do |key, val|
        val.to_xml(element.add_element(key.to_s)) unless val.nil?
      end
    end
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
    attributes_to_xml(element) if self.class.kind_of?(ActiveRecord::Base)
  end

  ##
  # Adds from_xml to the including class as a class method.
  def self.append_features(including_class)
    super

    if including_class.kind_of? ActiveRecord::Base

      # Use Attributes for AR:B objects
      def including_class.from_xml(element)

        # Always use new with AR:B
        object = self.new

        element.elements.each do |attr_element|
          attr_name = attr_element.name
          if attr_element.has_elements?
            child_elem = attr_element.elements[1]
            class_name = child_elem.name
            attr_class = $xml_util.class_for(class_name)
          else
            child_elem = attr_element
            value = $xml_util.simple_type(attr_element.text)
            class_name = child_elem.name
            attr_class = $xml_util.class_for(class_name)

            unless attr_class.kind_of?(Enumerable)
              if $xml_util.simple_type(value)
                object.attributes[attr_name.to_sym] = value
                next
              end

              if attr_var = object.attributes[attr_name.to_sym]
                class_name = attr_var.class.name
                attr_class = attr_var.class
              end
            end # unless attr...
          end   # if attr...

          # If its an enumerable, the it is an association
          # Associations can not be set using attributes
          if attr_class.kind_of?(Enumerable)
            value = attr_class.from_xml(child_elem)
            object.instance_eval "#{attr_name} = value"
          else
            value = attr_class.from_xml(child_elem)
            object.attributes[attr_name.to_sym] = value
          end
        end # each

        object
      end

    else

      # Use instance vars for normal (non AR:B) objects
      def including_class.from_xml(element)
        object = $xml_util.config.bypass_initialize ? self.allocate : self.new

        element.elements.each do |instance_element|
          instance_var_name = instance_element.name
          if instance_element.has_elements?
            child_elem = instance_element.elements[1]
            class_name = child_elem.name
          else
            child_elem = instance_element
            instance_var = object.instance_eval "@#{instance_var_name}"
            if instance_var.instance_of? NilClass
              value = $xml_util.simple_type(instance_element.text)
              object.instance_eval "@#{instance_var_name} = value"
              next
            else
              class_name = instance_var.class.name
            end
          end

          value = $xml_util.class_for(class_name).from_xml(child_elem)
          object.instance_eval "@#{instance_var_name} = value"
        end

        object
      end # from_xml

    end # if including_class...

  end # append_features

end # module


