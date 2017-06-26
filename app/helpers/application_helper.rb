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


  def phone_format(number)
    if number.starts_with?("0113") 
      return number.insert(4," ")
    elsif number.starts_with?("07") || number.starts_with?("01226")
      return number.insert(5," ")
    else
      return number
    end
  end

end
