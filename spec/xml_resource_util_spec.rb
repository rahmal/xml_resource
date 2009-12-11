root_dir = File.dirname(__FILE__)

$LOAD_PATH << File.join(root_dir,"..","lib")

#TODO: Do I need a spec_helper?
#require 'spec_helper'
#require File.expand_path(File.dirname(__FILE__) + "spec_helper")

describe "xml resource helper class" do

  it "should be a singleton witth only one instance" do
    lambda {require 'xml_resource_util'}.should_not raise_error

    XmlResourceUtil.instance.should_not be_nil

    XmlResourceUtil.instance.kind_of?(Singleton).should be_true

    instance1 = XmlResourceUtil.instance
    instance2 = XmlResourceUtil.instance

    instance1.should equal instance2
  end

  it "should have a global accessor" do
    $xml_util.should_not be_nil

    $xml_util.is_a?(XmlResourceUtil).should be_true

    $xml_util.should equal XmlResourceUtil.instance
  end

  it "manage simple types" do
    $xml_util.simple_type?("").should be_true
    $xml_util.simple_type?("text").should be_true
    $xml_util.simple_type?(2).should be_true
    $xml_util.simple_type?(3000000000).should be_true
    $xml_util.simple_type?(2.5).should be_true
    $xml_util.simple_type?(0.137835).should be_true

    $xml_util.simple_type?(nil).should be_false
    $xml_util.simple_type?(Object.new).should be_false
  end

  it "should find correct classes" do

  end

  it "load xml resource config" do

  end

end
