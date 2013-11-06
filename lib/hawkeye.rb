module Hawkeye

  require 'eggs'
  require 'hawkeye'
  require 'pry'
  require 'nokogiri'
  require 'sanitize'

  #def self.show(memory) #=> latest_change
  def self.show(memory)
    x = set_defaults(memory)
    return show_latest(x)
  end

  #def self.refresh(memory, url, css_selector, top_id) #=> new_memory
  def self.refresh(memory, url, css_selector, item_tag, top_id)
    x = set_defaults(memory, url, css_selector, item_tag, top_id)
    if x[:refresh_ready]
      x = add_new(x)
      x = add_old(x)
      x = add_diff(x)
      x = prepend_diff(x)
    end
    return x[:memory]
  end

  def self.show_latest(x)
    return x[:memory].to_s.split(x[:split_tag]).first
  end

  def self.set_defaults(memory, url=nil, css_selector=nil, item_tag="p", top_id="_top_")
    x={}
    x[:memory] = memory 
    x[:url] = url 
    x[:css_selector] = css_selector
    x[:item_tag] = item_tag 
    x[:top_id] = top_id 
    x[:refresh_ready] = ((url.to_s!="") and (css_selector.to_s!="") and (item_tag.to_s!="") and (top_id.to_s!=""))
    x[:base_url] = x[:url].to_s.split("/")[0..2].join("/") + "/"
    x[:split_tag] = "<!-- split_tag --><!-- #{Time.now.to_s} -->"
    return x
  end

  def self.prepend_diff(x)
    if (x[:diff].to_s!="")
      x[:memory] = ((x[:diff]) + (x[:split_tag]) + (x[:diff_old]) )
    else
      x[:memory] = ((x[:split_tag]) + (x[:diff_old]) )
    end
    return x
  end

  def self.add_diff(x)

    old_a, old_hsh = get_diff_a_and_hsh(x[:css_selector], x[:old_docs])
    new_a, new_hsh = get_diff_a_and_hsh(x[:css_selector], x[:new_docs])
    diff_a = (new_a - old_a)

    diff_s = ""
    for diff in diff_a
      if (Sanitize.clean( ( (new_hsh[diff]) ) ).to_s!="")
        diff_s << "<#{x[:item_tag]}>#{new_hsh[diff]}</#{x[:item_tag]}>"
        diff_s << "<center><a href='##{x[:top_id]}'>###</a></center>"
        diff_s << "<hr />"
      end
    end
    x[:diff] = diff_s

    pre_diff_s = ""
    diff_s = ""
    not_full = true
    while ((old_a.to_a.size.to_i!=0) and not_full)
      diff = old_a.shift
      pre_diff_s = new_hsh[diff].to_s
      if (diff_s + pre_diff_s).size.to_i>7000
        not_full = false
      else
        not_full = true
        diff_s << pre_diff_s
      end
    end
    x[:diff_old] = diff_s

    return x
  end

  def self.get_diff_a_and_hsh(css_selector, docs)
    doc_a = []
    doc_hsh = {}
    css_selector = css_selector.split(" ").last
    for doc in docs.css(css_selector)
      d = 1
      doc_s = doc.to_s
      a = doc_s.gsub(/[^a-zA-Z]/i,'').to_s.downcase
      aa = a.split('').uniq
      for b in aa
        d += b.ord
        d *= a.scan(b).size
      end
      doc_id = d.to_s
      unless doc_a.include?(doc_id)
        doc_a << doc_id
        doc_hsh[doc_id] = doc_s
      end
    end
    return doc_a, doc_hsh
  end

  def self.add_old(x)
    x = add_old_content(x)
    x = add_old_docs(x)
    return x
  end

  def self.add_new(x)
    x = add_new_content(x)
    x = fix_new_content_base_url(x)
    x = fix_new_content_base_url_target(x)
    x = add_new_docs(x)
    return x
  end

  def self.fix_new_content_base_url_target(x)
    content = x[:new_content]
    content = content.to_s.gsub("href=", "target='_blank' href=")
    x[:new_content] = content
    return x
  end

  def self.fix_new_content_base_url(x)
    base_url = x[:base_url]
    content = x[:new_content]
    content = get_content_mix_base_url_selector(base_url, content, "href=\"")
    content = get_content_mix_base_url_selector(base_url, content, "href=\'")
    content = get_content_mix_base_url_selector(base_url, content, "src=\"")
    content = get_content_mix_base_url_selector(base_url, content, "src=\'")
    env_base_url = (base_url+"/") 
    content = content.gsub(env_base_url, base_url)
    double_base_url = base_url + base_url
    content = content.gsub(double_base_url, base_url)
    mutant_base_url = (base_url+"http") 
    content = content.gsub(mutant_base_url, "http")
    x[:new_content] = content
    return x
  end

  def self.get_content_mix_base_url_selector(base_url, content, selector)
    selector_with_base_url = selector + base_url
    content = content.to_s.gsub(selector, selector_with_base_url)
    return content.to_s
  end


  def self.add_new_docs(x)
    x[:new_docs] = Nokogiri::HTML(x[:new_content])
    return x
  end

  def self.add_old_docs(x)
    x[:old_docs] = Nokogiri::HTML(x[:old_content])
    return x
  end

  def self.mix_base_url_to_doc(element, doc, base_url)

    doc_element = doc[element]
    if (doc_element.to_s!="") and !get_first_match(doc_element, element)
      doc_element_a = doc_element.split("")
      if (doc_element_a.first == "/")
        doc_element_a.shift
        doc_element = doc_element_a.join
      end
      doc[element] = base_url + doc_element
      doc["target"] = "_blank" if element=="href"
    end
    return doc
  end

  def self.add_new_content(x)
    begin
      if (x[:url].to_s!="")
        if x[:url]=="http://test.html"
          x[:new_content] = "
          <html><body>
            <p><a href='http://www.abcbots.com/test'>Static</a></p>
            <p><a href='http://www.abcbots.com/test'>Dynamic: #{pass=Eggs.key(10)}</a></p>
            <p><a href='http://www.abcbots.com/test'>Dynamic: #{pass}</a></p>
          </body></html>"
        else
          x[:new_content] = open(source_url.to_s).read.to_s.gsub("@", " @")
        end
      else
        x[:new_content] = ""
      end
    rescue
      x[:new_content] = "(Access Denied)"
    end
    return x
  end

  def self.add_old_content(x)
    x[:old_content] = x[:memory].to_s
    return x
  end

  # Hola.hi #=> "Hello World!"
  def self.hi
    puts "Hello World!"
    return "Hello World!"
  end

  # Hola.get_url("http://www.google.com") #=> "<html>...</html>"
  def self.get_url(a="")
    content = open(a.to_s).read.to_s.gsub("@", " @_")
    docs = Nokogiri::HTML(content)
    docs = docs.to_s.gsub(" @_", "@").to_s
    puts a+": "+docs
    return docs.to_s
  end

end
