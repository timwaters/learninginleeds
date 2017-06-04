#From: http://www.justinweiss.com/articles/how-to-select-database-records-in-an-arbitrary-order/
module Extensions
  module ActiveRecord
    module FindByOrderedIds
    extend ActiveSupport::Concern
    module ClassMethods
      def find_ordered(ids)
        order_clause = "CASE id "
        ids.each_with_index do |id, index|
          order_clause << sanitize_sql_array(["WHEN ? THEN ? ", id, index])
        end
        order_clause << sanitize_sql_array(["ELSE ? END", ids.length])
        where(id: ids).order(order_clause)
      end
    end
  end
end
end


module WillPaginate
    module ActionView
        def will_paginate(collection = nil, options = {})
            options[:renderer] ||= BootstrapLinkRenderer
            super.try :html_safe
        end

    class BootstrapLinkRenderer < LinkRenderer
        protected

        def html_container(html)
            tag :ul, html, container_attributes
        end

        def page_number(page)
            tag :li, link(page, page, :rel => rel_value(page)), :class => ('active' if page == current_page)
        end

        def previous_or_next_page(page, text, classname)
            tag :li, link(text, page || '#'), :class => [classname[0..3], classname, ('disabled' unless page)].join(' ')
        end

        def gap
            tag :li, link(super, '#'), :class => 'disabled'
        end

        end
    end
end