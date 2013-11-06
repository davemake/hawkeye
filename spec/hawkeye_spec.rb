require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

  require 'hawkeye'
  require 'pry'
  require 'nokogiri'

describe "Hawkeye" do

  it "refreshes" do
    puts
    puts "# == Hawkeye.refresh(memory, url, css_selector, item_tag, top_id)"
    puts "memory = #{memory=''}"
    puts "url = #{url="http://test.html"}"
    puts "css_selector = #{css_selector='a'}"
    puts "item_tag = #{item_tag='ul'}"
    puts "top_id = #{top_id='top'}"
    change=Hawkeye.refresh(memory, url, css_selector, item_tag, top_id)
    puts "change = Hawkeye.refresh(memory, url, css_selector, item_tag, top_id) #=> #{change}"
    puts
    puts "Hawkeye.show(change) #=> #{change}"
    change=Hawkeye.refresh(change, url, css_selector, item_tag, top_id)
    puts "change = Hawkeye.refresh(change, url, css_selector, item_tag, top_id) #=> #{change}"
    puts
    puts "Hawkeye.show(change) #=> #{change}"
  end

  it "shows" do
    puts
    puts "# == Hawkeye.show(memory)"
    puts "memory = #{memory=''}"
    puts "url = #{url="http://test.html"}"
    puts "css_selector = #{css_selector='a'}"
    puts "item_tag = #{item_tag='ul'}"
    puts "top_id = #{top_id='top'}"
    puts
    puts "Hawkeye.show(memory) #=> #{memory}"
    memory=Hawkeye.refresh(memory, url, css_selector, item_tag, top_id)
    puts "memory = Hawkeye.refresh(memory, url, css_selector, item_tag, top_id) #=> #{memory}"
    puts
    puts "Hawkeye.show(memory) #=> #{memory}"
    memory=Hawkeye.refresh(memory, url, css_selector, item_tag, top_id)
    puts "memory = Hawkeye.refresh(memory, url, css_selector, item_tag, top_id) #=> #{memory}"
    puts
    puts "Hawkeye.show(memory) #=> #{memory}"
  end

end
