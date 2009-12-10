##
# Copyright (c) 2009 Rahmal Conda <rahmal@gmail.com>
#
# Utility methods for processing xml resource files
# xml resources are xml files used to pass request
# and response data between web services and clients.
class XmlResourceUtil
  include Singleton

  ##
  # Utility method convert XML element text from String into the
  # appropriate simple type (i.e. integer, float, or string). It
  # just returns the given object if it is a String or non-simple
  # type class.
  #
  # Examples:
  #          simple_type "2"    => 2
  #          simple_type "2.5"  => 2.5
  #          simple_type "text" => "text"
  #          simple_type <obj>  => obj
  def simple_type text
    Integer(text) rescue Float(text) rescue text
  end

  ##
  # Returns true if given item is a string or a numeric object. It's
  # used to determine if the object can be serialized without using
  # a class/type in the XML output.
  #
  def simple_type? item
    item.kind_of?(String) || item.kind_of?(Numeric)
  end

  ##
  # Utility method finds a class within a module hierarchy
  def class_for name
    sub_classes = name.split(/-/)

    # Start with object a the top of the hierarchy,
    # and traverse until we reach the correct class.
    parent = Object
    _class = sub_classes.each do |child|
      parent = parent.const_get(child)
    end

    _class
  end


  def config
    return @config unless @config.nil?
    conf_dir = File.expand_path(CONFIG_ROOT) if CONFIG_ROOT
    unless conf_dir
      root_dir = RAILS_ROOT if RAILS_ROOT
      root_dir = APP_ROOT if APP_ROOT && root_dir.nil?
      root_dir = File.dirname(__FILE__) unless root_dir
      root_dir = File.expand_path(root_dir)
      conf_dir = File.join(root_dir, 'config')
    end
    conf_file = File.join(conf_dir, 'xml_resource.yml')
    @config = YAML::load(File.open(conf_file))
  end

end

$xml_util = XmlResourceUtil.instance
