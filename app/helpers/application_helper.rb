module ApplicationHelper

  def snippet(text, wordcount, resource=nil)
    if text
      main_text = text.split[0..(wordcount-1)].join(" ")
      
      ending_text = ""
      if text.split.size > wordcount
        ending_text = "..."
        if resource
          ending_text = "..." + link_to("(more)", resource)
        end
      end

      text = main_text + ending_text
      text.html_safe
    end
  end

end
