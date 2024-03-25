html = "<p>outside</p>\n<li>• 1</li>\n<li>• 2</li>\n<p>inside</p><h2>ss</h2>\n<li>• 3</li>\n<li>• 4</li>\n<p>out2</p>"

raw = "<p>A workshop aimed at supporting learners who are new to the world of\ndigital, have little experience of using tech and who want to learn new\nskills or refresh and update their knowledge. Learners will be able to\nchoose from a range of topics including:</p>\n<li>Learning how to use laptops, smartphones and also tablets</li>\n<li>Using apps such as Microsoft Word and Google Sheets to create\nsimple documents such as a sheet to help manage finances</li>\n<li>Learn how to communicate electronically using e-mail and other\nsocial media apps</li>\n<li>Using the internet to access goods and services for example to\napply for Universal Credit</li>\n<li>Learning how to keep themselves and their families safe when\non-line</li>\n"

# raw = "<p>outside</p>
# <p>• 1</p>
# <p>• 2</p>
# <p>inside</p>
# <p>• 3</p>
# <p>• 4</p>
# <p>out2</p"

require 'nokogiri'
require 'timeout'
p = Thread.new do
rawdoc = Nokogiri::HTML.fragment(raw)

rawdoc.css('p:contains("•")').each do | n |
  li = Nokogiri::XML::Node.new("li", rawdoc)
  puts "ncont", n.content.inspect
  li.content = n.content.gsub('•','').strip
  n.replace li
end

html = rawdoc.to_html

doc = Nokogiri::HTML.fragment(html)

group = nil
last_nonelement = nil
lastb4 = doc.element_children.last()


  doc.element_children.each do | node |
    puts "node", node
    if node.name == "li"
        group =  Nokogiri::XML::Node.new "ul", doc if group.nil?
        group.add_child(node)
    end
    if node.name != "li"
      last_nonelement = node
      puts "nope"
      node.add_next_sibling(group) unless group.nil?
      group = nil
    end

    if lastb4 == node && group
      puts "group here", group
      node.add_next_sibling(group) ##this will hang it
      # last_nonelement.add_next_sibling(group)
      group = nil
    end
  end    

end

puts "outside"
if p.join( 5 ).nil? then
  #here thread p is still working
  p.kill
else
  puts "done"
  #here thread p completed before 'period_in_seconds' 
end   
             #
puts "----"
puts doc