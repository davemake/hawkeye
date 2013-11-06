require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

  require 'hawkeye'
  require 'pry'
  require 'nokogiri'

describe "Hawkeye usage" do

  it "refresh and show change in content" do
    puts
    puts "# == Hawkeye.show(memory)"
    puts "memory = \"#{memory=''}\""
    puts "url = #{url="http://test.html"}"
    puts "css_selector = #{css_selector='a'}"
    puts "item_tag = #{item_tag='ul'}"
    puts "top_id = #{top_id='top'}"
    puts "memory = Hawkeye.refresh(memory, url, css_selector, item_tag, top_id)"
    puts "memory #=> #{memory=Hawkeye.refresh(memory, url, css_selector, item_tag, top_id)}"
    puts "Hawkeye.show(memory) #=> \"#{Hawkeye.show(memory)}\""
    puts "memory = Hawkeye.refresh(memory, url, css_selector, item_tag, top_id)"
    puts "memory #=> #{memory=Hawkeye.refresh(memory, url, css_selector, item_tag, top_id)}"
    puts "Hawkeye.show(memory) #=> \"#{Hawkeye.show(memory)}\""
    puts "memory = Hawkeye.refresh(memory, url, css_selector, item_tag, top_id)"
    puts "memory #=> #{memory=Hawkeye.refresh(memory, url, css_selector, item_tag, top_id)}"
    puts "Hawkeye.show(memory) #=> \"#{Hawkeye.show(memory)}\""
  end

end
