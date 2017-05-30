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


ActiveRecord::Base.include(Extensions::ActiveRecord::FindByOrderedIds)


module Geokit::ActsAsMappable
  module ClassMethods
    # Overwrite Geokit `within`
    def within(distance, options = {})
      options[:within] = distance

      # Have to copy the options because `build_distance_sql` will delete them.
      conditions = distance_conditions(options.dup)
      sql = build_distance_sql(options)
      self.select(
        "#{sql} AS #{self.distance_column_name}, #{table_name}.*"
      ).where(conditions)
    end

    # Overwrite Geokit `by_distance`
    def by_distance(options = {})
      sql = build_distance_sql(options)
      self.select("#{sql} AS #{self.distance_column_name}, #{table_name}.*"
      ).order("case when #{self.distance_column_name} is null then 1 else 0 end, #{self.distance_column_name} ASC ")
    end
  

    private

    # Copied from geokit-rails/lib/geokit-rails/acts_as_mappable.rb
    # Extract distance_sql building to method `build_distance_sql`.
    def build_distance_sql(options)
      origin  = extract_origin_from_options(options)
      units   = extract_units_from_options(options)
      formula = extract_formula_from_options(options)

      distance_sql(origin, units, formula)
    end
  end
end



