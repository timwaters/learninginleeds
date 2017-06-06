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

#from https://gist.github.com/oparrish/1248807 by @oparrish
# will paginate link renderer for bootstrap 3
require 'will_paginate/view_helpers/link_renderer'
require 'will_paginate/view_helpers/action_view'

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

if defined?(WillPaginate)
  module WillPaginate
    module ActiveRecord
      module RelationMethods
        alias_method :per, :per_page
        alias_method :num_pages, :total_pages
        alias_method :total_count, :total_entries
      end
    end
  end
end

module ActiveRecord
  class Relation
    alias_method :total_count, :count
  end
end

