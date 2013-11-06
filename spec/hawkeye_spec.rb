require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

  require 'hawkeye'
  require 'pry'
  require 'nokogiri'

describe "Hawkeye" do

  it "refresh" do
    memory = ""
    puts memory = Hawkeye.refresh(memory, "http://test.html", "a", "ul", "_123_")
  end

  it "show" do
    puts
    puts "# == Hawkeye.show(memory)"
    puts "memory = #{memory='<p><a href=\'test.html\'>Dynamic</a></p><!-- split_tag --><p><a href=\'test.html\'>Static</a></p>'}"
    Hawkeye.show(memory).should include("Static")
    Hawkeye.show(memory).should_not include("Dynamic")
    puts Hawkeye.show(memory)
  end

end
