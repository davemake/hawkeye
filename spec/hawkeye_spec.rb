require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'hawkeye'

describe "Hawkeye" do

  test "refresh" do
    memory = ""
    puts memory = HtmlRadar.refresh(memory, "http://test.html", "a", "ul", "_123_")
  end

  test "show" do
    puts
    puts "# == Hawkeye.show(memory)"
    puts "memory = #{memory='<p><a href=\'test.html\'>Dynamic</a></p><!-- split_tag --><p><a href=\'test.html\'>Static</a></p>'}"
    HtmlRadar.show(memory).should include("Static")
    HtmlRadar.show(memory).should_not include("Dynamic")
    puts HtmlRadar.show(memory)
  end

end
