module ApplicationHelper

  def snippet(text, wordcount, url=nil)
    if text
      main_text = text.split[0..(wordcount-1)].join(" ")
      
      ending_text = ""
      if text.split.size > wordcount
        ending_text = "..."
        if url
          ending_text = "..." + link_to("(more)", url)
        end
      end

      text = main_text + ending_text
      text.html_safe
    end
  end

  def snippet_and_link(text, wordcount, url)
    if text
      main_text = text.split[0..(wordcount-1)].join(" ")
      if text.split.size > wordcount
        ending_text = "…" + link_to("(more)", url)
      else
        ending_text = " " + link_to("(more)", url)

      end
      
      text = main_text + ending_text
      text.html_safe
    end
  end

  def snippet_and_link_and_title(text, title, wordcount, url)
    if text
      main_text = text.split[0..(wordcount-1)].join(" ")
      if text.split.size > wordcount
        ending_text = "...(" + link_to("Read more - #{title}", url) +")"
      else
        ending_text = " "

      end
      
      text = main_text + ending_text
      text.html_safe
    end
  end


  def phone_format(num)
    number = num.clone
    if number.starts_with?("0113") 
      return number.insert(4," ")
    elsif number.starts_with?("07") || number.starts_with?("01226")
      return number.insert(5," ")
    else
      return number
    end
  end

  #sanitze text, not allowing div for layout changes or style for formatting changes 
  #     :elements        => Sanitize::Config::RELAXED[:elements] - ['div', 'style'],
  def sanitizemarkdown(text)
    Sanitize.clean(text, Sanitize::Config.merge(Sanitize::Config::RELAXED,
      :elements        => Sanitize::Config::RELAXED[:elements],
      :remove_contents => true
    )).html_safe
  end

  #helper used to convert metres into km for more readable display
  def format_distance(metres)
    if metres >= 1000
      "#{number_with_precision(metres / 1000.0, precision: 2, strip_insignificant_zeros: true)} km"
    else
      "#{metres} m"
    end
  end

end
